import '../../../../core/data/interfaces/data_source.dart';
import '../../../../core/model/enums/data_source_type.dart';
import '../../../../core/services/database_service.dart';
import '../datasources/in_memory_account_data_source.dart';
import '../datasources/local_account_data_source.dart';
import '../../domain/entities/account.dart';

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

  /// Check if an account has associated transactions
  Future<bool> hasTransactions(String accountId);
}
