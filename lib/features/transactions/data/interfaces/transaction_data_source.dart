import '../../../../core/data/interfaces/data_source.dart';
import '../../../../core/model/enums/data_source_type.dart';
import '../../../../core/services/database_service.dart';
import '../datasources/in_memory_transaction_data_source.dart';
import '../datasources/local_transaction_data_source.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionDataSource extends DataSource<Transaction> {
  static TransactionDataSource createDataSource(
    DataSourceType dataSourceType,
    DatabaseService databaseService,
  ) {
    switch (dataSourceType) {
      case DataSourceType.inMemory:
        return InMemoryTransactionDataSource();
      case DataSourceType.local:
        return LocalTransactionDataSource(databaseService);
    }
  }
}
