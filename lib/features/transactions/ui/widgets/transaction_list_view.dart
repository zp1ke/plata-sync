import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/model/object_icon_data.dart';
import '../../../../core/ui/resources/app_colors.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/object_icon.dart';
import '../../../../core/utils/datetime.dart';
import '../../../../core/utils/numbers.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../categories/application/categories_manager.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/transaction.dart';
import '../../../../l10n/app_localizations.dart';

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
    if (mounted) {
      setState(() {
        _accountsMap = {
          for (var account in _accountsManager.accounts.value)
            account.id: account,
        };
      });
    }
    // Load categories for each transaction (including disabled ones)
    await _loadCategoriesForTransactions();
  }

  Future<void> _loadCategoriesForTransactions() async {
    final categoryIds = widget.transactions
        .where((t) => t.categoryId != null)
        .map((t) => t.categoryId!)
        .toSet()
        .toList();

    if (categoryIds.isEmpty) return;

    final categories = await _categoriesManager.getCategoriesByIds(categoryIds);
    if (mounted) {
      setState(() {
        _categoriesMap = {
          for (var category in categories) category.id: category,
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

        final colorScheme = Theme.of(context).colorScheme;
        final typeColor = switch (transaction) {
          _ when transaction.isTransfer => colorScheme.transfer,
          _ when transaction.isExpense => colorScheme.expense,
          _ => colorScheme.income,
        };

        return Card(
          clipBehavior: Clip.hardEdge,
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
                spacing: AppSpacing.sm,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type indicator for transfers
                  if (transaction.isTransfer)
                    ObjectIcon(
                      iconData: ObjectIconData.fromColors(
                        iconName: 'transfer',
                        iconColorHex: typeColor,
                        backgroundColorHex: typeColor.withValues(alpha: 0.3),
                      ),
                      size: AppSizing.iconSm,
                    ),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        // Category
                        if (category != null)
                          Row(
                            spacing: AppSpacing.xs,
                            children: [
                              ObjectIcon(
                                iconData: category.iconData,
                                size: AppSizing.iconMd,
                              ),
                              Expanded(
                                child: Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: typeColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        // Account and target account
                        Row(
                          children: [
                            if (account != null) ...[
                              ObjectIcon(
                                iconData: account.iconData,
                                size: AppSizing.iconSm,
                              ),
                              AppSpacing.gapHorizontalXs,
                            ],
                            Text(
                              account?.name ?? l10n.accountsEmptyState,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (targetAccount != null) ...[
                              Text(
                                ' → ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              ObjectIcon(
                                iconData: targetAccount.iconData,
                                size: AppSizing.iconSm,
                              ),
                              AppSpacing.gapHorizontalXs,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  // Datetime and Amount
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(
                        transaction.createdAt.formatWithTime(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        transaction.amount.asCurrency(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: typeColor,
                            ),
                      ),
                    ],
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
