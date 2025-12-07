import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/widgets/dialog.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/categories/ui/widgets/category_details_view.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class CategoryDetailsDialog extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const CategoryDetailsDialog({
    required this.category,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return AppDialog(
      iconData: category.iconData,
      title: category.name,
      content: CategoryDetailsView(category: category),
      contentHeight: 150,
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
          },
          icon: AppIcons.delete,
          label: Text(l10n.delete),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onDuplicate();
          },
          icon: AppIcons.copy,
          label: Text(l10n.duplicate),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onEdit();
          },
          icon: AppIcons.edit,
          label: Text(l10n.edit),
        ),
      ],
    );
  }
}
