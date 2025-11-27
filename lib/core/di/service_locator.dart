import 'package:get_it/get_it.dart';
import 'package:plata_sync/core/services/settings_service.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // SharedPreferences (async initialization)
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Settings Service
  final settingsService = SettingsService(prefs);
  getIt.registerSingleton<SettingsService>(settingsService);

  // Data Sources
  final dataSourceType = settingsService.getDataSource();
  getIt.registerSingleton<CategoryDataSource>(
    CategoryDataSource.createDataSource(dataSourceType),
  );

  // Managers
  getIt.registerLazySingleton<CategoriesManager>(
    () => CategoriesManager(getIt<CategoryDataSource>()),
  );
}

T getService<T extends Object>() => getIt<T>();
