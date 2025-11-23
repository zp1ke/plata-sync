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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.categoriesScreenTitle),
        actions: [
          IconButton(
            onPressed: isLoading
                ? null
                : () => getService<CategoriesManager>().loadCategories(),
            icon: Icon(AppIcons.refresh),
          ),
        ],
      ),
      body: Center(child: content(context, isLoading, categories)),
    );
  }

  Widget content(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
  ) {
    if (isLoading) {
      return const CircularProgressIndicator.adaptive();
    }
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(categories[index].name),
        leading: ObjectIcon(
          iconName: categories[index].icon,
          backgroundColorHex: categories[index].backgroundColorHex,
          iconColorHex: categories[index].iconColorHex,
        ),
      ),
    );
  }
}
