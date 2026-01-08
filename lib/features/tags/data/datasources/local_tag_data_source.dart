import '../../../../core/data/models/sort_param.dart';
import '../../../../core/services/database_service.dart';
import '../interfaces/tag_data_source.dart';
import '../../domain/entities/tag.dart';
import 'package:sqflite/sqflite.dart';

/// Local SQLite implementation of TagDataSource
class LocalTagDataSource implements TagDataSource {
  final DatabaseService _databaseService;

  LocalTagDataSource(this._databaseService);

  static const String _tableName = 'tags';

  /// Convert a Tag to a database map
  Map<String, dynamic> _toMap(Tag tag) {
    return {
      'id': tag.id,
      'name': tag.name,
      'created_at': tag.createdAt.millisecondsSinceEpoch,
      'last_used_at': tag.lastUsedAt.millisecondsSinceEpoch,
    };
  }

  /// Convert a database map to a Tag
  Tag _fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      lastUsedAt: DateTime.fromMillisecondsSinceEpoch(
        map['last_used_at'] as int,
      ),
    );
  }

  @override
  Future<Tag> create(Tag item) async {
    final db = await _databaseService.database;
    await db.insert(
      _tableName,
      _toMap(item),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return item;
  }

  @override
  Future<void> delete(String id) async {
    final db = await _databaseService.database;
    final count = await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    if (count == 0) {
      throw Exception('Tag with id $id not found');
    }
  }

  @override
  Future<List<Tag>> getAll({SortParam? sort}) async {
    final db = await _databaseService.database;

    String? orderBy;
    if (sort != null) {
      final direction = sort.ascending ? 'ASC' : 'DESC';
      orderBy = '${sort.field} $direction';
    }

    final maps = await db.query(_tableName, orderBy: orderBy);
    return maps.map(_fromMap).toList();
  }

  @override
  Future<Tag?> read(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<Tag> update(Tag item) async {
    final db = await _databaseService.database;
    final count = await db.update(
      _tableName,
      _toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if (count == 0) {
      throw Exception('Tag with id ${item.id} not found');
    }
    return item;
  }

  @override
  Future<Tag?> findByName(String name) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      _tableName,
      where: 'LOWER(name) = LOWER(?)',
      whereArgs: [name],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<List<Tag>> search(
    String query, {
    List<String> excludeIds = const [],
  }) async {
    final db = await _databaseService.database;

    String whereClause = 'LOWER(name) LIKE LOWER(?)';
    List<Object?> args = ['%$query%'];

    if (excludeIds.isNotEmpty) {
      final placeholders = List.filled(excludeIds.length, '?').join(',');
      whereClause += ' AND id NOT IN ($placeholders)';
      args.addAll(excludeIds);
    }

    final maps = await db.query(
      _tableName,
      where: whereClause,
      whereArgs: args,
      orderBy: 'name ASC',
    );

    return maps.map(_fromMap).toList();
  }

  @override
  Future<void> updateLastUsed(String id) async {
    final db = await _databaseService.database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final count = await db.update(
      _tableName,
      {'last_used_at': now},
      where: 'id = ?',
      whereArgs: [id],
    );

    if (count == 0) {
      throw Exception('Tag with id $id not found');
    }
  }
}
