import 'dart:math';

import 'package:plata_sync/core/data/interfaces/data_source.dart';
import 'package:plata_sync/core/di/service_locator.dart';
import 'package:plata_sync/core/model/enums/data_source_type.dart';
import 'package:plata_sync/core/services/database_service.dart';
import 'package:plata_sync/features/accounts/data/interfaces/account_data_source.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
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

  @override
  Future<void> createSampleData() async {
    final accountDataSource = getService<AccountDataSource>();
    final categoryDataSource = getService<CategoryDataSource>();

    final accounts = await accountDataSource.getAll();
    final categories = await categoryDataSource.getAll();

    if (accounts.isEmpty || categories.isEmpty) {
      return;
    }

    final random = Random();
    final today = DateTime.now();

    // Create 1 expense transaction
    final expenseAccount = accounts[random.nextInt(accounts.length)];
    final expenseCategory = categories[random.nextInt(categories.length)];
    final expense = Transaction.create(
      accountId: expenseAccount.id,
      categoryId: expenseCategory.id,
      amount: -(random.nextInt(10000) + 1000), // -$10 to -$110
      balanceBefore: expenseAccount.balance,
      notes: 'Sample expense transaction',
      createdAt: today,
    );

    // Create 1 income transaction
    final incomeAccount = accounts[random.nextInt(accounts.length)];
    final incomeCategory = categories[random.nextInt(categories.length)];
    final income = Transaction.create(
      accountId: incomeAccount.id,
      categoryId: incomeCategory.id,
      amount: random.nextInt(50000) + 10000, // $100 to $600
      balanceBefore: incomeAccount.balance,
      notes: 'Sample income transaction',
      createdAt: today,
    );

    try {
      await create(expense);
      await create(income);
    } catch (e) {
      // Ignore duplicate entries if createSampleData is called multiple times
    }
  }
}
