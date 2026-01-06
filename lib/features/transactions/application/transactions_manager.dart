import 'dart:math';

import 'package:flutter/foundation.dart' hide Category;
import '../../../core/data/models/sort_param.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/model/enums/view_mode.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/utils/datetime.dart';
import '../../../core/utils/numbers.dart';
import '../../accounts/application/accounts_manager.dart';
import '../../accounts/domain/entities/account.dart';
import '../../categories/application/categories_manager.dart';
import '../data/interfaces/transaction_data_source.dart';
import '../domain/entities/transaction.dart';
import '../model/enums/date_filter.dart';
import '../model/enums/sort_order.dart';
import '../ui/widgets/transaction_type_selector.dart';

class TransactionsManager {
  final TransactionDataSource _dataSource;

  TransactionsManager(this._dataSource) {
    _loadSortOrderFromSettings();
    _setupFilterListeners();
    loadTransactions();
  }

  final ValueNotifier<List<Transaction>> transactions = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<int> incomeAmount = ValueNotifier(0);
  final ValueNotifier<int> expenseAmount = ValueNotifier(0);

  final ValueNotifier<List<String>?> currentAccountFilter = ValueNotifier(null);
  final ValueNotifier<List<String>?> currentCategoryFilter = ValueNotifier(
    null,
  );
  final ValueNotifier<List<String>?> currentTagFilter = ValueNotifier(null);
  final ValueNotifier<TransactionType?> currentTransactionTypeFilter =
      ValueNotifier(null);
  final ValueNotifier<TransactionSortOrder> sortOrder = ValueNotifier(
    TransactionSortOrder.dateDesc,
  );
  final ValueNotifier<ViewMode> viewMode = ValueNotifier(ViewMode.list);
  final ValueNotifier<DateFilter> currentDateFilter = ValueNotifier(
    DateFilter.today,
  );

  /// Returns true if any filters are currently active
  /// Ignores date filter
  final ValueNotifier<bool> hasActiveFilters = ValueNotifier(false);

  void _loadSortOrderFromSettings() {
    final settings = getService<SettingsService>();
    final saved = settings.getTransactionsSortOrder();
    if (saved != null) {
      sortOrder.value = saved;
    }
  }

  void _setupFilterListeners() {
    currentAccountFilter.addListener(_updateHasActiveFilters);
    currentCategoryFilter.addListener(_updateHasActiveFilters);
    currentTagFilter.addListener(_updateHasActiveFilters);
    currentTransactionTypeFilter.addListener(_updateHasActiveFilters);
  }

  void _updateHasActiveFilters() {
    hasActiveFilters.value =
        (currentAccountFilter.value != null &&
            currentAccountFilter.value!.isNotEmpty) ||
        (currentCategoryFilter.value != null &&
            currentCategoryFilter.value!.isNotEmpty) ||
        (currentTagFilter.value != null &&
            currentTagFilter.value!.isNotEmpty) ||
        currentTransactionTypeFilter.value != null;
  }

  Future<bool> hasAnyData() => _dataSource.hasData();

  Future<void> createSampleData() async {
    isLoading.value = true;
    try {
      final hasData = await _dataSource.hasData();
      if (!hasData) {
        await _createSampleData();
        await loadTransactions();
      }
    } catch (e) {
      debugPrint('Error creating sample data: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createSampleData() async {
    final accountManager = getService<AccountsManager>();
    final categoryManager = getService<CategoriesManager>();

    await accountManager.createSampleData();
    await categoryManager.createSampleData();

    final accounts = accountManager.accounts.value;
    final categories = categoryManager.categories.value;

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

  Future<void> loadTransactions({
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
    TransactionType? transactionType,
    bool clearAccount = false,
    bool clearCategory = false,
    bool clearTags = false,
    bool clearTransactionType = false,
  }) async {
    isLoading.value = true;
    if (clearAccount) {
      currentAccountFilter.value = null;
    } else if (accountIds != null) {
      currentAccountFilter.value = accountIds;
    }

    if (clearCategory) {
      currentCategoryFilter.value = null;
    } else if (categoryIds != null) {
      currentCategoryFilter.value = categoryIds;
    }

    if (clearTags) {
      currentTagFilter.value = null;
    } else if (tagIds != null) {
      currentTagFilter.value = tagIds;
    }

    if (clearTransactionType) {
      currentTransactionTypeFilter.value = null;
    } else if (transactionType != null) {
      currentTransactionTypeFilter.value = transactionType;
    }
    try {
      final filter = <String, dynamic>{};
      if (currentAccountFilter.value != null &&
          currentAccountFilter.value!.isNotEmpty) {
        filter['accountIds'] = currentAccountFilter.value;
      }
      if (currentCategoryFilter.value != null &&
          currentCategoryFilter.value!.isNotEmpty) {
        filter['categoryIds'] = currentCategoryFilter.value;
      }
      if (currentTagFilter.value != null &&
          currentTagFilter.value!.isNotEmpty) {
        filter['tagIds'] = currentTagFilter.value;
      }
      if (currentTransactionTypeFilter.value != null) {
        filter['transactionType'] = currentTransactionTypeFilter.value!.name;
      }

      if (currentDateFilter.value != DateFilter.all) {
        final now = DateTime.now();
        DateTime? from;
        DateTime? to;

        switch (currentDateFilter.value) {
          case DateFilter.today:
            from = now.startOfDay;
            to = now.endOfDay;
            break;
          case DateFilter.week:
            from = now.startOfWeek;
            to = now.endOfWeek;
            break;
          case DateFilter.month:
            from = now.startOfMonth;
            to = now.endOfMonth;
            break;
          case DateFilter.all:
            break;
        }

        if (from != null) filter['from'] = from;
        if (to != null) filter['to'] = to;
      }

      transactions.value = await _dataSource.getAll(
        filter: filter.isNotEmpty ? filter : null,
        sort: sortOrder.value.sortParam(),
      );
      // Calculate income and expense amounts
      int incomeTotal = 0;
      int expenseTotal = 0;
      for (final transaction in transactions.value) {
        if (transaction.amount > 0) {
          incomeTotal += transaction.amount;
        } else {
          expenseTotal += transaction.amount;
        }
      }
      incomeAmount.value = incomeTotal;
      expenseAmount.value = expenseTotal;
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setAccountFilter(List<String>? accountIds) {
    loadTransactions(
      accountIds: accountIds,
      clearAccount: accountIds == null || accountIds.isEmpty,
    );
  }

  void setCategoryFilter(List<String>? categoryIds) {
    loadTransactions(
      categoryIds: categoryIds,
      clearCategory: categoryIds == null || categoryIds.isEmpty,
    );
  }

  void setTagFilter(List<String>? tagIds) {
    loadTransactions(
      tagIds: tagIds,
      clearTags: tagIds == null || tagIds.isEmpty,
    );
  }

  void setTransactionTypeFilter(TransactionType? transactionType) {
    loadTransactions(
      transactionType: transactionType,
      clearTransactionType: transactionType == null,
    );
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

  void setDateFilter(DateFilter filter) {
    currentDateFilter.value = filter;
    loadTransactions();
  }

  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  void clearFilters() {
    currentAccountFilter.value = null;
    currentCategoryFilter.value = null;
    currentTagFilter.value = null;
    currentTransactionTypeFilter.value = null;
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
    incomeAmount.dispose();
    expenseAmount.dispose();
    currentAccountFilter.dispose();
    currentCategoryFilter.dispose();
    currentTagFilter.dispose();
    currentTransactionTypeFilter.dispose();
    sortOrder.dispose();
    viewMode.dispose();
    hasActiveFilters.dispose();
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
    var lastUsedValue = lastUsed;
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
