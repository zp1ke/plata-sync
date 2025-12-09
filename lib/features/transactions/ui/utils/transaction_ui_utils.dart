import 'package:plata_sync/features/transactions/model/enums/date_filter.dart';
import 'package:plata_sync/features/transactions/model/enums/sort_order.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

String getDateFilterLabel(AppL10n l10n, DateFilter filter) {
  switch (filter) {
    case DateFilter.today:
      return 'Today';
    case DateFilter.week:
      return 'This Week';
    case DateFilter.month:
      return 'This Month';
    case DateFilter.all:
      return 'All Time';
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
