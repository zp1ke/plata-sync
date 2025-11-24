import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';
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
    final l10n = AppL10n.of(context);
    final manager = getService<CategoriesManager>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(l10n.categoriesScreenTitle),
              floating: true,
              snap: true,
              pinned: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: SearchBar(
                    hintText: l10n.categoriesSearchHint,
                    leading: const Icon(AppIcons.search),
                    onChanged: (value) {
                      manager.loadCategories(query: value);
                    },
                    trailing: [
                      if (isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: isLoading ? null : () => manager.loadCategories(),
                  icon: Icon(AppIcons.refresh),
                ),
              ],
            ),
          ];
        },
        body: content(context, isLoading, categories),
      ),
    );
  }

  Widget content(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
  ) {
    if (isLoading && categories.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
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
