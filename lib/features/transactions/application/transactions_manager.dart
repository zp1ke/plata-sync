import 'package:flutter/foundation.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
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
      await _dataSource.createSampleData();
      await loadTransactions();
    } catch (e) {
      debugPrint('Error creating sample data: $e');
      rethrow;
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
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _dataSource.delete(id);
      transactions.value = transactions.value.where((t) => t.id != id).toList();
      _sortTransactions();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
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

  void dispose() {
    transactions.dispose();
    isLoading.dispose();
    currentAccountFilter.dispose();
    currentCategoryFilter.dispose();
    sortOrder.dispose();
    viewMode.dispose();
  }
}
