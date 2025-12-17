import '../../../../core/data/models/sort_param.dart';
import '../interfaces/category_data_source.dart';
import '../../domain/entities/category.dart';

class InMemoryCategoryDataSource extends CategoryDataSource {
  InMemoryCategoryDataSource({int delayMilliseconds = 300})
    : _delay = Duration(milliseconds: delayMilliseconds);

  final Duration _delay;
  final Map<String, Category> _items = {};

  @override
  Future<Category> create(Category item) async {
    await Future.delayed(_delay);
    if (_items.containsKey(item.id)) {
      throw Exception('Category with id ${item.id} already exists');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(_delay);
    if (!_items.containsKey(id)) {
      throw Exception('Category with id $id not found');
    }
    _items.remove(id);
  }

  @override
  Future<List<Category>> getAll({
    Map<String, dynamic>? filter,
    SortParam? sort,
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(_delay);
    var items = _items.values.toList();

    // By default, only show enabled categories unless includeDisabled is true
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
          if (entry.key == 'transactionType') {
            final filterType = entry.value as String;
            // Categories with null transactionType are applicable to all types
            if (item.transactionType != null &&
                item.transactionType!.name != filterType) {
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
        if (sort.field == 'name') {
          comparison = a.name.compareTo(b.name);
        } else if (sort.field == 'lastUsed') {
          comparison = a.compareByDateTo(b);
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
  Future<Category?> read(String id) async {
    await Future.delayed(_delay);
    return _items[id];
  }

  @override
  Future<List<Category>> getByIds(List<String> ids) async {
    await Future.delayed(_delay);
    return ids.map((id) => _items[id]).whereType<Category>().toList();
  }

  @override
  Future<Category> update(Category item) async {
    await Future.delayed(_delay);
    if (!_items.containsKey(item.id)) {
      throw Exception('Category with id ${item.id} not found');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<bool> hasData() {
    return Future.value(_items.isNotEmpty);
  }

  @override
  Future<bool> hasTransactions(String categoryId) async {
    // In-memory implementation would need access to transaction data source
    // For now, return false as in-memory is mainly for testing
    return Future.value(false);
  }

  @override
  Future<int> count({Map<String, dynamic>? filter}) async {
    await Future.delayed(_delay);
    var items = _items.values.toList();

    // By default, only show enabled categories unless includeDisabled is true
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
          if (entry.key == 'transactionType') {
            final filterType = entry.value as String;
            // Categories with null transactionType are applicable to all types
            if (item.transactionType != null &&
                item.transactionType!.name != filterType) {
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
