import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_colors.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/sort_selector.dart';
import '../../../../core/ui/widgets/view_toggle.dart';
import '../../../../core/utils/numbers.dart';
import '../../application/transactions_manager.dart';
import '../../model/enums/sort_order.dart';
import '../utils/transaction_ui_utils.dart';
import 'date_filter_selector.dart';
import 'transaction_filter_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class TransactionsBottomBar extends WatchingWidget
    implements PreferredSizeWidget {
  final bool showViewToggle;

  const TransactionsBottomBar({super.key, this.showViewToggle = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final incomeAmount = watchValue((TransactionsManager x) => x.incomeAmount);
    final expenseAmount = watchValue(
      (TransactionsManager x) => x.expenseAmount,
    );

    final currentAccountFilter = watchValue(
      (TransactionsManager x) => x.currentAccountFilter,
    );
    final currentCategoryFilter = watchValue(
      (TransactionsManager x) => x.currentCategoryFilter,
    );
    final currentTagFilter = watchValue(
      (TransactionsManager x) => x.currentTagFilter,
    );
    final currentTransactionTypeFilter = watchValue(
      (TransactionsManager x) => x.currentTransactionTypeFilter,
    );
    final hasActiveFilters =
        (currentAccountFilter?.isNotEmpty ?? false) ||
        (currentCategoryFilter?.isNotEmpty ?? false) ||
        (currentTagFilter?.isNotEmpty ?? false) ||
        currentTransactionTypeFilter != null;

    final isLoading = watchValue((TransactionsManager x) => x.isLoading);
    final viewMode = watchValue((TransactionsManager x) => x.viewMode);
    final sortOrder = watchValue((TransactionsManager x) => x.sortOrder);
    final dateFilter = watchValue(
      (TransactionsManager x) => x.currentDateFilter,
    );

    final colorScheme = Theme.of(context).colorScheme;
    final stats = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppIcons.transactionIncome(colorScheme.income),
        Text(
          incomeAmount.asCompactCurrency(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.income,
          ),
        ),
        AppSpacing.gapHorizontalSm,
        AppIcons.transactionExpense(colorScheme.expense),
        Text(
          expenseAmount.asCompactCurrency(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.expense,
          ),
        ),
        AppSpacing.gapHorizontalSm,
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppSizing.inputWidthMd),
          child: DateFilterSelector(
            value: dateFilter,
            onChanged: isLoading
                ? null
                : getIt<TransactionsManager>().setDateFilter,
            labelBuilder: (filter) => getDateFilterLabel(l10n, filter),
          ),
        ),
      ],
    );

    final actions = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppSizing.inputWidthMd),
          child: SortSelector<TransactionSortOrder>(
            value: sortOrder,
            onChanged: isLoading
                ? null
                : getIt<TransactionsManager>().setSortOrder,
            labelBuilder: (order) => getSortLabel(l10n, order),
            sortIconBuilder: (order) => order.isDescending
                ? AppIcons.sortDescending
                : AppIcons.sortAscending,
            options: TransactionSortOrder.values,
          ),
        ),
        IconButton(
          onPressed: isLoading
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => TransactionFilterDialog(
                      initialAccountIds: currentAccountFilter,
                      initialCategoryIds: currentCategoryFilter,
                      initialTagIds: currentTagFilter,
                      initialTransactionType: currentTransactionTypeFilter,
                      onApply:
                          (accountIds, categoryIds, tagIds, transactionType) {
                            final manager = getIt<TransactionsManager>();
                            manager.setAccountFilter(accountIds);
                            manager.setCategoryFilter(categoryIds);
                            manager.setTagFilter(tagIds);
                            manager.setTransactionTypeFilter(transactionType);
                          },
                    ),
                  );
                },
          icon: hasActiveFilters ? AppIcons.filterEdit : AppIcons.filter,
          tooltip: l10n.filterTransactions,
        ),
        if (showViewToggle) ...[
          AppSpacing.gapHorizontalSm,
          ViewToggle(
            value: viewMode,
            onChanged: isLoading
                ? null
                : getIt<TransactionsManager>().setViewMode,
          ),
        ],
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [stats, actions],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
