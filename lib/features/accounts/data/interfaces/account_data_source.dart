import 'package:plata_sync/core/data/interfaces/data_source.dart';
import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
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

  @override
  Future<void> createSampleData() async {
    final samples = [
      Account.create(
        name: 'Checking Account',
        iconData: ObjectIconData(
          iconName: 'account_balance',
          backgroundColorHex: '#E3F2FD',
          iconColorHex: '#2196F3',
        ),
        description: 'Main checking account',
        balance: 150000, // $1,500.00
      ),
      Account.create(
        name: 'Savings Account',
        iconData: ObjectIconData(
          iconName: 'savings',
          backgroundColorHex: '#E8F5E9',
          iconColorHex: '#4CAF50',
        ),
        description: 'Emergency fund savings',
        balance: 500000, // $5,000.00
      ),
      Account.create(
        name: 'Credit Card',
        iconData: ObjectIconData(
          iconName: 'credit_card',
          backgroundColorHex: '#FFF3E0',
          iconColorHex: '#FF9800',
        ),
        description: 'Visa ending in 1234',
        balance: -25000, // -$250.00 (debt)
      ),
      Account.create(
        name: 'Cash',
        iconData: ObjectIconData(
          iconName: 'payments',
          backgroundColorHex: '#F3E5F5',
          iconColorHex: '#9C27B0',
        ),
        description: 'Physical cash on hand',
        balance: 5000, // $50.00
      ),
    ];

    for (var sample in samples) {
      try {
        await create(sample);
      } catch (e) {
        // Ignore duplicate entries if createSampleData is called multiple times
      }
    }
  }
}
