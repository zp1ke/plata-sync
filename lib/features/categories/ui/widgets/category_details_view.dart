import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/datetime.dart';
import '../../domain/entities/category.dart';
import '../../model/enums/category_transaction_type.dart';
import '../../../../l10n/app_localizations.dart';

/// A reusable widget that displays category details.
/// Can be used in dialogs or inline in detail panes.
class CategoryDetailsView extends StatelessWidget {
  final Category category;
  final bool showLargeIcon;

  const CategoryDetailsView({
    required this.category,
    this.showLargeIcon = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.lg,
      children: [
        // Icon preview (large version for detail panes)
        if (showLargeIcon)
          Center(
            child: Container(
              width: AppSizing.iconPreviewSize,
              height: AppSizing.iconPreviewSize,
              decoration: BoxDecoration(
                color: ColorExtensions.fromHex(
                  category.iconData.backgroundColorHex,
                ),
                borderRadius: AppSizing.borderRadiusXl,
              ),
              child: Center(
                child: AppIcons.getIcon(
                  category.iconData.iconName,
                  color: ColorExtensions.fromHex(
                    category.iconData.iconColorHex,
                  ),
                  size: AppSizing.iconXl * 1.5,
                ),
              ),
            ),
          ),
        // Description
        if (category.description != null && category.description!.isNotEmpty)
          _buildSection(
            context,
            label: showLargeIcon ? l10n.categoriesEditDescription : null,
            child: Text(
              category.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        // Metadata section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            _buildInfoRow(
              context,
              label: l10n.categoriesDetailsId,
              value: category.id,
            ),
            _buildInfoRow(
              context,
              label: l10n.categoriesEditTransactionType,
              value: _getTransactionTypeLabel(l10n, category.transactionType),
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
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    String? label,
    required Widget child,
  }) {
    if (label == null) return child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        child,
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

  String _getTransactionTypeLabel(
    AppL10n l10n,
    CategoryTransactionType? transactionType,
  ) {
    if (transactionType == null) {
      return l10n.categoryTransactionTypeAny;
    }
    return transactionType == CategoryTransactionType.income
        ? l10n.categoryTransactionTypeIncome
        : l10n.categoryTransactionTypeExpense;
  }
}
