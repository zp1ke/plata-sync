import 'package:flutter/foundation.dart' hide Category;
import '../../../core/di/service_locator.dart';
import '../../../core/model/enums/view_mode.dart';
import '../../../core/model/object_icon_data.dart';
import '../../../core/services/settings_service.dart';
import '../data/interfaces/category_data_source.dart';
import '../domain/entities/category.dart';
import '../model/enums/category_transaction_type.dart';
import '../model/enums/sort_order.dart';

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
  final ValueNotifier<CategoryTransactionType?> currentTransactionTypeFilter =
      ValueNotifier(null);

  bool get hasActiveFilters {
    return currentTransactionTypeFilter.value != null;
  }

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
      final filter = <String, dynamic>{};

      if (filterQuery.isNotEmpty) {
        filter['name'] = filterQuery;
      }

      filter['includeDisabled'] = true;

      if (currentTransactionTypeFilter.value != null) {
        filter['transactionType'] = currentTransactionTypeFilter.value!.name;
      }

      categories.value = await _dataSource.getAll(
        filter: filter.isNotEmpty ? filter : null,
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
      // Check if category has associated transactions
      final hasTransactions = await _dataSource.hasTransactions(id);

      if (hasTransactions) {
        // Soft delete: disable the category instead of deleting
        final category = await _dataSource.read(id);
        if (category != null) {
          await _dataSource.update(category.copyWith(enabled: false));
        }
      } else {
        // Hard delete: no transactions associated
        await _dataSource.delete(id);
      }
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

  Future<List<Category>> getCategoriesByIds(List<String> ids) async {
    try {
      return await _dataSource.getByIds(ids);
    } catch (e) {
      debugPrint('Error getting categories by ids: $e');
      return [];
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

  void setTransactionTypeFilter(CategoryTransactionType? transactionType) {
    currentTransactionTypeFilter.value = transactionType;
    loadCategories();
  }

  void clearFilters() {
    currentTransactionTypeFilter.value = null;
    loadCategories();
  }

  void dispose() {
    categories.dispose();
    isLoading.dispose();
    currentQuery.dispose();
    sortOrder.dispose();
    viewMode.dispose();
    currentTransactionTypeFilter.dispose();
  }
}
