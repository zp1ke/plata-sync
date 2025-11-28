import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/resources/app_theme.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class TransactionGridView extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(Transaction transaction)? onTap;
  final String? selectedTransactionId;

  const TransactionGridView({
    required this.transactions,
    this.onTap,
    this.selectedTransactionId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.paddingSm,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isSelected = selectedTransactionId == transaction.id;
        return _TransactionGridItem(
          transaction: transaction,
          isSelected: isSelected,
          onTap: onTap,
        );
      },
    );
  }
}

class _TransactionGridItem extends StatefulWidget {
  final Transaction transaction;
  final bool isSelected;
  final void Function(Transaction transaction)? onTap;

  const _TransactionGridItem({
    required this.transaction,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<_TransactionGridItem> createState() => _TransactionGridItemState();
}

class _TransactionGridItemState extends State<_TransactionGridItem> {
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
        iconData: const ObjectIconData(
          iconName: 'help_outline',
          backgroundColorHex: '9E9E9E',
          iconColorHex: 'FFFFFF',
        ),
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
          iconData: const ObjectIconData(
            iconName: 'help_outline',
            backgroundColorHex: '9E9E9E',
            iconColorHex: 'FFFFFF',
          ),
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
          iconData: const ObjectIconData(
            iconName: 'help_outline',
            backgroundColorHex: '9E9E9E',
            iconColorHex: 'FFFFFF',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
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

    String getTypeLabel() {
      if (widget.transaction.isExpense) {
        return l10n.transactionTypeExpense;
      } else if (widget.transaction.isIncome) {
        return l10n.transactionTypeIncome;
      } else {
        return l10n.transactionTypeTransfer;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xs,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: getTypeColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  AppSpacing.gapHorizontalSm,
                  Expanded(
                    child: Text(
                      getTypeLabel(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: getTypeColor(),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat.MMMd().format(widget.transaction.createdAt),
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
                Text(
                  widget.transaction.isTransfer && targetAccount != null
                      ? '${account!.name} → ${targetAccount!.name}'
                      : account!.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (category != null)
                Text(
                  category!.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
