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
