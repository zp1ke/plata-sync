import 'package:flutter/foundation.dart' hide Category;
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

class CategoriesManager {
  final CategoryDataSource _dataSource;

  CategoriesManager(this._dataSource);

  final ValueNotifier<List<Category>> categories = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> loadCategories({String? query}) async {
    isLoading.value = true;
    try {
      categories.value = await _dataSource.getAll(
        filter: query != null && query.isNotEmpty
            ? {'name': query, 'description': query}
            : null,
      );
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      final newCategory = await _dataSource.create(category);
      categories.value = [...categories.value, newCategory];
    } catch (e) {
      debugPrint('Error adding category: $e');
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      final updatedCategory = await _dataSource.update(category);
      final currentList = [...categories.value];
      final index = currentList.indexWhere((c) => c.id == updatedCategory.id);
      if (index != -1) {
        currentList[index] = updatedCategory;
        categories.value = currentList;
      }
    } catch (e) {
      debugPrint('Error updating category: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _dataSource.delete(id);
      categories.value = categories.value.where((c) => c.id != id).toList();
    } catch (e) {
      debugPrint('Error deleting category: $e');
      rethrow;
    }
  }

  void dispose() {
    categories.dispose();
    isLoading.dispose();
  }
}
