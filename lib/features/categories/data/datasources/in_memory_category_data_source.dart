import 'package:plata_sync/core/data/models/sort_param.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

class InMemoryCategoryDataSource implements CategoryDataSource {
  final Map<String, Category> _items = {
    '1': Category(
      id: '1',
      name: 'Groceries',
      icon: 'shopping_cart',
      backgroundColorHex: '#FFEB3B',
      iconColorHex: '#000000',
    ),
    '2': Category(
      id: '2',
      name: 'Utilities',
      icon: 'bolt',
      backgroundColorHex: '#4CAF50',
      iconColorHex: '#FFFFFF',
    ),
    '3': Category(
      id: '3',
      name: 'Entertainment',
      icon: 'movie',
      backgroundColorHex: '#2196F3',
      iconColorHex: '#FFFFFF',
    ),
  };

  @override
  Future<Category> create(Category item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_items.containsKey(item.id)) {
      throw Exception('Category with id ${item.id} already exists');
    }
    _items[item.id] = item;
    return item;
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
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
    await Future.delayed(const Duration(milliseconds: 300));
    var items = _items.values.toList();

    if (filter != null) {
      items = items.where((item) {
        for (var entry in filter.entries) {
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
        int comparison = 0;
        if (sort.field == 'name') {
          comparison = a.name.compareTo(b.name);
        } else if (sort.field == 'lastUsed') {
          final aDate = a.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0);
          comparison = aDate.compareTo(bDate);
        }
        return sort.ascending ? comparison : -comparison;
      });
    }

    return items;
  }

  @override
  Future<Category?> read(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _items[id];
  }

  @override
  Future<Category> update(Category item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_items.containsKey(item.id)) {
      throw Exception('Category with id ${item.id} not found');
    }
    _items[item.id] = item;
    return item;
  }
}
