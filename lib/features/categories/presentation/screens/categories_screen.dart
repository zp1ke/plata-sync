import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/presentation/widgets/app_top_bar.dart';
import 'package:plata_sync/core/presentation/widgets/object_icon.dart';
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
    final l10n = AppL10n.of(context);
    final manager = getService<CategoriesManager>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            AppTopBar(
              title: l10n.categoriesScreenTitle,
              searchHint: l10n.categoriesSearchHint,
              onSearchChanged: (value) => manager.loadCategories(query: value),
              isLoading: isLoading,
              onRefresh: () => manager.loadCategories(),
            ),
          ];
        },
        body: content(context, isLoading, categories, currentQuery),
      ),
    );
  }

  Widget content(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
    String currentQuery,
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
}
