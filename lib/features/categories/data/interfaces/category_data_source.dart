import 'package:plata_sync/core/data/interfaces/data_source.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';

abstract class CategoryDataSource extends DataSource<Category> {
  @override
  Future<void> createSampleData() async {
    final samples = [
      Category.create(
        name: 'Groceries',
        icon: 'shopping_cart',
        backgroundColorHex: '#FFF9C4',
        iconColorHex: '#F9A825',
        description: 'Items to buy from the supermarket',
      ),
      Category.create(
        name: 'Utilities',
        icon: 'bolt',
        backgroundColorHex: '#E8F5E9',
        iconColorHex: '#4CAF50',
        description: 'Monthly bills and subscriptions',
      ),
      Category.create(
        name: 'Entertainment',
        icon: 'movie',
        backgroundColorHex: '#E3F2FD',
        iconColorHex: '#2196F3',
        description: 'Movies, games, and other fun activities',
      ),
    ];

    for (final category in samples) {
      await create(category);
    }
  }
}
