import 'package:plata_sync/core/data/interfaces/data_source.dart';
import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:plata_sync/core/services/database_service.dart';
import 'package:plata_sync/features/transactions/data/datasources/in_memory_transaction_data_source.dart';
import 'package:plata_sync/features/transactions/data/datasources/local_transaction_data_source.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';

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
