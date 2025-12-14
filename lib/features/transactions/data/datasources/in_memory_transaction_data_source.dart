import '../../../../core/data/models/sort_param.dart';
import '../interfaces/transaction_data_source.dart';
import '../../domain/entities/transaction.dart';
import '../../ui/widgets/transaction_type_selector.dart';

class InMemoryTransactionDataSource extends TransactionDataSource {
  InMemoryTransactionDataSource({int delayMilliseconds = 300})
    : _delay = Duration(milliseconds: delayMilliseconds);

  final Duration _delay;
  final Map<String, Transaction> _items = {};

  @override
  Future<Transaction> create(Transaction item) async {
    await Future.delayed(_delay);
    if (_items.containsKey(item.id)) {
      throw Exception('Transaction with id ${item.id} already exists');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(_delay);
    if (!_items.containsKey(id)) {
      throw Exception('Transaction with id $id not found');
    }
    _items.remove(id);
  }

  @override
  Future<List<Transaction>> getAll({
    Map<String, dynamic>? filter,
    SortParam? sort,
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(_delay);
    var items = _items.values.toList();

    if (filter != null) {
      items = items.where((item) {
        for (var entry in filter.entries) {
          if (entry.key == 'accountId' && item.accountId != entry.value) {
            return false;
          }
          if (entry.key == 'categoryId' && item.categoryId != entry.value) {
            return false;
          }
          if (entry.key == 'targetAccountId' &&
              item.targetAccountId != entry.value) {
            return false;
          }
          if (entry.key == 'id' && item.id != entry.value) return false;
          if (entry.key == 'from' &&
              item.createdAt.isBefore(entry.value as DateTime)) {
            return false;
          }
          if (entry.key == 'to' &&
              item.createdAt.isAfter(entry.value as DateTime)) {
            return false;
          }
          if (entry.key == 'tagIds') {
            final filterTagIds = entry.value as List<String>;
            // Check if transaction has any of the filter tags
            final hasAnyTag = filterTagIds.any(
              (tagId) => item.tagIds.contains(tagId),
            );
            if (!hasAnyTag) return false;
          }
          if (entry.key == 'transactionType') {
            final transactionType = entry.value as String;
            if (transactionType == TransactionType.expense.name &&
                !item.isExpense) {
              return false;
            }
            if (transactionType == TransactionType.income.name &&
                !item.isIncome) {
              return false;
            }
            if (transactionType == TransactionType.transfer.name &&
                !item.isTransfer) {
              return false;
            }
          }
        }
        return true;
      }).toList();
    }

    if (sort != null) {
      items.sort((a, b) {
        int comparison = 0;
        if (sort.field == 'createdAt') {
          comparison = a.createdAt.compareTo(b.createdAt);
        } else if (sort.field == 'amount') {
          comparison = a.amount.compareTo(b.amount);
        }
        return sort.ascending ? comparison : -comparison;
      });
    }

    if (offset != null) {
      items = items.skip(offset).toList();
    }

    if (limit != null) {
      items = items.take(limit).toList();
    }

    return items;
  }

  @override
  Future<Transaction?> read(String id) async {
    await Future.delayed(_delay);
    return _items[id];
  }

  @override
  Future<Transaction> update(Transaction item) async {
    await Future.delayed(_delay);
    if (!_items.containsKey(item.id)) {
      throw Exception('Transaction with id ${item.id} not found');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<bool> hasData() {
    return Future.value(_items.isNotEmpty);
  }

  @override
  Future<int> count({Map<String, dynamic>? filter}) async {
    await Future.delayed(_delay);
    var items = _items.values.toList();

    if (filter != null) {
      items = items.where((item) {
        for (var entry in filter.entries) {
          if (entry.key == 'accountId' && item.accountId != entry.value) {
            return false;
          }
          if (entry.key == 'categoryId' && item.categoryId != entry.value) {
            return false;
          }
          if (entry.key == 'targetAccountId' &&
              item.targetAccountId != entry.value) {
            return false;
          }
          if (entry.key == 'id' && item.id != entry.value) return false;
          if (entry.key == 'from' &&
              item.createdAt.isBefore(entry.value as DateTime)) {
            return false;
          }
          if (entry.key == 'to' &&
              item.createdAt.isAfter(entry.value as DateTime)) {
            return false;
          }
          if (entry.key == 'tagIds') {
            final filterTagIds = entry.value as List<String>;
            // Check if transaction has any of the filter tags
            final hasAnyTag = filterTagIds.any(
              (tagId) => item.tagIds.contains(tagId),
            );
            if (!hasAnyTag) return false;
          }
          if (entry.key == 'transactionType') {
            final transactionType = entry.value as String;
            if (transactionType == TransactionType.expense.name &&
                !item.isExpense) {
              return false;
            }
            if (transactionType == TransactionType.income.name &&
                !item.isIncome) {
              return false;
            }
            if (transactionType == TransactionType.transfer.name &&
                !item.isTransfer) {
              return false;
            }
          }
        }
        return true;
      }).toList();
    }

    return items.length;
  }
}
