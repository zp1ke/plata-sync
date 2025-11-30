import 'dart:math';

import 'package:flutter/foundation.dart' hide Category;
import 'package:plata_sync/core/data/models/sort_param.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/data/interfaces/account_data_source.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/transactions/data/interfaces/transaction_data_source.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';

enum TransactionSortOrder {
  dateAsc(isDescending: false),
  dateDesc(isDescending: true),
  amountAsc(isDescending: false),
  amountDesc(isDescending: true);

  final bool isDescending;
  const TransactionSortOrder({required this.isDescending});
}

class TransactionsManager {
  final TransactionDataSource _dataSource;

  TransactionsManager(this._dataSource) {
    loadTransactions();
  }

  final ValueNotifier<List<Transaction>> transactions = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> currentAccountFilter = ValueNotifier(null);
  final ValueNotifier<String?> currentCategoryFilter = ValueNotifier(null);
  final ValueNotifier<TransactionSortOrder> sortOrder = ValueNotifier(
    TransactionSortOrder.dateDesc,
  );
  final ValueNotifier<ViewMode> viewMode = ValueNotifier(ViewMode.list);

  Future<void> createSampleData() async {
    isLoading.value = true;
    try {
      await _createSampleData();
      await loadTransactions();
    } catch (e) {
      debugPrint('Error creating sample data: $e');
      rethrow;
    }
  }

  Future<void> _createSampleData() async {
    final accountDataSource = getService<AccountDataSource>();
    final categoryDataSource = getService<CategoryDataSource>();

    final accounts = await accountDataSource.getAll();
    final categories = await categoryDataSource.getAll();

    if (accounts.isEmpty || categories.isEmpty) {
      return;
    }

    final random = Random();
    final today = DateTime.now();

    // Create 1 expense transaction
    final expenseAccount = accounts[random.nextInt(accounts.length)];
    final expenseCategory = categories[random.nextInt(categories.length)];
    final expense = Transaction.create(
      accountId: expenseAccount.id,
      categoryId: expenseCategory.id,
      amount: -(random.nextInt(10000) + 1000), // -$10 to -$110
      accountBalanceBefore: expenseAccount.balance,
      notes: 'Sample expense transaction',
      createdAt: today,
    );

    // Create 1 income transaction
    final incomeAccount = accounts[random.nextInt(accounts.length)];
    final incomeCategory = categories[random.nextInt(categories.length)];
    final income = Transaction.create(
      accountId: incomeAccount.id,
      categoryId: incomeCategory.id,
      amount: random.nextInt(50000) + 10000, // $100 to $600
      accountBalanceBefore: incomeAccount.balance,
      notes: 'Sample income transaction',
      createdAt: today,
    );

    try {
      await addTransaction(expense);
      await addTransaction(income);
    } catch (e) {
      // Ignore duplicate entries if createSampleData is called multiple times
    }
  }

  Future<void> loadTransactions({String? accountId, String? categoryId}) async {
    isLoading.value = true;
    if (accountId != null) {
      currentAccountFilter.value = accountId;
    }
    if (categoryId != null) {
      currentCategoryFilter.value = categoryId;
    }
    try {
      final filter = <String, dynamic>{};
      if (currentAccountFilter.value != null) {
        filter['accountId'] = currentAccountFilter.value;
      }
      if (currentCategoryFilter.value != null) {
        filter['categoryId'] = currentCategoryFilter.value;
      }

      transactions.value = await _dataSource.getAll(
        filter: filter.isNotEmpty ? filter : null,
      );
      _sortTransactions();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final newTransaction = await _dataSource.create(transaction);
      transactions.value = [...transactions.value, newTransaction];
      _sortTransactions();
      await _updateAssociatedEntities(newTransaction);
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final updatedTransaction = await _dataSource.update(transaction);
      final currentList = [...transactions.value];
      final index = currentList.indexWhere(
        (t) => t.id == updatedTransaction.id,
      );
      if (index != -1) {
        currentList[index] = updatedTransaction;
        transactions.value = currentList;
      }
      await _updateAssociatedEntities(updatedTransaction);
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      // Get the transaction before deleting to know its account and timestamp
      final transactionToDelete = await _dataSource.read(id);
      if (transactionToDelete == null) {
        throw Exception('Transaction with id $id not found');
      }

      final accountId = transactionToDelete.accountId;
      final deletedAt = transactionToDelete.createdAt;

      // Update account balances to reverse the transaction effect
      await _reverseTransactionEffect(transactionToDelete);

      // Delete the transaction
      await _dataSource.delete(id);

      // Recalculate balances for all subsequent transactions on the same account
      await _recalculateBalancesAfter(accountId, deletedAt);

      // If it's a transfer, also recalculate target account balances
      if (transactionToDelete.isTransfer &&
          transactionToDelete.targetAccountId != null) {
        await _recalculateBalancesAfter(
          transactionToDelete.targetAccountId!,
          deletedAt,
        );
      }

      // Reload transactions from data source to get updated balances
      await loadTransactions();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  /// Recalculates accountBalanceBefore for all transactions after the given timestamp
  /// on the specified account
  Future<void> _recalculateBalancesAfter(
    String accountId,
    DateTime afterDate,
  ) async {
    // Get transactions after the deleted transaction, sorted by date
    final transactionsToUpdate = await _dataSource.getAll(
      filter: {'accountId': accountId, 'from': afterDate},
      sort: SortParam('createdAt', ascending: true),
    );

    // Filter out the exact afterDate timestamp (we only want transactions AFTER)
    final filteredTransactions = transactionsToUpdate
        .where((t) => t.createdAt.isAfter(afterDate))
        .toList();

    if (filteredTransactions.isEmpty) return;

    // Get the balance before the first transaction that needs updating
    // We need to fetch the previous transaction to get the correct starting balance
    final previousTransactions = await _dataSource.getAll(
      filter: {'accountId': accountId, 'to': afterDate},
      sort: SortParam('createdAt', ascending: true),
    );

    int currentBalance;
    if (previousTransactions.isNotEmpty) {
      // Use the balance after the last transaction before our range
      currentBalance = previousTransactions.last.accountBalanceAfter;
    } else {
      // No previous transactions, start from 0
      currentBalance = 0;
    }

    // Recalculate and update each transaction
    for (final transaction in filteredTransactions) {
      final updatedTransaction = transaction.copyWith(
        accountBalanceBefore: currentBalance,
      );
      await _dataSource.update(updatedTransaction);
      currentBalance = updatedTransaction.accountBalanceAfter;
    }
  }

  void setSortOrder(TransactionSortOrder order) {
    sortOrder.value = order;
    _sortTransactions();
  }

  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  void clearFilters() {
    currentAccountFilter.value = null;
    currentCategoryFilter.value = null;
    loadTransactions();
  }

  /// Reverses the effect of a transaction on account balances
  Future<void> _reverseTransactionEffect(Transaction transaction) async {
    final accountsManager = getService<AccountsManager>();

    // Reverse the effect on the source account
    final sourceAccount = await accountsManager.getAccountById(
      transaction.accountId,
    );

    if (sourceAccount != null) {
      // Subtract the transaction amount to reverse its effect
      final newBalance = sourceAccount.balance - transaction.amount;
      await accountsManager.updateAccount(
        sourceAccount.copyWith(balance: newBalance),
      );
    }

    // Reverse the effect on the target account for transfers
    if (transaction.isTransfer && transaction.targetAccountId != null) {
      final targetAccount = await accountsManager.getAccountById(
        transaction.targetAccountId!,
      );

      if (targetAccount != null) {
        // For transfers, subtract the absolute amount from target account
        final transferAmount = transaction.amount.abs();
        final newBalance = targetAccount.balance - transferAmount;
        await accountsManager.updateAccount(
          targetAccount.copyWith(balance: newBalance),
        );
      }
    }

    // Reload accounts to reflect balance changes
    accountsManager.loadAccounts();
  }

  void _sortTransactions() {
    final sorted = [...transactions.value];
    switch (sortOrder.value) {
      case TransactionSortOrder.dateAsc:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case TransactionSortOrder.dateDesc:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case TransactionSortOrder.amountAsc:
        sorted.sort((a, b) => a.amount.compareTo(b.amount));
      case TransactionSortOrder.amountDesc:
        sorted.sort((a, b) => b.amount.compareTo(a.amount));
    }
    transactions.value = sorted;
  }

  /// Updates associated account(s) balance and lastUsed, and category lastUsed
  Future<void> _updateAssociatedEntities(Transaction transaction) async {
    final now = DateTime.now();
    final accountsManager = getService<AccountsManager>();

    // Update source account
    final sourceAccount = await accountsManager.getAccountById(
      transaction.accountId,
    );

    if (sourceAccount != null) {
      // Calculate new balance
      final newBalance = sourceAccount.balance + transaction.amount;
      await accountsManager.updateAccount(
        sourceAccount.copyWith(balance: newBalance, lastUsed: now),
      );
    }

    // Update target account for transfers
    if (transaction.isTransfer && transaction.targetAccountId != null) {
      final targetAccount = await accountsManager.getAccountById(
        transaction.targetAccountId!,
      );

      if (targetAccount != null) {
        // For transfers, add the absolute amount to target account
        final transferAmount = transaction.amount.abs();
        final newBalance = targetAccount.balance + transferAmount;
        await accountsManager.updateAccount(
          targetAccount.copyWith(balance: newBalance, lastUsed: now),
        );
      }
    }

    // Reload accounts to reflect balance changes
    accountsManager.loadAccounts();

    // Update category lastUsed (if not a transfer)
    if (!transaction.isTransfer && transaction.categoryId != null) {
      final categoriesManager = getService<CategoriesManager>();
      final category = await categoriesManager.getCategoryById(
        transaction.categoryId!,
      );

      if (category != null) {
        await categoriesManager.updateCategory(
          category.copyWith(lastUsed: now),
        );
        // Reload categories to reflect lastUsed changes
        categoriesManager.loadCategories();
      }
    }
  }

  void dispose() {
    transactions.dispose();
    isLoading.dispose();
    currentAccountFilter.dispose();
    currentCategoryFilter.dispose();
    sortOrder.dispose();
    viewMode.dispose();
  }
}
