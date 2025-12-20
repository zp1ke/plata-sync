import 'package:flutter/material.dart';
import '../../../../core/ui/resources/app_colors.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/datetime.dart';
import '../../../../core/utils/numbers.dart';
import '../../domain/entities/account.dart';
import '../../../../l10n/app_localizations.dart';

/// A reusable widget that displays account details.
/// Can be used in dialogs or inline in detail panes.
class AccountDetailsView extends StatelessWidget {
  final Account account;
  final bool showLargeIcon;

  const AccountDetailsView({
    required this.account,
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
                  account.iconData.backgroundColorHex,
                ),
                borderRadius: AppSizing.borderRadiusXl,
              ),
              child: Center(
                child: AppIcons.getIcon(
                  account.iconData.iconName,
                  color: ColorExtensions.fromHex(account.iconData.iconColorHex),
                  size: AppSizing.iconXl * 1.5,
                ),
              ),
            ),
          ),
        // Balance
        _buildSection(
          context,
          label: l10n.accountsDetailsBalance,
          child: Text(
            account.balance.asCurrency(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: account.balance >= 0
                  ? Theme.of(context).colorScheme.income
                  : Theme.of(context).colorScheme.expense,
            ),
          ),
        ),
        // Description
        if (account.description != null && account.description!.isNotEmpty)
          _buildSection(
            context,
            label: showLargeIcon ? l10n.accountsEditDescription : null,
            child: Text(
              account.description!,
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
              label: l10n.accountsDetailsId,
              value: account.id,
            ),
            _buildInfoRow(
              context,
              label: l10n.accountsDetailsCreatedAt,
              value: account.createdAt.format(),
            ),
            _buildInfoRow(
              context,
              label: l10n.accountsDetailsLastUsed,
              value: account.lastUsed?.format() ?? l10n.never,
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
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
