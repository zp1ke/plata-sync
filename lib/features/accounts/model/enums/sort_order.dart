import '../../../../core/data/models/sort_param.dart';
import '../../../../core/model/sort_param_provider.dart';

enum AccountSortOrder implements SortParamProvider {
  nameAsc(isDescending: false),
  nameDesc(isDescending: true),
  lastUsedAsc(isDescending: false),
  lastUsedDesc(isDescending: true),
  balanceAsc(isDescending: false),
  balanceDesc(isDescending: true);

  final bool isDescending;
  const AccountSortOrder({required this.isDescending});

  @override
  SortParam sortParam() {
    return switch (this) {
      AccountSortOrder.nameAsc => SortParam('name', ascending: true),
      AccountSortOrder.nameDesc => SortParam('name', ascending: false),
      AccountSortOrder.lastUsedAsc => SortParam('lastUsed', ascending: true),
      AccountSortOrder.lastUsedDesc => SortParam('lastUsed', ascending: false),
      AccountSortOrder.balanceAsc => SortParam('balance', ascending: true),
      AccountSortOrder.balanceDesc => SortParam('balance', ascending: false),
    };
  }
}
