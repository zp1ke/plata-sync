import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../../../core/ui/widgets/input_decoration.dart';
import '../../../../core/ui/widgets/object_icon.dart';
import '../../../categories/application/categories_manager.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/model/enums/category_transaction_type.dart';
import 'transaction_type_selector.dart';
import '../../../../l10n/app_localizations.dart';

/// A widget that allows selecting multiple categories from available categories
class MultiCategorySelector extends StatefulWidget {
  final List<String>? categoryIds;
  final ValueChanged<List<String>> onChanged;
  final String? Function(List<Category>?)? validator;
  final bool enabled;
  final String? label;
  final TransactionType? transactionType;

  const MultiCategorySelector({
    required this.categoryIds,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.label,
    this.transactionType,
    super.key,
  });

  @override
  State<MultiCategorySelector> createState() => _MultiCategorySelectorState();
}

class _MultiCategorySelectorState extends State<MultiCategorySelector> {
  @override
  void initState() {
    super.initState();
    // Load categories when the selector is first created
    final manager = getService<CategoriesManager>();
    if (manager.categories.value.isEmpty) {
      Future.microtask(manager.loadCategories);
    }
  }

  void _showCategoryDialog(BuildContext context, List<Category> allCategories) {
    final selectedIds = Set<String>.from(widget.categoryIds ?? []);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final l10n = AppL10n.of(context);
            return AppDialog(
              title: widget.label ?? l10n.transactionCategoryLabel,
              scrollable: false,
              content: allCategories.isEmpty
                  ? Center(
                      child: Text(
                        l10n.categoriesAddSampleDataPrompt,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: allCategories.length,
                      itemBuilder: (context, index) {
                        final category = allCategories[index];
                        final isSelected = selectedIds.contains(category.id);
                        return CheckboxListTile(
                          title: Row(
                            children: [
                              ObjectIcon(
                                iconData: category.iconData,
                                size: AppSizing.iconMd,
                              ),
                              AppSpacing.gapHorizontalMd,
                              Expanded(
                                child: Text(
                                  category.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          value: isSelected,
                          onChanged: (checked) {
                            setDialogState(() {
                              if (checked == true) {
                                selectedIds.add(category.id);
                              } else {
                                selectedIds.remove(category.id);
                              }
                            });
                          },
                        );
                      },
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    widget.onChanged(selectedIds.toList());
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.apply),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Filter categories based on the transaction type
  List<Category> _filterCategoriesByType(List<Category> categories) {
    final enabledCategories = categories.where((category) => category.enabled);
    if (widget.transactionType == null ||
        widget.transactionType == TransactionType.transfer) {
      return enabledCategories.toList();
    }

    final categoryType = widget.transactionType == TransactionType.income
        ? CategoryTransactionType.income
        : CategoryTransactionType.expense;

    return enabledCategories.where((category) {
      // Include categories with null transactionType (available for all types)
      // or categories that match the current transaction type
      return category.transactionType == null ||
          category.transactionType == categoryType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final labelText = widget.label ?? l10n.transactionCategoryLabel;
    final manager = getService<CategoriesManager>();

    return ValueListenableBuilder<List<Category>>(
      valueListenable: manager.categories,
      builder: (context, categories, _) {
        final filteredCategories = _filterCategoriesByType(categories);

        if (filteredCategories.isEmpty) {
          return TextFormField(
            enabled: false,
            decoration: inputDecorationWithPrefixIcon(
              labelText: labelText,
              hintText: l10n.categoriesAddSampleDataPrompt,
              prefixIcon: AppIcons.categoriesOutlinedXs,
            ),
          );
        }

        final selectedCategories = filteredCategories
            .where(
              (category) => widget.categoryIds?.contains(category.id) ?? false,
            )
            .toList();

        final displayText = selectedCategories.isEmpty
            ? l10n.selectCategories
            : selectedCategories.map((c) => c.name).join(', ');

        return InkWell(
          onTap: widget.enabled
              ? () => _showCategoryDialog(context, filteredCategories)
              : null,
          child: InputDecorator(
            decoration:
                inputDecorationWithPrefixIcon(
                  labelText: labelText,
                  prefixIcon: AppIcons.accountsOutlinedXs,
                ).copyWith(
                  suffixIcon: selectedCategories.isNotEmpty && widget.enabled
                      ? IconButton(
                          icon: SizedBox(
                            width: AppSizing.iconMd,
                            child: AppIcons.clear,
                          ),
                          onPressed: () => widget.onChanged([]),
                          tooltip: l10n.clear,
                        )
                      : null,
                ),
            child: Text(
              displayText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selectedCategories.isEmpty
                    ? Theme.of(context).hintColor
                    : null,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        );
      },
    );
  }
}
