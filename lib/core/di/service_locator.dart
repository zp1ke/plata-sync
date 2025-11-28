import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plata_sync/core/services/database_service.dart';
import 'package:plata_sync/core/services/settings_service.dart';
import 'package:plata_sync/features/accounts/application/accounts_manager.dart';
import 'package:plata_sync/features/accounts/data/interfaces/account_data_source.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:plata_sync/features/transactions/application/transactions_manager.dart';
import 'package:plata_sync/features/transactions/data/interfaces/transaction_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // SharedPreferences (async initialization)
  final prefs = await SharedPreferences.getInstance();

  // PackageInfo (async initialization)
  final packageInfo = await PackageInfo.fromPlatform();

  // Settings Service
  final settingsService = SettingsService(prefs, packageInfo);
  getIt.registerSingleton<SettingsService>(settingsService);

  // Database Service
  final databaseService = DatabaseService();
  getIt.registerSingleton<DatabaseService>(databaseService);

  // Data Sources
  final dataSourceType = settingsService.getDataSource();
  final categoryDataSource = CategoryDataSource.createDataSource(
    dataSourceType,
    databaseService,
  );
  getIt.registerSingleton<CategoryDataSource>(categoryDataSource);
  final accountDataSource = AccountDataSource.createDataSource(
    dataSourceType,
    databaseService,
  );
  getIt.registerSingleton<AccountDataSource>(accountDataSource);
  final transactionDataSource = TransactionDataSource.createDataSource(
    dataSourceType,
    databaseService,
  );
  getIt.registerSingleton<TransactionDataSource>(transactionDataSource);

  // Managers
  getIt.registerLazySingleton<CategoriesManager>(
    () => CategoriesManager(categoryDataSource),
  );
  getIt.registerLazySingleton<AccountsManager>(
    () => AccountsManager(accountDataSource),
  );
  getIt.registerLazySingleton<TransactionsManager>(
    () => TransactionsManager(transactionDataSource),
  );
}

T getService<T extends Object>() => getIt<T>();
