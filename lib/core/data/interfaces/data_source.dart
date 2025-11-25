import 'package:plata_sync/core/data/models/sort_param.dart';

abstract class DataSource<T> {
  Future<void> createSampleData();
  Future<T> create(T item);
  Future<T?> read(String id);
  Future<List<T>> getAll({Map<String, dynamic>? filter, SortParam? sort});
  Future<T> update(T item);
  Future<void> delete(String id);
}
