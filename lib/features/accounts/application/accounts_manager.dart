import 'package:flutter/foundation.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/model/enums/view_mode.dart';
import '../../../core/model/object_icon_data.dart';
import '../../../core/services/settings_service.dart';
import '../data/interfaces/account_data_source.dart';
import '../domain/entities/account.dart';
import '../model/enums/sort_order.dart';

class AccountsManager {
  final AccountDataSource _dataSource;

  AccountsManager(this._dataSource) {
    _loadSortOrderFromSettings();
    // Schedule load after frame to avoid notifying listeners during build
    Future.microtask(() => loadAccounts());
  }

  final ValueNotifier<List<Account>> accounts = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> hasLoadedOnce = ValueNotifier(false);
  final ValueNotifier<String> currentQuery = ValueNotifier('');
  final ValueNotifier<AccountSortOrder> sortOrder = ValueNotifier(
    AccountSortOrder.lastUsedDesc,
  );
  final ValueNotifier<ViewMode> viewMode = ValueNotifier(ViewMode.list);

  void _loadSortOrderFromSettings() {
    final settings = getService<SettingsService>();
    final saved = settings.getAccountsSortOrder();
    if (saved != null) {
      sortOrder.value = saved;
    }
  }

  Future<void> createSampleData() async {
    isLoading.value = true;
    try {
      final hasData = await _dataSource.hasData();
      if (!hasData) {
        await _createSampleData();
        await loadAccounts();
      }
    } catch (e) {
      debugPrint('Error creating sample data: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createSampleData() async {
    final accounts = [
      Account.create(
        name: 'Checking Account',
        iconData: ObjectIconData(
          iconName: 'account_balance',
          backgroundColorHex: '#E3F2FD',
          iconColorHex: '#2196F3',
        ),
        description: 'Main checking account',
        balance: 150000, // $1,500.00
      ),
      Account.create(
        name: 'Savings Account',
        iconData: ObjectIconData(
          iconName: 'savings',
          backgroundColorHex: '#E8F5E9',
          iconColorHex: '#4CAF50',
        ),
        description: 'Emergency fund savings',
        balance: 500000, // $5,000.00
      ),
      Account.create(
        name: 'Credit Card',
        iconData: ObjectIconData(
          iconName: 'credit_card',
          backgroundColorHex: '#FFF3E0',
          iconColorHex: '#FF9800',
        ),
        description: 'Visa ending in 1234',
        balance: -25000, // -$250.00 (debt)
      ),
      Account.create(
        name: 'Cash',
        iconData: ObjectIconData(
          iconName: 'payments',
          backgroundColorHex: '#F3E5F5',
          iconColorHex: '#9C27B0',
        ),
        description: 'Physical cash on hand',
        balance: 5000, // $50.00
      ),
    ];

    for (var account in accounts) {
      try {
        await addAccount(account);
      } catch (e) {
        // Ignore duplicate entries if createSampleData is called multiple times
      }
    }
  }

  Future<void> loadAccounts({String? query}) async {
    isLoading.value = true;
    if (query != null) {
      currentQuery.value = query;
    }
    try {
      final filterQuery = query ?? currentQuery.value;
      accounts.value = await _dataSource.getAll(
        filter: filterQuery.isNotEmpty ? {'name': filterQuery} : null,
        sort: sortOrder.value.sortParam(),
      );
    } catch (e) {
      debugPrint('Error loading accounts: $e');
    } finally {
      isLoading.value = false;
      hasLoadedOnce.value = true;
    }
  }

  Future<void> addAccount(Account account) async {
    try {
      await _dataSource.create(account);
      await loadAccounts();
    } catch (e) {
      debugPrint('Error adding account: $e');
      rethrow;
    }
  }

  Future<void> updateAccount(Account account) async {
    try {
      await _dataSource.update(account);
      await loadAccounts();
    } catch (e) {
      debugPrint('Error updating account: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      // Check if account has associated transactions
      final hasTransactions = await _dataSource.hasTransactions(id);

      if (hasTransactions) {
        // Soft delete: disable the account instead of deleting
        final account = await _dataSource.read(id);
        if (account != null) {
          await _dataSource.update(account.copyWith(enabled: false));
        }
      } else {
        // Hard delete: no transactions associated
        await _dataSource.delete(id);
      }
      await loadAccounts();
    } catch (e) {
      debugPrint('Error deleting account: $e');
      rethrow;
    }
  }

  Future<Account?> getAccountById(String id) async {
    try {
      return await _dataSource.read(id);
    } catch (e) {
      debugPrint('Error getting account by id: $e');
      return null;
    }
  }

  void setSortOrder(AccountSortOrder order) {
    sortOrder.value = order;
    // Save to settings
    final settings = getService<SettingsService>();
    settings.setAccountsSortOrder(order);
    loadAccounts();
  }

  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  void dispose() {
    accounts.dispose();
    hasLoadedOnce.dispose();
    isLoading.dispose();
    currentQuery.dispose();
    sortOrder.dispose();
    viewMode.dispose();
  }
}
