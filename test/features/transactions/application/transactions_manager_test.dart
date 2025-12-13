import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/services/settings_service.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/data/datasources/in_memory_account_data_source.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/accounts/model/enums/sort_order.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/datasources/in_memory_category_data_source.dart';
import 'package:plata_sync/features/categories/model/enums/sort_order.dart';
import 'package:plata_sync/features/transactions/application/transactions_manager.dart';
import 'package:plata_sync/features/transactions/data/datasources/in_memory_transaction_data_source.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';
import 'package:plata_sync/features/transactions/model/enums/date_filter.dart';
import 'package:plata_sync/features/transactions/model/enums/sort_order.dart';

class _MockSettingsService implements SettingsService {
  @override
  String getAppVersion() => '0.0.1+1';

  @override
  AccountSortOrder? getAccountsSortOrder() => null;

  @override
  CategorySortOrder? getCategoriesSortOrder() => null;

  @override
  TransactionSortOrder? getTransactionsSortOrder() => null;

  @override
  Future<bool> setAccountsSortOrder(AccountSortOrder sortOrder) async => true;

  @override
  Future<bool> setCategoriesSortOrder(CategorySortOrder sortOrder) async =>
      true;

  @override
  Future<bool> setTransactionsSortOrder(TransactionSortOrder sortOrder) async =>
      true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('TransactionsManager.deleteTransaction', () {
    late InMemoryTransactionDataSource dataSource;
    late AccountsManager accountManager;
    late TransactionsManager manager;
    final getIt = GetIt.instance;

    setUp(() {
      // Register SettingsService first, before creating managers
      getIt.registerSingleton<SettingsService>(_MockSettingsService());

      accountManager = AccountsManager(
        InMemoryAccountDataSource(delayMilliseconds: 0),
      );
      dataSource = InMemoryTransactionDataSource(delayMilliseconds: 0);
      manager = TransactionsManager(dataSource);
      manager.setDateFilter(DateFilter.all);

      // Register remaining dependencies
      getIt.registerSingleton<AccountsManager>(accountManager);
      getIt.registerSingleton<CategoriesManager>(
        CategoriesManager(InMemoryCategoryDataSource(delayMilliseconds: 0)),
      );
    });

    tearDown(() {
      getIt.reset();
    });

    test('should recalculate balances after deleting a transaction', () async {
      // Arrange: Create a sequence of transactions with balances
      var account = Account.create(
        id: 'account-1',
        name: 'Test Account',
        iconData: ObjectIconData.empty(),
        balance: 0,
      );
      await accountManager.addAccount(account);

      // Transaction 1: balance before 0, amount +100, balance after 100
      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: account.id,
        amount: 100,
        accountBalanceBefore: 0,
      );

      // Transaction 2: balance before 100, amount +50, balance after 150
      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: account.id,
        amount: 50,
        accountBalanceBefore: 100,
      );

      // Transaction 3: balance before 150, amount -30, balance after 120
      final t3 = Transaction.create(
        id: 'tx-3',
        createdAt: DateTime(2025, 1, 1, 12, 0),
        accountId: account.id,
        amount: -30,
        accountBalanceBefore: 150,
      );

      // Transaction 4: balance before 120, amount +20, balance after 140
      final t4 = Transaction.create(
        id: 'tx-4',
        createdAt: DateTime(2025, 1, 1, 13, 0),
        accountId: account.id,
        amount: 20,
        accountBalanceBefore: 120,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);
      await manager.addTransaction(t3);
      await manager.addTransaction(t4);

      // Assert: Initial balances are correct
      var updatedAccount = await accountManager.getAccountById(account.id);
      expect(updatedAccount, isNotNull);
      expect(updatedAccount!.balance, t4.accountBalanceAfter);

      // Act: Delete transaction 2 (the middle one)
      await manager.deleteTransaction('tx-2');

      // Assert: Transaction 2 should be deleted
      final remainingTransactions = await dataSource.getAll();
      expect(remainingTransactions.length, 3);
      expect(remainingTransactions.any((t) => t.id == 'tx-2'), false);

      // Transaction 1 should remain unchanged (before the deleted one)
      final updatedT1 = await dataSource.read('tx-1');
      expect(updatedT1!.accountBalanceBefore, 0);
      expect(updatedT1.accountBalanceAfter, 100);

      // Transaction 3 should have recalculated accountBalanceBefore
      // New: balance before 100 (from t1), amount -30, balance after 70
      final updatedT3 = await dataSource.read('tx-3');
      expect(updatedT3!.accountBalanceBefore, 100);
      expect(updatedT3.accountBalanceAfter, 70);

      // Transaction 4 should have recalculated accountBalanceBefore
      // New: balance before 70 (from t3), amount +20, balance after 90
      final updatedT4 = await dataSource.read('tx-4');
      expect(updatedT4!.accountBalanceBefore, 70);
      expect(updatedT4.accountBalanceAfter, 90);
    });

    test('should handle deleting the first transaction', () async {
      // Arrange
      var account = Account.create(
        id: 'account-1',
        name: 'Test Account',
        iconData: ObjectIconData.empty(),
        balance: 0,
      );
      await accountManager.addAccount(account);

      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: account.id,
        amount: 100,
        accountBalanceBefore: 0,
      );

      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: account.id,
        amount: 50,
        accountBalanceBefore: 100,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);

      // Act: Delete the first transaction
      await manager.deleteTransaction('tx-1');

      // Assert: Transaction 2 should recalculate to start from 0
      final updatedT2 = await dataSource.read('tx-2');
      expect(updatedT2!.accountBalanceBefore, 0);
      expect(updatedT2.accountBalanceAfter, 50);
    });

    test('should handle deleting the last transaction', () async {
      // Arrange
      var account = Account.create(
        id: 'account-1',
        name: 'Test Account',
        iconData: ObjectIconData.empty(),
        balance: 0,
      );
      await accountManager.addAccount(account);

      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: account.id,
        amount: 100,
        accountBalanceBefore: 0,
      );

      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: account.id,
        amount: 50,
        accountBalanceBefore: 100,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);

      // Act: Delete the last transaction
      await manager.deleteTransaction('tx-2');

      // Assert: Transaction 1 should remain unchanged
      final updatedT1 = await dataSource.read('tx-1');
      expect(updatedT1!.accountBalanceBefore, 0);
      expect(updatedT1.accountBalanceAfter, 100);
    });

    test('should only affect transactions on the same account', () async {
      // Arrange: Create transactions on two different accounts
      var account1 = Account.create(
        id: 'account-1',
        name: 'Test Account 1',
        iconData: ObjectIconData.empty(),
        balance: 0,
      );
      await accountManager.addAccount(account1);

      var account2 = Account.create(
        id: 'account-2',
        name: 'Test Account 2',
        iconData: ObjectIconData.empty(),
        balance: 0,
      );
      await accountManager.addAccount(account2);

      final t1 = Transaction.create(
        id: 'tx-1',
        createdAt: DateTime(2025, 1, 1, 10, 0),
        accountId: account1.id,
        amount: 100,
        accountBalanceBefore: 0,
      );

      final t2 = Transaction.create(
        id: 'tx-2',
        createdAt: DateTime(2025, 1, 1, 11, 0),
        accountId: account1.id,
        amount: 50,
        accountBalanceBefore: 100,
      );

      final t3 = Transaction.create(
        id: 'tx-3',
        createdAt: DateTime(2025, 1, 1, 10, 30),
        accountId: account2.id,
        amount: 200,
        accountBalanceBefore: 0,
      );

      await manager.addTransaction(t1);
      await manager.addTransaction(t2);
      await manager.addTransaction(t3);

      // Act: Delete transaction on account1
      await manager.deleteTransaction('tx-1');

      // Assert: account2 transaction should remain unchanged
      final updatedT3 = await dataSource.read('tx-3');
      expect(updatedT3!.accountBalanceBefore, 0);
      expect(updatedT3.accountBalanceAfter, 200);

      // account1 transaction should be recalculated
      final updatedT2 = await dataSource.read('tx-2');
      expect(updatedT2!.accountBalanceBefore, 0);
      expect(updatedT2.accountBalanceAfter, 50);
    });

    test(
      'should reload transactions from data source after deletion',
      () async {
        // Arrange
        var account = Account.create(
          id: 'account-1',
          name: 'Test Account',
          iconData: ObjectIconData.empty(),
          balance: 0,
        );
        await accountManager.addAccount(account);

        final t1 = Transaction.create(
          id: 'tx-1',
          createdAt: DateTime(2025, 1, 1, 10, 0),
          accountId: account.id,
          amount: 100,
          accountBalanceBefore: 0,
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

    test(
      'should update both account balances when deleting a transfer transaction',
      () async {
        // Arrange
        final accountsManager = getIt.get<AccountsManager>();

        // Create two accounts with initial balances
        final sourceAccount = Account.create(
          id: 'source-account',
          name: 'Source Account',
          iconData: ObjectIconData(
            iconName: 'wallet',
            backgroundColorHex: '#FF0000',
            iconColorHex: '#FFFFFF',
          ),
          balance: 1000, // $10.00
        );

        final targetAccount = Account.create(
          id: 'target-account',
          name: 'Target Account',
          iconData: ObjectIconData(
            iconName: 'savings',
            backgroundColorHex: '#00FF00',
            iconColorHex: '#FFFFFF',
          ),
          balance: 500, // $5.00
        );

        await accountsManager.addAccount(sourceAccount);
        await accountsManager.addAccount(targetAccount);

        // Create a transfer transaction: move $3.00 from source to target
        final transferTransaction = Transaction.create(
          id: 'transfer-1',
          createdAt: DateTime(2025, 1, 1, 10, 0),
          accountId: sourceAccount.id,
          targetAccountId: targetAccount.id,
          amount: -300,
          // -$3.00 from source
          accountBalanceBefore: 1000,
          targetAccountBalanceBefore: 500,
        );

        await manager.addTransaction(transferTransaction);

        // Verify balances after transaction
        final sourceAfterAdd = await accountsManager.getAccountById(
          sourceAccount.id,
        );
        final targetAfterAdd = await accountsManager.getAccountById(
          targetAccount.id,
        );
        expect(sourceAfterAdd!.balance, 700); // 1000 - 300 = 700
        expect(targetAfterAdd!.balance, 800); // 500 + 300 = 800

        // Act: Delete the transfer transaction
        await manager.deleteTransaction('transfer-1');

        // Assert: Both accounts should return to their original balances
        final sourceAfterDelete = await accountsManager.getAccountById(
          sourceAccount.id,
        );
        final targetAfterDelete = await accountsManager.getAccountById(
          targetAccount.id,
        );

        expect(sourceAfterDelete!.balance, 1000); // Back to original $10.00
        expect(targetAfterDelete!.balance, 500); // Back to original $5.00
      },
    );

    test(
      'should calculate balance correctly when adding first transaction to account with initial balance',
      () async {
        // Arrange: Create an account with an initial balance
        final account = Account.create(
          id: 'account-1',
          name: 'Test Account',
          iconData: ObjectIconData.empty(),
          balance: 50000, // Initial balance of $500.00
        );
        await accountManager.addAccount(account);

        // Act: Add first transaction with balance before set to account's initial balance
        final transaction = Transaction.create(
          id: 'tx-1',
          createdAt: DateTime(2025, 1, 1, 10, 0),
          accountId: account.id,
          amount: 10000, // Income of $100.00
          accountBalanceBefore: 50000, // Should use account's initial balance
        );
        await manager.addTransaction(transaction);

        // Assert: Account balance should be initial balance + transaction amount
        final updatedAccount = await accountManager.getAccountById(account.id);
        expect(updatedAccount, isNotNull);
        expect(updatedAccount!.balance, 60000); // $500.00 + $100.00 = $600.00

        // Verify the transaction was saved with correct accountBalanceBefore
        final savedTransaction = await dataSource.read('tx-1');
        expect(savedTransaction, isNotNull);
        expect(savedTransaction!.accountBalanceBefore, 50000);
        expect(savedTransaction.accountBalanceAfter, 60000);
      },
    );

    test(
      'should fail when adding first transaction with zero accountBalanceBefore to account with initial balance',
      () async {
        // Arrange: Create an account with an initial balance
        final account = Account.create(
          id: 'account-1',
          name: 'Test Account',
          iconData: ObjectIconData.empty(),
          balance: 50000, // Initial balance of $500.00
        );
        await accountManager.addAccount(account);

        // Act: Add first transaction with balance before incorrectly set to 0
        final transaction = Transaction.create(
          id: 'tx-1',
          createdAt: DateTime(2025, 1, 1, 10, 0),
          accountId: account.id,
          amount: 10000, // Income of $100.00
          accountBalanceBefore: 0, // WRONG: should be 50000
        );
        await manager.addTransaction(transaction);

        // Assert: This demonstrates the bug - account balance is incorrectly calculated
        final updatedAccount = await accountManager.getAccountById(account.id);
        expect(updatedAccount, isNotNull);
        // Bug: Balance ends up as just the transaction amount (10000)
        // instead of initial + transaction (60000)
        expect(
          updatedAccount!.balance,
          10000,
        ); // WRONG: Should be 60000 but bug causes it to be 10000
      },
    );
  });
}
