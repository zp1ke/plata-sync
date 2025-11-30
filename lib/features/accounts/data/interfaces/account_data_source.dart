import 'package:plata_sync/core/data/interfaces/data_source.dart';
import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:plata_sync/core/services/database_service.dart';
import 'package:plata_sync/features/accounts/data/datasources/in_memory_account_data_source.dart';
import 'package:plata_sync/features/accounts/data/datasources/local_account_data_source.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';

abstract class AccountDataSource extends DataSource<Account> {
  static AccountDataSource createDataSource(
    DataSourceType dataSourceType,
    DatabaseService databaseService,
  ) {
    switch (dataSourceType) {
      case DataSourceType.inMemory:
        return InMemoryAccountDataSource();
      case DataSourceType.local:
        return LocalAccountDataSource(databaseService);
    }
  }
}
