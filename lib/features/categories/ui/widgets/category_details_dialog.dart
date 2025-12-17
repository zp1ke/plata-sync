import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/widgets/dialog.dart';
import '../../domain/entities/category.dart';
import 'category_details_view.dart';
import '../../../../l10n/app_localizations.dart';

class CategoryDetailsDialog extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onViewTransactions;

  const CategoryDetailsDialog({
    required this.category,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onViewTransactions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return AppDialog(
      iconData: category.iconData,
      title: category.name,
      content: CategoryDetailsView(category: category),
      contentHeight: 200,
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onViewTransactions();
          },
          icon: AppIcons.transactions,
          label: Text(l10n.categoriesDetailsViewTransactions),
        ),
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
