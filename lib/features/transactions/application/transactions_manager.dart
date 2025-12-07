import 'dart:math';

import 'package:flutter/foundation.dart' hide Category;
import 'package:plata_sync/core/data/models/sort_param.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/core/services/settings_service.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/data/interfaces/account_data_source.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/transactions/data/interfaces/transaction_data_source.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/features/transactions/model/enums/sort_order.dart';

class TransactionsManager {
  final TransactionDataSource _dataSource;

  TransactionsManager(this._dataSource) {
    _loadSortOrderFromSettings();
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

  void _loadSortOrderFromSettings() {
    final settings = getService<SettingsService>();
    final saved = settings.getTransactionsSortOrder();
    if (saved != null) {
      sortOrder.value = saved;
    }
  }

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
      amount: -(random.nextInt(10000) + 1000),
      // -$10 to -$110
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
      amount: random.nextInt(50000) + 10000,
      // $100 to $600
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

    await loadTransactions();
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
        sort: sortOrder.value.sortParam(),
      );
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final newTransaction = await _dataSource.create(transaction);
      await _updateAssociated(newTransaction);
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction transaction) =>
      _updateTransaction(transaction);

  Future<void> _updateTransaction(
    Transaction transaction, {
    bool updateAssociated = true,
  }) async {
    try {
      final updatedTransaction = await _dataSource.update(transaction);
      if (updateAssociated) {
        await _updateAssociated(updatedTransaction);
      }
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
      await _dataSource.delete(id);
      await _updateAssociated(transactionToDelete, deleted: true);
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  void setSortOrder(TransactionSortOrder order) {
    sortOrder.value = order;
    // Save to settings
    final settings = getService<SettingsService>();
    settings.setTransactionsSortOrder(order);
    loadTransactions();
  }

  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  void clearFilters() {
    currentAccountFilter.value = null;
    currentCategoryFilter.value = null;
    loadTransactions();
  }

  /// Updates associated account(s) balance and lastUsed, and category lastUsed
  Future<void> _updateAssociated(
    Transaction transaction, {
    bool deleted = false,
  }) async {
    final lastUsed = deleted ? null : DateTime.now();
    final accountsManager = getService<AccountsManager>();

    // Update source account
    final sourceAccount = await accountsManager.getAccountById(
      transaction.accountId,
    );
    if (sourceAccount != null) {
      await _updateAccountBalanceAndLastUsed(
        accountsManager,
        sourceAccount,
        transaction.createdAt.add(Duration(milliseconds: 1)),
        lastUsed,
        deleted
            ? transaction.accountBalanceBefore
            : transaction.accountBalanceAfter,
      );
    }

    // Update target account for transfers
    if (transaction.isTransfer && transaction.targetAccountId != null) {
      final targetAccount = await accountsManager.getAccountById(
        transaction.targetAccountId!,
      );
      if (targetAccount != null) {
        await _updateAccountBalanceAndLastUsed(
          accountsManager,
          targetAccount,
          transaction.createdAt.add(Duration(milliseconds: 1)),
          lastUsed,
          deleted
              ? transaction.targetAccountBalanceBefore
              : transaction.targetAccountBalanceAfter,
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
        final transactions = await _dataSource.getAll(
          filter: {
            'categoryId': category.id,
            'from': transaction.createdAt.add(Duration(milliseconds: 1)),
          },
          limit: 1,
          sort: SortParam('createdAt', ascending: false),
        );
        final categoryLastUsed = transactions.isNotEmpty
            ? transactions.first.createdAt
            : lastUsed;
        await categoriesManager.updateCategory(
          category.copyWith(lastUsed: categoryLastUsed),
        );
        // Reload categories to reflect lastUsed changes
        categoriesManager.loadCategories();
      }
    }

    await loadTransactions();
  }

  void dispose() {
    transactions.dispose();
    isLoading.dispose();
    currentAccountFilter.dispose();
    currentCategoryFilter.dispose();
    sortOrder.dispose();
    viewMode.dispose();
  }

  Future<void> _updateAccountBalanceAndLastUsed(
    AccountsManager accountsManager,
    Account account,
    DateTime from,
    DateTime? lastUsed,
    int? initialBalance,
  ) async {
    final transactions = await _dataSource.getAll(
      filter: {'accountId': account.id, 'from': from},
      sort: SortParam('createdAt', ascending: true),
    );
    final transferTransactions = await _dataSource.getAll(
      filter: {'targetAccountId': account.id, 'from': from},
      sort: SortParam('createdAt', ascending: true),
    );
    transactions.addAll(transferTransactions);
    // Sort all transactions by date to ensure proper balance calculation
    transactions.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    var balance = initialBalance ?? IntExtensions.minSafeValue;
    DateTime? lastUsedValue;
    for (final transaction in transactions) {
      // Update lastUsed
      if (lastUsedValue == null) {
        // First assignment
        lastUsedValue = transaction.createdAt;
      } else if (transaction.createdAt.isAfter(lastUsedValue)) {
        // Update to most recent
        lastUsedValue = transaction.createdAt;
      }
      if (transaction.accountId == account.id) {
        // Get balance as source account
        if (balance == IntExtensions.minSafeValue) {
          // First transaction, set initial balance
          balance = transaction.accountBalanceBefore + transaction.amount;
        } else {
          if (transaction.accountBalanceBefore != balance) {
            // Update accountBalanceBefore on transaction
            await _updateTransaction(
              transaction.copyWith(accountBalanceBefore: balance),
              updateAssociated: false,
            );
          }
          // Update balance
          balance += transaction.amount;
        }
      } else if (transaction.targetAccountId == account.id) {
        // Get balance as target account in transfer
        if (balance == IntExtensions.minSafeValue) {
          // First transaction, set initial balance
          balance =
              (transaction.targetAccountBalanceBefore ?? 0) +
              transaction.amount.abs();
        } else {
          if (transaction.targetAccountBalanceBefore != balance) {
            // Update targetAccountBalanceBefore on transfer transaction
            await _updateTransaction(
              transaction.copyWith(targetAccountBalanceBefore: balance),
              updateAssociated: false,
            );
          }
          // Update balance
          balance += transaction.amount.abs();
        }
      }
    }

    if (balance == IntExtensions.minSafeValue) {
      // No transactions, set balance to 0
      balance = 0;
    }
    accountsManager.updateAccount(
      account.copyWith(balance: balance, lastUsed: lastUsedValue),
    );
  }
}
