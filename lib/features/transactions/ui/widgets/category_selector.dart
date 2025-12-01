import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/ui/widgets/select_field.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

/// A widget that allows selecting a category from available categories
class CategorySelector extends StatelessWidget {
  final String? categoryId;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool required;

  const CategorySelector({
    required this.categoryId,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.required = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final manager = getService<CategoriesManager>();

    return ValueListenableBuilder<List<Category>>(
      valueListenable: manager.categories,
      builder: (context, categories, _) {
        if (categories.isEmpty) {
          return TextFormField(
            enabled: false,
            decoration: InputDecoration(
              labelText: l10n.transactionCategoryLabel,
              hintText: l10n.categoriesAddSampleDataPrompt,
              border: const OutlineInputBorder(),
            ),
          );
        }

        final selectedCategory = categories
            .where((category) => category.id == categoryId)
            .firstOrNull;

        return SelectField<Category?>(
          value: selectedCategory,
          options: required ? categories : [null, ...categories],
          label: l10n.transactionCategoryLabel,
          itemLabelBuilder: (category) => category?.name ?? l10n.none,
          itemBuilder: (category) {
            if (category == null) {
              return Text(
                '(${l10n.none})',
                style: const TextStyle(fontStyle: FontStyle.italic),
              );
            }
            return Row(
              children: [
                ObjectIcon(iconData: category.iconData, size: AppSizing.iconMd),
                AppSpacing.gapHorizontalMd,
                Expanded(
                  child: Text(category.name, overflow: TextOverflow.ellipsis),
                ),
              ],
            );
          },
          onChanged: (category) => onChanged(category?.id),
          validator: (category) => validator?.call(category?.id),
          enabled: enabled,
        );
      },
    );
  }
}
