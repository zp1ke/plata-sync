import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/enums/view_mode.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';
import 'package:plata_sync/core/ui/widgets/sort_selector.dart';
import 'package:plata_sync/core/ui/widgets/view_toggle.dart';
import 'package:plata_sync/features/transactions/application/transactions_manager.dart';
import 'package:plata_sync/features/transactions/model/enums/sort_order.dart';
import 'package:plata_sync/features/transactions/ui/utils/transaction_ui_utils.dart';
import 'package:plata_sync/features/transactions/ui/widgets/transaction_filter_dialog.dart';
import 'package:plata_sync/l10n/app_localizations.dart';
import 'package:watch_it/watch_it.dart';

class TransactionsBottomBar extends WatchingWidget
    implements PreferredSizeWidget {
  final TransactionSortOrder sortOrder;
  final ViewMode viewMode;
  final TransactionsManager manager;
  final bool isLoading;
  final bool showViewToggle;

  const TransactionsBottomBar({
    super.key,
    required this.sortOrder,
    required this.viewMode,
    required this.manager,
    required this.isLoading,
    this.showViewToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final currentAccountFilter = watchValue(
      (TransactionsManager x) => x.currentAccountFilter,
    );
    final currentCategoryFilter = watchValue(
      (TransactionsManager x) => x.currentCategoryFilter,
    );
    final hasActiveFilters =
        currentAccountFilter != null || currentCategoryFilter != null;

    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppSizing.inputWidthMd),
          child: SortSelector<TransactionSortOrder>(
            value: sortOrder,
            onChanged: isLoading ? null : manager.setSortOrder,
            labelBuilder: (order) => getSortLabel(l10n, order),
            sortIconBuilder: (order) => order.isDescending
                ? AppIcons.sortDescending
                : AppIcons.sortAscending,
            options: TransactionSortOrder.values,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: isLoading
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => TransactionFilterDialog(
                      initialAccountId: currentAccountFilter,
                      initialCategoryId: currentCategoryFilter,
                      onApply: (accountId, categoryId) {
                        manager.setAccountFilter(accountId);
                        manager.setCategoryFilter(categoryId);
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
            onChanged: isLoading ? null : manager.setViewMode,
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
