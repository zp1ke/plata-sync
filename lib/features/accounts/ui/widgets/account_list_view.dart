import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/resources/app_theme.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';

class AccountListView extends StatelessWidget {
  final List<Account> accounts;
  final void Function(Account account)? onTap;
  final String? selectedAccountId;

  const AccountListView({
    required this.accounts,
    this.onTap,
    this.selectedAccountId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppSpacing.paddingSm,
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        final isSelected = selectedAccountId == account.id;
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Text(
                          account.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (account.description != null &&
                            account.description!.isNotEmpty)
                          Text(
                            account.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Text(
                    NumberFormatters.formatCurrency(account.balance),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: account.balance >= 0
                          ? Theme.of(context).colorScheme.income
                          : Theme.of(context).colorScheme.expense,
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
