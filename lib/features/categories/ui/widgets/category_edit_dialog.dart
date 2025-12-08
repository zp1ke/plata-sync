import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/widgets/dialog.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_edit_form.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class CategoryEditDialog extends StatelessWidget {
  final Category? category;
  final void Function(Category updatedCategory) onSave;

  const CategoryEditDialog({this.category, required this.onSave, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return AppDialog(
      title: category == null
          ? l10n.categoriesCreateTitle
          : l10n.categoriesEditTitle,
      contentHeight: 500,
      content: CategoryEditForm(
        category: category,
        onSave: (updatedCategory) {
          Navigator.of(context).pop();
          onSave(updatedCategory);
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
