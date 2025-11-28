import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/ui/widgets/responsive_grid_view.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';

class AccountGridView extends StatelessWidget {
  final List<Account> accounts;
  final void Function(Account account)? onTap;
  final String? selectedAccountId;

  const AccountGridView({
    required this.accounts,
    this.onTap,
    this.selectedAccountId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridView(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        final isSelected = selectedAccountId == account.id;
        return Card(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: InkWell(
            onTap: onTap != null ? () => onTap!(account) : null,
            borderRadius: AppSizing.borderRadiusMd,
            child: Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  ObjectIcon(iconData: account.iconData),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Text(
                          account.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          NumberFormatters.formatCompactCurrency(
                            account.balance,
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: account.balance >= 0
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
