import 'package:plata_sync/core/data/models/sort_param.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

class InMemoryCategoryDataSource implements CategoryDataSource {
  final Map<String, Category> _items = {};

  @override
  Future<Category> create(Category item) async {
    if (_items.containsKey(item.id)) {
      throw Exception('Category with id ${item.id} already exists');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<void> delete(String id) async {
    if (!_items.containsKey(id)) {
      throw Exception('Category with id $id not found');
    }
    _items.remove(id);
  }

  @override
  Future<List<Category>> getAll({
    Map<String, dynamic>? filter,
    SortParam? sort,
  }) async {
    var items = _items.values.toList();

    if (filter != null) {
      items = items.where((item) {
        for (var entry in filter.entries) {
          if (entry.key == 'name' && item.name != entry.value) return false;
          if (entry.key == 'id' && item.id != entry.value) return false;
        }
        return true;
      }).toList();
    }

    if (sort != null) {
      items.sort((a, b) {
        int comparison = 0;
        if (sort.field == 'name') {
          comparison = a.name.compareTo(b.name);
        }
        return sort.ascending ? comparison : -comparison;
      });
    }

    return items;
  }

  @override
  Future<Category?> read(String id) async {
    return _items[id];
  }

  @override
  Future<Category> update(Category item) async {
    if (!_items.containsKey(item.id)) {
      throw Exception('Category with id ${item.id} not found');
    }
    _items[item.id] = item;
    return item;
  }
}
