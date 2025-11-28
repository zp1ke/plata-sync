import 'package:plata_sync/core/data/models/sort_param.dart';
import 'package:plata_sync/features/transactions/data/interfaces/transaction_data_source.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';

class InMemoryTransactionDataSource extends TransactionDataSource {
  static const _delay = Duration(milliseconds: 500);

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
}
