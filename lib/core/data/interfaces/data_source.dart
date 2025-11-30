import 'package:plata_sync/core/data/models/sort_param.dart';

abstract class DataSource<T> {
  Future<T> create(T item);
  Future<T?> read(String id);
  Future<List<T>> getAll({
    Map<String, dynamic>? filter,
    SortParam? sort,
    int? limit,
    int? offset,
  });
  Future<T> update(T item);
  Future<void> delete(String id);
}
