import '../../../../core/data/models/sort_param.dart';
import '../../../../core/di/service_locator.dart';
import '../../../transactions/data/interfaces/transaction_data_source.dart';
import '../interfaces/account_data_source.dart';
import '../../domain/entities/account.dart';

class InMemoryAccountDataSource extends AccountDataSource {
  InMemoryAccountDataSource({int delayMilliseconds = 300})
    : _delay = Duration(milliseconds: delayMilliseconds);

  final Duration _delay;
  final Map<String, Account> _items = {};

  @override
  Future<Account> create(Account item) async {
    await Future.delayed(_delay);
    if (_items.containsKey(item.id)) {
      throw Exception('Account with id ${item.id} already exists');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(_delay);
    if (!_items.containsKey(id)) {
      throw Exception('Account with id $id not found');
    }
    _items.remove(id);
  }

  @override
  Future<List<Account>> getAll({
    Map<String, dynamic>? filter,
    SortParam? sort,
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(_delay);
    var items = _items.values.toList();

    // By default, only show enabled accounts unless includeDisabled is true
    final includeDisabled = filter?['includeDisabled'] == true;
    if (!includeDisabled) {
      items = items.where((item) => item.enabled).toList();
    }

    if (filter != null) {
      items = items.where((item) {
        for (var entry in filter.entries) {
          // Skip the includeDisabled filter key
          if (entry.key == 'includeDisabled') continue;

          if (entry.key == 'name' &&
              !item.name.toLowerCase().contains(
                entry.value.toString().toLowerCase(),
              )) {
            return false;
          }
          if (entry.key == 'description' &&
              (item.description == null ||
                  !item.description!.toLowerCase().contains(
                    entry.value.toString().toLowerCase(),
                  ))) {
            return false;
          }
          if (entry.key == 'id' && item.id != entry.value) return false;
        }
        return true;
      }).toList();
    }

    if (sort != null) {
      items.sort((a, b) {
        final enabledComparison = a.enabled == b.enabled
            ? 0
            : a.enabled
            ? -1
            : 1;
        if (enabledComparison != 0) {
          return enabledComparison;
        }
        int comparison = 0;
        if (sort.field == 'name') {
          comparison = a.name.compareTo(b.name);
        } else if (sort.field == 'lastUsed') {
          comparison = a.compareByDateTo(b);
        } else if (sort.field == 'balance') {
          comparison = a.balance.compareTo(b.balance);
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
  Future<Account?> read(String id) async {
    await Future.delayed(_delay);
    return _items[id];
  }

  @override
  Future<Account> update(Account item) async {
    await Future.delayed(_delay);
    if (!_items.containsKey(item.id)) {
      throw Exception('Account with id ${item.id} not found');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<bool> hasData() {
    return Future.value(_items.isNotEmpty);
  }

  @override
  Future<bool> hasTransactions(String accountId) async {
    final transactionDataSource = getService<TransactionDataSource>();
    var count = await transactionDataSource.count(
      filter: {'accountId': accountId},
    );
    if (count > 0) {
      return true;
    }
    count = await transactionDataSource.count(
      filter: {'targetAccountId': accountId},
    );
    return count > 0;
  }

  @override
  Future<int> count({Map<String, dynamic>? filter}) async {
    await Future.delayed(_delay);
    var items = _items.values.toList();

    // By default, only show enabled accounts unless includeDisabled is true
    final includeDisabled = filter?['includeDisabled'] == true;
    if (!includeDisabled) {
      items = items.where((item) => item.enabled).toList();
    }

    if (filter != null) {
      items = items.where((item) {
        for (var entry in filter.entries) {
          // Skip the includeDisabled filter key
          if (entry.key == 'includeDisabled') continue;

          if (entry.key == 'name' &&
              !item.name.toLowerCase().contains(
                entry.value.toString().toLowerCase(),
              )) {
            return false;
          }
          if (entry.key == 'description' &&
              (item.description == null ||
                  !item.description!.toLowerCase().contains(
                    entry.value.toString().toLowerCase(),
                  ))) {
            return false;
          }
          if (entry.key == 'id' && item.id != entry.value) return false;
        }
        return true;
      }).toList();
    }

    return items.length;
  }
}
