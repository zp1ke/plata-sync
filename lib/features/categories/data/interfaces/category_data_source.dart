import 'package:plata_sync/core/data/interfaces/data_source.dart';
import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/features/categories/data/datasources/in_memory_category_data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

abstract class CategoryDataSource extends DataSource<Category> {
  static CategoryDataSource createDataSource(DataSourceType dataSourceType) {
    switch (dataSourceType) {
      case DataSourceType.inMemory:
        return InMemoryCategoryDataSource();
      case DataSourceType.local:
        throw UnimplementedError('Local data source is not implemented yet');
    }
  }

  @override
  Future<void> createSampleData() async {
    final samples = [
      Category.create(
        name: 'Groceries',
        iconData: ObjectIconData(
          iconName: 'shopping_cart',
          backgroundColorHex: '#FFF9C4',
          iconColorHex: '#F9A825',
        ),
        description: 'Items to buy from the supermarket',
      ),
      Category.create(
        name: 'Utilities',
        iconData: ObjectIconData(
          iconName: 'flash_on',
          backgroundColorHex: '#FFEBEE',
          iconColorHex: '#E53935',
        ),
        description: 'Monthly bills and subscriptions',
      ),
      Category.create(
        name: 'Entertainment',
        iconData: ObjectIconData(
          iconName: 'movie',
          backgroundColorHex: '#E3F2FD',
          iconColorHex: '#2196F3',
        ),
        description: 'Movies, games, and other fun activities',
      ),
    ];

    for (final category in samples) {
      await create(category);
    }
  }
}
