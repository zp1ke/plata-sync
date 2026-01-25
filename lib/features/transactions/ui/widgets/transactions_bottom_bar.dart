import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/ui/resources/app_colors.dart';
import '../../../../core/ui/resources/app_icons.dart';
import '../../../../core/ui/resources/app_sizing.dart';
import '../../../../core/ui/resources/app_spacing.dart';
import '../../../../core/ui/widgets/sort_selector.dart';
import '../../../../core/ui/widgets/view_toggle.dart';
import '../../../../core/utils/numbers.dart';
import '../../../accounts/application/accounts_manager.dart';
import '../../../categories/application/categories_manager.dart';
import '../../../tags/application/tags_manager.dart';
import '../../application/transactions_manager.dart';
import '../../model/enums/sort_order.dart';
import '../utils/transaction_ui_utils.dart';
import 'date_filter_selector.dart';
import 'transaction_filter_dialog.dart';
import 'transaction_type_selector.dart';
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
    final accounts = watchValue((AccountsManager x) => x.accounts);
    final categories = watchValue((CategoriesManager x) => x.categories);
    final tags = watchValue((TagsManager x) => x.tags);

    void showFilterDialog() {
      if (isLoading) return;
      showDialog(
        context: context,
        builder: (context) => TransactionFilterDialog(
          initialAccountIds: currentAccountFilter,
          initialCategoryIds: currentCategoryFilter,
          initialTagIds: currentTagFilter,
          initialTransactionType: currentTransactionTypeFilter,
          onApply: (accountIds, categoryIds, tagIds, transactionType) {
            final manager = getIt<TransactionsManager>();
            manager.setAccountFilter(accountIds);
            manager.setCategoryFilter(categoryIds);
            manager.setTagFilter(tagIds);
            manager.setTransactionTypeFilter(transactionType);
          },
        ),
      );
    }

    List<String> resolveNames<T>(
      List<T> items,
      List<String> ids,
      String Function(T item) getId,
      String Function(T item) getName,
    ) {
      if (items.isEmpty) {
        return ids;
      }
      return ids.map((id) {
        final match = items.where((item) => getId(item) == id).toList();
        if (match.isEmpty) return id;
        return getName(match.first);
      }).toList();
    }

    String transactionTypeLabel(TransactionType type) {
      switch (type) {
        case TransactionType.expense:
          return l10n.transactionTypeExpense;
        case TransactionType.income:
          return l10n.transactionTypeIncome;
        case TransactionType.transfer:
          return l10n.transactionTypeTransfer;
      }
    }

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
          onPressed: isLoading ? null : showFilterDialog,
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

    final activeFiltersLine = hasActiveFilters
        ? Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : showFilterDialog,
              borderRadius: AppSizing.borderRadiusSm,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    IconTheme(
                      data: IconTheme.of(context).copyWith(
                        size: AppSizing.iconSm,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      child: AppIcons.filterEdit,
                    ),
                    AppSpacing.gapHorizontalXs,
                    Expanded(
                      child: Text(
                        <String>[
                          if (currentAccountFilter?.isNotEmpty ?? false)
                            '${l10n.transactionAccountLabel}: ${resolveNames(accounts, currentAccountFilter!, (item) => item.id, (item) => item.name).join(', ')}',
                          if (currentCategoryFilter?.isNotEmpty ?? false)
                            '${l10n.transactionCategoryLabel}: ${resolveNames(categories, currentCategoryFilter!, (item) => item.id, (item) => item.name).join(', ')}',
                          if (currentTagFilter?.isNotEmpty ?? false)
                            '${l10n.transactionTagsLabel}: ${resolveNames(tags, currentTagFilter!, (item) => item.id, (item) => item.name).join(', ')}',
                          if (currentTransactionTypeFilter != null)
                            '${l10n.transactionTypeFilter}: ${transactionTypeLabel(currentTransactionTypeFilter)}',
                        ].join(' • '),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        stats,
        actions,
        if (activeFiltersLine != null) activeFiltersLine,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
