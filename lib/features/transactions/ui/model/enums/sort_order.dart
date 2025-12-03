import 'package:plata_sync/core/data/models/sort_param.dart';
import 'package:plata_sync/core/model/sort_param_provider.dart';

enum TransactionSortOrder implements SortParamProvider {
  dateAsc(isDescending: false),
  dateDesc(isDescending: true),
  amountAsc(isDescending: false),
  amountDesc(isDescending: true);

  final bool isDescending;

  const TransactionSortOrder({required this.isDescending});

  @override
  SortParam sortParam() {
    return switch (this) {
      TransactionSortOrder.dateAsc => SortParam('createdAt', ascending: true),
      TransactionSortOrder.dateDesc => SortParam('createdAt', ascending: false),
      TransactionSortOrder.amountAsc => SortParam('amount', ascending: true),
      TransactionSortOrder.amountDesc => SortParam('amount', ascending: false),
    };
  }
}
