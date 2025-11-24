import 'package:flutter/foundation.dart' hide Category;
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

enum CategorySortOrder { nameAsc, nameDesc, lastUsedAsc, lastUsedDesc }

enum CategoryViewMode { list, grid }

class CategoriesManager {
  final CategoryDataSource _dataSource;

  CategoriesManager(this._dataSource) {
    loadCategories();
  }

  final ValueNotifier<List<Category>> categories = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> currentQuery = ValueNotifier('');
  final ValueNotifier<CategorySortOrder> sortOrder = ValueNotifier(
    CategorySortOrder.lastUsedDesc,
  );
  final ValueNotifier<CategoryViewMode> viewMode = ValueNotifier(
    CategoryViewMode.list,
  );

  Future<void> loadCategories({String? query}) async {
    isLoading.value = true;
    if (query != null) {
      currentQuery.value = query;
    }
    try {
      final filterQuery = query ?? currentQuery.value;
      categories.value = await _dataSource.getAll(
        filter: filterQuery.isNotEmpty ? {'name': filterQuery} : null,
      );
      _sortCategories();
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

  void setSortOrder(CategorySortOrder order) {
    sortOrder.value = order;
    _sortCategories();
  }

  void setViewMode(CategoryViewMode mode) {
    viewMode.value = mode;
  }

  void _sortCategories() {
    final sorted = [...categories.value];
    switch (sortOrder.value) {
      case CategorySortOrder.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case CategorySortOrder.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
      case CategorySortOrder.lastUsedAsc:
        sorted.sort((a, b) => a.lastUsed.compareTo(b.lastUsed));
      case CategorySortOrder.lastUsedDesc:
        sorted.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
    }
    categories.value = sorted;
  }

  void dispose() {
    categories.dispose();
    isLoading.dispose();
    currentQuery.dispose();
    sortOrder.dispose();
    viewMode.dispose();
  }
}
