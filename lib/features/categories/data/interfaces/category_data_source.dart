import 'package:plata_sync/core/data/interfaces/data_source.dart';
import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:plata_sync/core/services/database_service.dart';
import 'package:plata_sync/features/categories/data/datasources/in_memory_category_data_source.dart';
import 'package:plata_sync/features/categories/data/datasources/local_category_data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

abstract class CategoryDataSource extends DataSource<Category> {
  static CategoryDataSource createDataSource(
    DataSourceType dataSourceType,
    DatabaseService databaseService,
  ) {
    switch (dataSourceType) {
      case DataSourceType.inMemory:
        return InMemoryCategoryDataSource();
      case DataSourceType.local:
        return LocalCategoryDataSource(databaseService);
    }
  }
}
