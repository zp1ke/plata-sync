import 'package:flutter/foundation.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/features/accounts/data/interfaces/account_data_source.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';

enum AccountSortOrder {
  nameAsc(isDescending: false),
  nameDesc(isDescending: true),
  lastUsedAsc(isDescending: false),
  lastUsedDesc(isDescending: true),
  balanceAsc(isDescending: false),
  balanceDesc(isDescending: true);

  final bool isDescending;
  const AccountSortOrder({required this.isDescending});
}

class AccountsManager {
  final AccountDataSource _dataSource;

  AccountsManager(this._dataSource) {
    loadAccounts();
  }

  final ValueNotifier<List<Account>> accounts = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> currentQuery = ValueNotifier('');
  final ValueNotifier<AccountSortOrder> sortOrder = ValueNotifier(
    AccountSortOrder.lastUsedDesc,
  );
  final ValueNotifier<ViewMode> viewMode = ValueNotifier(ViewMode.list);

  Future<void> createSampleData() async {
    isLoading.value = true;
    try {
      await _dataSource.createSampleData();
      await loadAccounts();
    } catch (e) {
      debugPrint('Error creating sample data: $e');
      rethrow;
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
      );
      _sortAccounts();
    } catch (e) {
      debugPrint('Error loading accounts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAccount(Account account) async {
    try {
      final newAccount = await _dataSource.create(account);
      accounts.value = [...accounts.value, newAccount];
      _sortAccounts();
    } catch (e) {
      debugPrint('Error adding account: $e');
      rethrow;
    }
  }

  Future<void> updateAccount(Account account) async {
    try {
      final updatedAccount = await _dataSource.update(account);
      final currentList = [...accounts.value];
      final index = currentList.indexWhere((a) => a.id == updatedAccount.id);
      if (index != -1) {
        currentList[index] = updatedAccount;
        accounts.value = currentList;
      }
    } catch (e) {
      debugPrint('Error updating account: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount(String id) async {
    try {
      await _dataSource.delete(id);
      accounts.value = accounts.value.where((a) => a.id != id).toList();
      _sortAccounts();
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
    _sortAccounts();
  }

  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  void _sortAccounts() {
    final sorted = [...accounts.value];
    switch (sortOrder.value) {
      case AccountSortOrder.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case AccountSortOrder.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
      case AccountSortOrder.lastUsedAsc:
        sorted.sort((a, b) => a.compareByDateTo(b));
      case AccountSortOrder.lastUsedDesc:
        sorted.sort((a, b) => b.compareByDateTo(a));
      case AccountSortOrder.balanceAsc:
        sorted.sort((a, b) => a.balance.compareTo(b.balance));
      case AccountSortOrder.balanceDesc:
        sorted.sort((a, b) => b.balance.compareTo(a.balance));
    }
    accounts.value = sorted;
  }

  void dispose() {
    accounts.dispose();
    isLoading.dispose();
    currentQuery.dispose();
    sortOrder.dispose();
    viewMode.dispose();
  }
}
