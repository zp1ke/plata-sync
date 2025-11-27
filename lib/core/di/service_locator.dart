import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plata_sync/core/services/database_service.dart';
import 'package:plata_sync/core/services/settings_service.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
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
  getIt.registerSingleton<CategoryDataSource>(
    CategoryDataSource.createDataSource(dataSourceType, databaseService),
  );

  // Managers
  getIt.registerLazySingleton<CategoriesManager>(
    () => CategoriesManager(getIt<CategoryDataSource>()),
  );
}

T getService<T extends Object>() => getIt<T>();
