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
class CategorySelector extends StatefulWidget {
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
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late final CategoriesManager _manager;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _manager = getService<CategoriesManager>();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    await _manager.loadCategories();
    if (mounted) {
      setState(() {
        _categories = _manager.categories.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    if (_categories.isEmpty) {
      return TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: l10n.categoriesScreenTitle,
          hintText: l10n.categoriesAddSampleDataPrompt,
          border: const OutlineInputBorder(),
        ),
      );
    }

    final selectedCategory = _categories.cast<Category?>().firstWhere(
      (category) => category?.id == widget.categoryId,
      orElse: () => null,
    );

    return SelectField<Category?>(
      value: selectedCategory,
      options: widget.required ? _categories : [null, ..._categories],
      label: l10n.categoriesScreenTitle,
      itemLabelBuilder: (category) =>
          category?.name ?? l10n.selectFieldNoResults,
      itemBuilder: (category) {
        if (category == null) {
          return Text(
            '(${l10n.selectFieldNoResults})',
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
      onChanged: (category) => widget.onChanged(category?.id),
      validator: (category) => widget.validator?.call(category?.id),
      enabled: widget.enabled,
    );
  }
}
