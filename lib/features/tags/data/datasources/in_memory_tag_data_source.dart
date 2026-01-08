import '../../../../core/data/models/sort_param.dart';
import '../interfaces/tag_data_source.dart';
import '../../domain/entities/tag.dart';

/// In-memory implementation of TagDataSource for testing and development
class InMemoryTagDataSource implements TagDataSource {
  final Map<String, Tag> _tags = {};
  final int delayMilliseconds;

  InMemoryTagDataSource({this.delayMilliseconds = 300});

  Future<void> _delay() async {
    if (delayMilliseconds > 0) {
      await Future.delayed(Duration(milliseconds: delayMilliseconds));
    }
  }

  @override
  Future<List<Tag>> getAll({SortParam? sort}) async {
    await _delay();
    var tagList = _tags.values.toList();

    if (sort != null) {
      tagList.sort((a, b) {
        int comparison;
        switch (sort.field) {
          case 'name':
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
            break;
          case 'lastUsedAt':
            comparison = a.lastUsedAt.compareTo(b.lastUsedAt);
            break;
          case 'createdAt':
            comparison = a.createdAt.compareTo(b.createdAt);
            break;
          default:
            comparison = 0;
        }
        return sort.ascending ? comparison : -comparison;
      });
    }

    return tagList;
  }

  @override
  Future<Tag?> read(String id) async {
    await _delay();
    return _tags[id];
  }

  @override
  Future<Tag?> findByName(String name) async {
    await _delay();
    final lowerName = name.toLowerCase();
    return _tags.values
        .where((tag) => tag.name.toLowerCase() == lowerName)
        .firstOrNull;
  }

  @override
  Future<Tag> create(Tag tag) async {
    await _delay();
    _tags[tag.id] = tag;
    return tag;
  }

  @override
  Future<Tag> update(Tag tag) async {
    await _delay();
    if (!_tags.containsKey(tag.id)) {
      throw Exception('Tag with id ${tag.id} not found');
    }
    _tags[tag.id] = tag;
    return tag;
  }

  @override
  Future<void> delete(String id) async {
    await _delay();
    _tags.remove(id);
  }

  @override
  Future<List<Tag>> search(
    String query, {
    List<String> excludeIds = const [],
  }) async {
    await _delay();
    var tags = _tags.values;

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      tags = tags.where((tag) => tag.name.toLowerCase().contains(lowerQuery));
    }

    if (excludeIds.isNotEmpty) {
      tags = tags.where((tag) => !excludeIds.contains(tag.id));
    }

    return tags.toList();
  }

  @override
  Future<void> updateLastUsed(String id) async {
    await _delay();
    final tag = _tags[id];
    if (tag != null) {
      _tags[id] = tag.copyWith(lastUsedAt: DateTime.now());
    }
  }
}
