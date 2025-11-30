import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/data/datasources/in_memory_account_data_source.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/datasources/in_memory_category_data_source.dart';
import 'package:plata_sync/features/transactions/application/transactions_manager.dart';
import 'package:plata_sync/features/transactions/data/datasources/in_memory_transaction_data_source.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';

void main() {
  group('TransactionsManager.deleteTransaction', () {
    late InMemoryTransactionDataSource dataSource;
    late TransactionsManager manager;
    final getIt = GetIt.instance;

    setUp(() {
      // Register required dependencies
      getIt.registerSingleton<AccountsManager>(
        AccountsManager(InMemoryAccountDataSource(delayMilliseconds: 0)),
      );
      getIt.registerSingleton<CategoriesManager>(
        CategoriesManager(InMemoryCategoryDataSource(delayMilliseconds: 0)),
      );

      dataSource = InMemoryTransactionDataSource(delayMilliseconds: 0);
      manager = TransactionsManager(dataSource);
    });

    tearDown(() {
      getIt.reset();
    });

    test('should recalculate balances after deleting a transaction', () async {
      // Arrange: Create a sequence of transactions with balances
      final accountId = 'account-1';

      // Transaction 1: balance before 0, amount +100, balance after 100
      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: accountId,
        amount: 100,
        balanceBefore: 0,
      );

      // Transaction 2: balance before 100, amount +50, balance after 150
      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: accountId,
        amount: 50,
        balanceBefore: 100,
      );

      // Transaction 3: balance before 150, amount -30, balance after 120
      final t3 = Transaction.create(
        id: 'tx-3',
        createdAt: DateTime(2025, 1, 1, 12, 0),
        accountId: accountId,
        amount: -30,
        balanceBefore: 150,
      );

      // Transaction 4: balance before 120, amount +20, balance after 140
      final t4 = Transaction.create(
        id: 'tx-4',
        createdAt: DateTime(2025, 1, 1, 13, 0),
        accountId: accountId,
        amount: 20,
        balanceBefore: 120,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);
      await manager.addTransaction(t3);
      await manager.addTransaction(t4);

      // Act: Delete transaction 2 (the middle one)
      await manager.deleteTransaction('tx-2');

      // Assert: Transaction 2 should be deleted
      final remainingTransactions = await dataSource.getAll();
      expect(remainingTransactions.length, 3);
      expect(remainingTransactions.any((t) => t.id == 'tx-2'), false);

      // Transaction 1 should remain unchanged (before the deleted one)
      final updatedT1 = await dataSource.read('tx-1');
      expect(updatedT1!.balanceBefore, 0);
      expect(updatedT1.balanceAfter, 100);

      // Transaction 3 should have recalculated balanceBefore
      // New: balance before 100 (from t1), amount -30, balance after 70
      final updatedT3 = await dataSource.read('tx-3');
      expect(updatedT3!.balanceBefore, 100);
      expect(updatedT3.balanceAfter, 70);

      // Transaction 4 should have recalculated balanceBefore
      // New: balance before 70 (from t3), amount +20, balance after 90
      final updatedT4 = await dataSource.read('tx-4');
      expect(updatedT4!.balanceBefore, 70);
      expect(updatedT4.balanceAfter, 90);
    });

    test('should handle deleting the first transaction', () async {
      // Arrange
      final accountId = 'account-1';

      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: accountId,
        amount: 100,
        balanceBefore: 0,
      );

      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: accountId,
        amount: 50,
        balanceBefore: 100,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);

      // Act: Delete the first transaction
      await manager.deleteTransaction('tx-1');

      // Assert: Transaction 2 should recalculate to start from 0
      final updatedT2 = await dataSource.read('tx-2');
      expect(updatedT2!.balanceBefore, 0);
      expect(updatedT2.balanceAfter, 50);
    });

    test('should handle deleting the last transaction', () async {
      // Arrange
      final accountId = 'account-1';

      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: accountId,
        amount: 100,
        balanceBefore: 0,
      );

      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: accountId,
        amount: 50,
        balanceBefore: 100,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);

      // Act: Delete the last transaction
      await manager.deleteTransaction('tx-2');

      // Assert: Transaction 1 should remain unchanged
      final updatedT1 = await dataSource.read('tx-1');
      expect(updatedT1!.balanceBefore, 0);
      expect(updatedT1.balanceAfter, 100);
    });

    test('should only affect transactions on the same account', () async {
      // Arrange: Create transactions on two different accounts
      final account1 = 'account-1';
      final account2 = 'account-2';

      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: account1,
        amount: 100,
        balanceBefore: 0,
      );

      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: account1,
        amount: 50,
        balanceBefore: 100,
      );

      final t3 = Transaction.create(
        id: 'tx-3',
        createdAt: DateTime(2025, 1, 1, 10, 30),
        accountId: account2,
        amount: 200,
        balanceBefore: 0,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);
      await manager.addTransaction(t3);

      // Act: Delete transaction on account1
      await manager.deleteTransaction('tx-1');

      // Assert: account2 transaction should remain unchanged
      final updatedT3 = await dataSource.read('tx-3');
      expect(updatedT3!.balanceBefore, 0);
      expect(updatedT3.balanceAfter, 200);

      // account1 transaction should be recalculated
      final updatedT2 = await dataSource.read('tx-2');
      expect(updatedT2!.balanceBefore, 0);
      expect(updatedT2.balanceAfter, 50);
    });

    test(
      'should reload transactions from data source after deletion',
      () async {
        // Arrange
        final accountId = 'account-1';

        final t1 = Transaction.create(
          id: 'tx-1',
          createdAt: DateTime(2025, 1, 1, 10, 0),
          accountId: accountId,
          amount: 100,
          balanceBefore: 0,
        );

        await manager.addTransaction(t1);

        // Verify transaction is in memory
        expect(manager.transactions.value.length, 1);

        // Act: Delete the transaction
        await manager.deleteTransaction('tx-1');

        // Assert: Manager should have reloaded and the list should be empty
        expect(manager.transactions.value.isEmpty, true);
      },
    );
  });
}
