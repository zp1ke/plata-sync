import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/utils/datetime.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
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
    return AlertDialog(
      title: Row(
        children: [
          ObjectIcon(
            iconName: category.icon,
            backgroundColorHex: category.backgroundColorHex,
            iconColorHex: category.iconColorHex,
            size: AppSizing.avatarSm,
          ),
          AppSpacing.gapHorizontalMd,
          Expanded(
            child: Text(
              category.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.description != null &&
                category.description!.isNotEmpty)
              Text(
                category.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            _buildInfoRow(
              context,
              label: l10n.categoriesDetailsId,
              value: category.id,
            ),
            _buildInfoRow(
              context,
              label: l10n.categoriesDetailsCreatedAt,
              value: category.createdAt.format(),
            ),
            _buildInfoRow(
              context,
              label: l10n.categoriesDetailsLastUsed,
              value: category.lastUsed?.format() ?? l10n.never,
            ),
          ],
        ),
      ),
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
        const Spacer(),
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

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSizing.boxWidthSm,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
