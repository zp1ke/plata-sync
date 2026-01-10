import 'package:flutter/foundation.dart';
import '../../../core/utils/random.dart';
import '../data/interfaces/tag_data_source.dart';
import '../domain/entities/tag.dart';

class TagsManager {
  final TagDataSource _dataSource;

  TagsManager(this._dataSource);

  final ValueNotifier<List<Tag>> tags = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Get or create a tag by name
  /// If a tag with the same name exists (case-insensitive), return it
  /// Otherwise, create a new tag
  Future<Tag> getOrCreateTag(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Tag name cannot be empty');
    }

    // Check if tag already exists
    final existing = await _dataSource.findByName(trimmedName);
    if (existing != null) {
      // Update last used timestamp
      await _dataSource.updateLastUsed(existing.id);
      return existing.copyWith(lastUsedAt: DateTime.now());
    }

    // Create new tag
    final newTag = Tag.create(id: randomId(), name: trimmedName);

    return await _dataSource.create(newTag);
  }

  /// Get multiple tags by their IDs
  Future<List<Tag>> getTagsByIds(List<String> tagIds) async {
    final tagsList = <Tag>[];
    for (final id in tagIds) {
      final tag = await _dataSource.read(id);
      if (tag != null) {
        tagsList.add(tag);
      }
    }
    return tagsList;
  }

  /// Search for tags by query
  Future<List<Tag>> searchTags(
    String query, {
    List<String> excludeIds = const [],
  }) async {
    return await _dataSource.search(query, excludeIds: excludeIds);
  }

  /// Load all tags
  Future<void> loadTags() async {
    isLoading.value = true;
    try {
      tags.value = await _dataSource.getAll();
    } catch (e) {
      debugPrint('Error loading tags: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing tag
  Future<Tag> updateTag(Tag tag) async {
    final updated = await _dataSource.update(tag);
    await loadTags();
    return updated;
  }

  /// Delete a tag by ID
  Future<void> deleteTag(String id) async {
    await _dataSource.delete(id);
    await loadTags();
  }
}
