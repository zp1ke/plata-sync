import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/resources/app_theme.dart';
import 'package:plata_sync/core/utils/numbers.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class TransactionListView extends StatefulWidget {
  final List<Transaction> transactions;
  final void Function(Transaction transaction)? onTap;
  final String? selectedTransactionId;

  const TransactionListView({
    required this.transactions,
    this.onTap,
    this.selectedTransactionId,
    super.key,
  });

  @override
  State<TransactionListView> createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  late final AccountsManager _accountsManager;
  late final CategoriesManager _categoriesManager;
  Map<String, Account> _accountsMap = {};
  Map<String, Category> _categoriesMap = {};

  @override
  void initState() {
    super.initState();
    _accountsManager = getService<AccountsManager>();
    _categoriesManager = getService<CategoriesManager>();
    _loadData();
  }

  Future<void> _loadData() async {
    await _accountsManager.loadAccounts();
    await _categoriesManager.loadCategories();
    if (mounted) {
      setState(() {
        _accountsMap = {
          for (var account in _accountsManager.accounts.value)
            account.id: account,
        };
        _categoriesMap = {
          for (var category in _categoriesManager.categories.value)
            category.id: category,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return ListView.builder(
      padding: AppSpacing.paddingSm,
      itemCount: widget.transactions.length,
      itemBuilder: (context, index) {
        final transaction = widget.transactions[index];
        final isSelected = widget.selectedTransactionId == transaction.id;
        final account = _accountsMap[transaction.accountId];
        final category = transaction.categoryId != null
            ? _categoriesMap[transaction.categoryId]
            : null;
        final targetAccount = transaction.targetAccountId != null
            ? _accountsMap[transaction.targetAccountId]
            : null;

        String typeLabel;
        Color typeColor;
        if (transaction.isTransfer) {
          typeLabel = l10n.transactionTypeTransfer;
          typeColor = Theme.of(context).colorScheme.transfer;
        } else if (transaction.isExpense) {
          typeLabel = l10n.transactionTypeExpense;
          typeColor = Theme.of(context).colorScheme.expense;
        } else {
          typeLabel = l10n.transactionTypeIncome;
          typeColor = Theme.of(context).colorScheme.income;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: InkWell(
            onTap: widget.onTap != null
                ? () => widget.onTap!(transaction)
                : null,
            child: Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  // Type indicator
                  Container(
                    width: 4,
                    height: 48,
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Row(
                          children: [
                            Text(
                              typeLabel,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: typeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat.MMMd().format(transaction.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        if (category != null)
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        Row(
                          children: [
                            Text(
                              account?.name ?? l10n.accountsEmptyState,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (targetAccount != null) ...[
                              Text(
                                ' → ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                targetAccount.name,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                        if (transaction.notes != null &&
                            transaction.notes!.isNotEmpty)
                          Text(
                            transaction.notes!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  // Amount
                  Text(
                    NumberFormatters.formatCurrency(transaction.amount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: typeColor,
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
