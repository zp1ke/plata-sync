import 'package:flutter/material.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/resources/app_theme.dart';
import 'package:plata_sync/core/ui/widgets/object_icon.dart';
import 'package:plata_sync/core/utils/datetime.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';

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
    account = allAccounts.firstWhere(
      (a) => a.id == widget.transaction.accountId,
      orElse: () => Account.create(
        name: 'Unknown',
        description: null,
        iconData: ObjectIconData.empty(),
      ),
    );

    // Load category if present
    if (widget.transaction.categoryId != null) {
      final allCategories = categoriesManager.categories.value;
      category = allCategories.firstWhere(
        (c) => c.id == widget.transaction.categoryId,
        orElse: () => Category.create(
          name: 'Unknown',
          description: null,
          iconData: ObjectIconData.empty(),
        ),
      );
    }

    // Load target account for transfers
    if (widget.transaction.targetAccountId != null) {
      targetAccount = allAccounts.firstWhere(
        (a) => a.id == widget.transaction.targetAccountId,
        orElse: () => Account.create(
          name: 'Unknown',
          description: null,
          iconData: ObjectIconData.empty(),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color getTypeColor() {
      if (widget.transaction.isExpense) {
        return colorScheme.expense;
      } else if (widget.transaction.isIncome) {
        return colorScheme.income;
      } else {
        return colorScheme.transfer;
      }
    }

    return Card(
      color: widget.isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: widget.onTap != null
            ? () => widget.onTap!(widget.transaction)
            : null,
        borderRadius: AppSizing.borderRadiusMd,
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
                        if (category != null) ...[
                          ObjectIcon(
                            iconData: category!.iconData,
                            size: AppSizing.iconXs,
                          ),
                          AppSpacing.gapHorizontalXs,
                        ],
                        Expanded(
                          child: Text(
                            category?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: getTypeColor(),
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
                        color: getTypeColor(),
                      ),
                    ),
                    if (account != null)
                      Row(
                        children: [
                          ObjectIcon(
                            iconData: account!.iconData,
                            size: AppSizing.iconXs,
                          ),
                          AppSpacing.gapHorizontalXs,
                          Expanded(
                            child: Text(
                              widget.transaction.isTransfer &&
                                      targetAccount != null
                                  ? '${account!.name} → ${targetAccount!.name}'
                                  : account!.name,
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
