import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/app_top_bar.dart';
import 'package:plata_sync/core/ui/widgets/sort_selector.dart';
import 'package:plata_sync/core/ui/widgets/view_toggle.dart';
import 'package:plata_sync/core/utils/random.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_details_dialog.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_grid_view.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_list_view.dart';
import 'package:plata_sync/l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class CategoriesScreen extends WatchingWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((CategoriesManager x) => x.isLoading);
    final categories = watchValue((CategoriesManager x) => x.categories);
    final currentQuery = watchValue((CategoriesManager x) => x.currentQuery);
    final sortOrder = watchValue((CategoriesManager x) => x.sortOrder);
    final viewMode = watchValue((CategoriesManager x) => x.viewMode);
    final l10n = AppL10n.of(context);

    // Show sample data dialog once when categories are empty
    callOnceAfterThisBuild((context) {
      if (categories.isEmpty && currentQuery.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            showSampleDataDialog(context, l10n);
          }
        });
      }
    });

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (_, _) {
          final manager = getService<CategoriesManager>();
          return [
            AppTopBar(
              title: l10n.categoriesScreenTitle,
              searchHint: l10n.categoriesSearchHint,
              onSearchChanged: (value) => manager.loadCategories(query: value),
              isLoading: isLoading,
              onRefresh: () => manager.loadCategories(),
              bottom: bottomBar(context, sortOrder, viewMode, manager, l10n),
            ),
          ];
        },
        body: content(context, isLoading, categories, currentQuery, viewMode),
      ),
    );
  }

  Future<void> showSampleDataDialog(BuildContext context, AppL10n l10n) async {
    final l10n = AppL10n.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.categoriesEmptyState),
        content: Text(l10n.categoriesAddSampleDataPrompt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.no),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      final manager = getService<CategoriesManager>();
      await manager.createSampleData();
    }
  }

  Widget bottomBar(
    BuildContext context,
    CategorySortOrder sortOrder,
    ViewMode viewMode,
    CategoriesManager manager,
    AppL10n l10n,
  ) {
    return Row(
      children: [
        // Sort selector
        Expanded(
          child: SortSelector<CategorySortOrder>(
            value: sortOrder,
            onChanged: manager.setSortOrder,
            labelBuilder: (order) => sortLabel(order, l10n),
            sortIconBuilder: (order) => order.isDescending
                ? AppIcons.sortDescending
                : AppIcons.sortAscending,
            options: CategorySortOrder.values,
          ),
        ),
        AppSpacing.gapHorizontalSm,
        // View toggle
        ViewToggle(value: viewMode, onChanged: manager.setViewMode),
      ],
    );
  }

  String sortLabel(CategorySortOrder sortOrder, AppL10n l10n) {
    switch (sortOrder) {
      case CategorySortOrder.nameAsc:
        return l10n.categoriesSortNameAsc;
      case CategorySortOrder.nameDesc:
        return l10n.categoriesSortNameDesc;
      case CategorySortOrder.lastUsedAsc:
        return l10n.categoriesSortLastUsedAsc;
      case CategorySortOrder.lastUsedDesc:
        return l10n.categoriesSortLastUsedDesc;
    }
  }

  Widget content(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
    String currentQuery,
    ViewMode viewMode,
  ) {
    final l10n = AppL10n.of(context);
    if (isLoading && categories.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (categories.isEmpty) {
      if (currentQuery.isNotEmpty) {
        return Center(
          child: Text(l10n.categoriesNoSearchResults(currentQuery)),
        );
      }
      return Center(child: Text(l10n.categoriesEmptyState));
    }

    return viewMode == ViewMode.list
        ? CategoryListView(
            categories: categories,
            onTap: (category) => showCategoryDetails(context, category),
          )
        : CategoryGridView(
            categories: categories,
            onTap: (category) => showCategoryDetails(context, category),
          );
  }

  void showCategoryDetails(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (_) => CategoryDetailsDialog(
        category: category,
        onEdit: () => handleEdit(context, category),
        onDuplicate: () => handleDuplicate(context, category),
        onDelete: () => handleDelete(context, category),
      ),
    );
  }

  void handleEdit(BuildContext context, Category category) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${category.name} - Not implemented yet')),
    );
  }

  void handleDuplicate(BuildContext context, Category category) async {
    final l10n = AppL10n.of(context);
    final manager = getService<CategoriesManager>();
    try {
      final duplicated = category.copyWith(
        id: randomId(),
        createdAt: DateTime.now(),
        name: '${category.name} (${l10n.copy})',
        lastUsed: null,
      );
      await manager.addCategory(duplicated);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.categoryDuplicated(category.name))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.categoryDuplicateFailed(category.name, e.toString()),
            ),
          ),
        );
      }
    }
  }

  void handleDelete(BuildContext context, Category category) async {
    final l10n = AppL10n.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.categoriesDeleteConfirmation(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.no),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final manager = getService<CategoriesManager>();
      try {
        await manager.deleteCategory(category.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.categoryDeleted(category.name))),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.categoryDeleteFailed(category.name, e.toString()),
              ),
            ),
          );
        }
      }
    }
  }
}
