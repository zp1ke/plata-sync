import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_colors.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/utils/datetime.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class TransactionGridItem extends StatefulWidget {
  final Transaction transaction;
  final bool isSelected;
  final void Function(Transaction transaction)? onTap;

  const TransactionGridItem({
    required this.transaction,
    required this.isSelected,
    this.onTap,
    super.key,
  });

  @override
  State<TransactionGridItem> createState() => _TransactionGridItemState();
}

class _TransactionGridItemState extends State<TransactionGridItem> {
  Account? account;
  Category? category;
  Account? targetAccount;

  @override
  void initState() {
    super.initState();
    _loadRelatedData();
  }

  Future<void> _loadRelatedData() async {
    final accountsManager = getService<AccountsManager>();
    final categoriesManager = getService<CategoriesManager>();

    // Load account
    final allAccounts = accountsManager.accounts.value;
    account = allAccounts
        .where((a) => a.id == widget.transaction.accountId)
        .firstOrNull;

    // Load category if present
    if (widget.transaction.categoryId != null) {
      final allCategories = categoriesManager.categories.value;
      category = allCategories
          .where((c) => c.id == widget.transaction.categoryId)
          .firstOrNull;
    }

    // Load target account for transfers
    if (widget.transaction.targetAccountId != null) {
      targetAccount = allAccounts
          .where((a) => a.id == widget.transaction.targetAccountId)
          .firstOrNull;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveAccount =
        account ??
        Account.create(
          name: l10n.unknown,
          description: null,
          iconData: ObjectIconData.empty(),
        );

    final effectiveCategory =
        category ??
        (widget.transaction.categoryId != null
            ? Category.create(
                name: l10n.unknown,
                description: null,
                iconData: ObjectIconData.empty(),
              )
            : null);

    final effectiveTargetAccount =
        targetAccount ??
        (widget.transaction.targetAccountId != null
            ? Account.create(
                name: l10n.unknown,
                description: null,
                iconData: ObjectIconData.empty(),
              )
            : null);

    final typeColor = switch (widget.transaction) {
      _ when widget.transaction.isTransfer => colorScheme.transfer,
      _ when widget.transaction.isExpense => colorScheme.expense,
      _ => colorScheme.income,
    };

    return Card(
      clipBehavior: Clip.hardEdge,
      color: widget.isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: widget.onTap != null
            ? () => widget.onTap!(widget.transaction)
            : null,
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [
                    Row(
                      children: [
                        if (effectiveCategory != null) ...[
                          ObjectIcon(
                            iconData: effectiveCategory.iconData,
                            size: AppSizing.iconXs,
                          ),
                          AppSpacing.gapHorizontalXs,
                        ],
                        Expanded(
                          child: Text(
                            effectiveCategory?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: typeColor,
                                ),
                          ),
                        ),
                        Text(
                          widget.transaction.createdAt.formatWithTime(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      NumberFormatters.formatCompactCurrency(
                        widget.transaction.amount,
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                    Row(
                      children: [
                        ObjectIcon(
                          iconData: effectiveAccount.iconData,
                          size: AppSizing.iconXs,
                        ),
                        AppSpacing.gapHorizontalXs,
                        Expanded(
                          child: Text(
                            widget.transaction.isTransfer &&
                                    effectiveTargetAccount != null
                                ? '${effectiveAccount.name} → ${effectiveTargetAccount.name}'
                                : effectiveAccount.name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
