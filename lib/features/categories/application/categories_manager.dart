import 'package:flutter/foundation.dart' hide Category;
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/services/settings_service.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/categories/model/enums/sort_order.dart';

class CategoriesManager {
  final CategoryDataSource _dataSource;

  CategoriesManager(this._dataSource) {
    _loadSortOrderFromSettings();
    loadCategories();
  }

  final ValueNotifier<List<Category>> categories = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> currentQuery = ValueNotifier('');
  final ValueNotifier<CategorySortOrder> sortOrder = ValueNotifier(
    CategorySortOrder.lastUsedDesc,
  );
  final ValueNotifier<ViewMode> viewMode = ValueNotifier(ViewMode.list);

  void _loadSortOrderFromSettings() {
    final settings = getService<SettingsService>();
    final saved = settings.getCategoriesSortOrder();
    if (saved != null) {
      sortOrder.value = saved;
    }
  }

  Future<void> createSampleData() async {
    isLoading.value = true;
    try {
      final hasData = await _dataSource.hasData();
      if (!hasData) {
        await _createSampleData();
        await loadCategories();
      }
    } catch (e) {
      debugPrint('Error creating sample data: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createSampleData() async {
    final categories = [
      Category.create(
        name: 'Groceries',
        iconData: ObjectIconData(
          iconName: 'shopping_cart',
          backgroundColorHex: '#FFF9C4',
          iconColorHex: '#F9A825',
        ),
        description: 'Items to buy from the supermarket',
      ),
      Category.create(
        name: 'Utilities',
        iconData: ObjectIconData(
          iconName: 'flash_on',
          backgroundColorHex: '#FFEBEE',
          iconColorHex: '#E53935',
        ),
        description: 'Monthly bills and subscriptions',
      ),
      Category.create(
        name: 'Entertainment',
        iconData: ObjectIconData(
          iconName: 'movie',
          backgroundColorHex: '#E3F2FD',
          iconColorHex: '#2196F3',
        ),
        description: 'Movies, games, and other fun activities',
      ),
    ];

    for (final category in categories) {
      try {
        await addCategory(category);
      } catch (e) {
        // Ignore duplicate entries if createSampleData is called multiple times
      }
    }
  }

  Future<void> loadCategories({String? query}) async {
    isLoading.value = true;
    if (query != null) {
      currentQuery.value = query;
    }
    try {
      final filterQuery = query ?? currentQuery.value;
      categories.value = await _dataSource.getAll(
        filter: filterQuery.isNotEmpty ? {'name': filterQuery} : null,
        sort: sortOrder.value.sortParam(),
      );
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _dataSource.create(category);
      await loadCategories();
    } catch (e) {
      debugPrint('Error adding category: $e');
      rethrow;
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _dataSource.update(category);
      await loadCategories();
    } catch (e) {
      debugPrint('Error updating category: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _dataSource.delete(id);
      await loadCategories();
    } catch (e) {
      debugPrint('Error deleting category: $e');
      rethrow;
    }
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      return await _dataSource.read(id);
    } catch (e) {
      debugPrint('Error getting category by id: $e');
      return null;
    }
  }

  void setSortOrder(CategorySortOrder order) {
    sortOrder.value = order;
    // Save to settings
    final settings = getService<SettingsService>();
    settings.setCategoriesSortOrder(order);
    loadCategories();
  }

  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  void dispose() {
    categories.dispose();
    isLoading.dispose();
    currentQuery.dispose();
    sortOrder.dispose();
    viewMode.dispose();
  }
}
