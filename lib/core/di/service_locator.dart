import 'package:get_it/get_it.dart';
import 'package:plata_sync/features/categories/application/categories_manager.dart';
import 'package:plata_sync/features/categories/data/datasources/in_memory_category_data_source.dart';
import 'package:plata_sync/features/categories/data/interfaces/category_data_source.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Data Sources
  getIt.registerSingleton<CategoryDataSource>(InMemoryCategoryDataSource());

  // Managers
  getIt.registerLazySingleton<CategoriesManager>(
    () => CategoriesManager(getIt<CategoryDataSource>()),
  );
}

T getService<T extends Object>() => getIt<T>();
