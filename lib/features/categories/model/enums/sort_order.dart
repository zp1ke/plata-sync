import 'package:plata_sync/core/data/models/sort_param.dart';
import 'package:plata_sync/core/model/sort_param_provider.dart';

enum CategorySortOrder implements SortParamProvider {
  nameAsc(isDescending: false),
  nameDesc(isDescending: true),
  lastUsedAsc(isDescending: false),
  lastUsedDesc(isDescending: true);

  final bool isDescending;
  const CategorySortOrder({required this.isDescending});

  @override
  SortParam sortParam() {
    return switch (this) {
      CategorySortOrder.nameAsc => SortParam('name', ascending: true),
      CategorySortOrder.nameDesc => SortParam('name', ascending: false),
      CategorySortOrder.lastUsedAsc => SortParam('lastUsed', ascending: true),
      CategorySortOrder.lastUsedDesc => SortParam('lastUsed', ascending: false),
    };
  }
}
