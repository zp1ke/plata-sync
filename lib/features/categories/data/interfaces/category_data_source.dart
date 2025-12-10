import '../../../../core/data/interfaces/data_source.dart';
import '../../../../core/model/enums/data_source_type.dart';
import '../../../../core/services/database_service.dart';
import '../datasources/in_memory_category_data_source.dart';
import '../datasources/local_category_data_source.dart';
import '../../domain/entities/category.dart';

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
