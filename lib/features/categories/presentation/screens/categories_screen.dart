import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';
import 'package:plata_sync/core/presentation/widgets/app_top_bar.dart';
import 'package:plata_sync/core/presentation/widgets/object_icon.dart';
import 'package:plata_sync/core/presentation/widgets/sort_selector.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
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
    final manager = getService<CategoriesManager>();

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (_, _) {
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

  Widget bottomBar(
    BuildContext context,
    CategorySortOrder sortOrder,
    CategoryViewMode viewMode,
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
            options: CategorySortOrder.values,
          ),
        ),
        const SizedBox(width: 8),
        // View toggle
        viewToggle(viewMode, manager, l10n),
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

  Widget viewToggle(
    CategoryViewMode viewMode,
    CategoriesManager manager,
    AppL10n l10n,
  ) {
    return SegmentedButton<CategoryViewMode>(
      segments: [
        ButtonSegment(
          value: CategoryViewMode.list,
          icon: const Icon(AppIcons.viewList, size: 20),
          tooltip: l10n.categoriesViewList,
        ),
        ButtonSegment(
          value: CategoryViewMode.grid,
          icon: const Icon(AppIcons.viewGrid, size: 20),
          tooltip: l10n.categoriesViewGrid,
        ),
      ],
      selected: {viewMode},
      onSelectionChanged: (Set<CategoryViewMode> newSelection) {
        manager.setViewMode(newSelection.first);
      },
    );
  }

  Widget content(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
    String currentQuery,
    CategoryViewMode viewMode,
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

    return viewMode == CategoryViewMode.list
        ? listView(categories)
        : gridView(categories);
  }

  Widget listView(List<Category> categories) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          title: Text(category.name),
          leading: ObjectIcon(
            iconName: category.icon,
            backgroundColorHex: category.backgroundColorHex,
            iconColorHex: category.iconColorHex,
          ),
        );
      },
    );
  }

  Widget gridView(List<Category> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: InkWell(
            onTap: () {
              // TODO: Navigate to category details
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ObjectIcon(
                    iconName: category.icon,
                    backgroundColorHex: category.backgroundColorHex,
                    iconColorHex: category.iconColorHex,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
