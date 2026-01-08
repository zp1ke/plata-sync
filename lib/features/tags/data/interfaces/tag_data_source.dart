import '../../../../core/data/models/sort_param.dart';
import '../../../../core/model/enums/data_source_type.dart';
import '../../../../core/services/database_service.dart';
import '../datasources/in_memory_tag_data_source.dart';
import '../datasources/local_tag_data_source.dart';
import '../../domain/entities/tag.dart';

/// Data source interface for Tag operations
abstract class TagDataSource {
  /// Factory method to create the appropriate data source
  static TagDataSource createDataSource(
    DataSourceType type,
    DatabaseService databaseService,
  ) {
    switch (type) {
      case DataSourceType.local:
        return LocalTagDataSource(databaseService);
      case DataSourceType.inMemory:
        return InMemoryTagDataSource();
    }
  }

  /// Get all tags, optionally sorted
  Future<List<Tag>> getAll({SortParam? sort});

  /// Get a tag by ID
  Future<Tag?> read(String id);

  /// Get a tag by name (case-insensitive)
  Future<Tag?> findByName(String name);

  /// Create a new tag
  Future<Tag> create(Tag tag);

  /// Update an existing tag
  Future<Tag> update(Tag tag);

  /// Delete a tag by ID
  Future<void> delete(String id);

  /// Search tags by name (case-insensitive, partial match)
  Future<List<Tag>> search(String query, {List<String> excludeIds = const []});

  /// Update the lastUsedAt timestamp for a tag
  Future<void> updateLastUsed(String id);
}
