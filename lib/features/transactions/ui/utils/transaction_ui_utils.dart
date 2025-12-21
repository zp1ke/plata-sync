import 'package:flutter/material.dart';

import '../../domain/entities/transaction.dart';
import '../../model/enums/date_filter.dart';
import '../../model/enums/sort_order.dart';
import '../../../../l10n/app_localizations.dart';

String getDateFilterLabel(AppL10n l10n, DateFilter filter) {
  switch (filter) {
    case DateFilter.today:
      return l10n.dateFilterToday;
    case DateFilter.week:
      return l10n.dateFilterWeek;
    case DateFilter.month:
      return l10n.dateFilterMonth;
    case DateFilter.all:
      return l10n.dateFilterAll;
  }
}

String getSortLabel(AppL10n l10n, TransactionSortOrder order) {
  switch (order) {
    case TransactionSortOrder.dateAsc:
      return l10n.transactionsSortDateAsc;
    case TransactionSortOrder.dateDesc:
      return l10n.transactionsSortDateDesc;
    case TransactionSortOrder.amountAsc:
      return l10n.transactionsSortAmountAsc;
    case TransactionSortOrder.amountDesc:
      return l10n.transactionsSortAmountDesc;
  }
}

String getTransactionTypeLabel(AppL10n l10n, Transaction transaction) {
  if (transaction.isTransfer) {
    return l10n.transactionTypeTransfer;
  } else if (transaction.isExpense) {
    return l10n.transactionTypeExpense;
  } else {
    return l10n.transactionTypeIncome;
  }
}

Widget? getTransactionsEmptyContent(
  BuildContext context,
  bool isLoading,
  List<Transaction> transactions,
  DateFilter dateFilter,
  bool hasActiveFilters,
) {
  final l10n = AppL10n.of(context);
  if (isLoading && transactions.isEmpty) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  if (transactions.isEmpty) {
    var emptyMessage = l10n.transactionsEmptyState;
    if (hasActiveFilters) {
      emptyMessage = l10n.transactionsEmptyFilteredState;
    } else if (dateFilter != DateFilter.all) {
      emptyMessage = l10n.transactionsEmptyDateFilteredState(
        getDateFilterLabel(l10n, dateFilter).toLowerCase(),
      );
    }
    return Center(child: Text(emptyMessage));
  }

  return null;
}
