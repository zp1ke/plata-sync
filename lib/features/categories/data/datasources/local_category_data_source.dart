import '../../../../core/data/models/sort_param.dart';
import '../../../../core/model/object_icon_data.dart';
import '../../../../core/services/database_service.dart';
import '../interfaces/category_data_source.dart';
import '../../domain/entities/category.dart';
import '../../model/enums/category_transaction_type.dart';
import 'package:sqflite/sqflite.dart';

class LocalCategoryDataSource extends CategoryDataSource {
  final DatabaseService _databaseService;

  LocalCategoryDataSource(this._databaseService);

  static const String _tableName = 'categories';

  /// Convert a Category to a database map
  Map<String, dynamic> _toMap(Category category) {
    return {
      'id': category.id,
      'created_at': category.createdAt.millisecondsSinceEpoch,
      'name': category.name,
      'icon_name': category.iconData.iconName,
      'background_color_hex': category.iconData.backgroundColorHex,
      'icon_color_hex': category.iconData.iconColorHex,
      'last_used': category.lastUsed?.millisecondsSinceEpoch,
      'description': category.description,
      'transaction_type': category.transactionType?.toDbString(),
      'enabled': category.enabled ? 1 : 0,
    };
  }

  /// Convert a database map to a Category
  Category _fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      name: map['name'] as String,
      iconData: ObjectIconData(
        iconName: map['icon_name'] as String,
        backgroundColorHex: map['background_color_hex'] as String,
        iconColorHex: map['icon_color_hex'] as String,
      ),
      lastUsed: map['last_used'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_used'] as int)
          : null,
      description: map['description'] as String?,
      transactionType: CategoryTransactionType.fromString(
        map['transaction_type'] as String?,
      ),
      enabled: (map['enabled'] as int?) == 1,
    );
  }

  @override
  Future<Category> create(Category item) async {
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
      throw Exception('Category with id $id not found');
    }
  }

  @override
  Future<List<Category>> getAll({
    Map<String, dynamic>? filter,
    SortParam? sort,
    int? limit,
    int? offset,
  }) async {
    final db = await _databaseService.database;

    String? where;
    List<dynamic>? whereArgs;

    if (filter != null) {
      final conditions = <String>[];
      final args = <dynamic>[];

      if (filter.containsKey('id')) {
        conditions.add('id = ?');
        args.add(filter['id']);
      }

      if (filter.containsKey('name')) {
        conditions.add('name LIKE ?');
        args.add('%${filter['name']}%');
      }

      if (filter.containsKey('description')) {
        conditions.add('description LIKE ?');
        args.add('%${filter['description']}%');
      }

      if (filter.containsKey('transactionType')) {
        // Include categories with null transaction_type (applicable to all types)
        conditions.add('(transaction_type = ? OR transaction_type IS NULL)');
        args.add(filter['transactionType']);
      }

      // Filter by enabled status (defaults to only enabled items)
      if (filter.containsKey('includeDisabled') &&
          filter['includeDisabled'] == true) {
        // Include disabled items - no filter needed
      } else {
        conditions.add('enabled = 1');
      }

      if (conditions.isNotEmpty) {
        where = conditions.join(' AND ');
        whereArgs = args;
      }
    } else {
      // By default, only show enabled categories
      where = 'enabled = 1';
    }

    String? orderBy;
    if (sort != null) {
      final direction = sort.ascending ? 'ASC' : 'DESC';
      if (sort.field == 'name') {
        orderBy = 'name $direction';
      } else if (sort.field == 'lastUsed') {
        // Sort nulls last, then by last_used or created_at
        orderBy =
            'CASE WHEN last_used IS NULL THEN 1 ELSE 0 END, '
            'COALESCE(last_used, created_at) $direction';
      }
    }

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<Category?> read(String id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  @override
  Future<Category> update(Category item) async {
    final db = await _databaseService.database;
    final count = await db.update(
      _tableName,
      _toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    if (count == 0) {
      throw Exception('Category with id ${item.id} not found');
    }
    return item;
  }

  @override
  Future<bool> hasData() {
    return getAll(limit: 1).then((list) => list.isNotEmpty);
  }

  @override
  Future<bool> hasTransactions(String categoryId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) as count FROM transactions
      WHERE category_id = ?
    ''',
      [categoryId],
    );
    final count = result.first['count'] as int;
    return count > 0;
  }

  @override
  Future<int> count({Map<String, dynamic>? filter}) async {
    final db = await _databaseService.database;

    String? where;
    List<dynamic>? whereArgs;

    if (filter != null) {
      final conditions = <String>[];
      final args = <dynamic>[];

      if (filter.containsKey('id')) {
        conditions.add('id = ?');
        args.add(filter['id']);
      }

      if (filter.containsKey('name')) {
        conditions.add('name LIKE ?');
        args.add('%${filter['name']}%');
      }

      if (filter.containsKey('description')) {
        conditions.add('description LIKE ?');
        args.add('%${filter['description']}%');
      }

      if (filter.containsKey('transactionType')) {
        // Include categories with null transaction_type (applicable to all types)
        conditions.add('(transaction_type = ? OR transaction_type IS NULL)');
        args.add(filter['transactionType']);
      }

      // Filter by enabled status (defaults to only enabled items)
      if (filter.containsKey('includeDisabled') &&
          filter['includeDisabled'] == true) {
        // Include disabled items - no filter needed
      } else {
        conditions.add('enabled = 1');
      }

      if (conditions.isNotEmpty) {
        where = conditions.join(' AND ');
        whereArgs = args;
      }
    } else {
      // By default, only show enabled categories
      where = 'enabled = 1';
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName${where != null ? " WHERE $where" : ""}',
      whereArgs,
    );

    return result.first['count'] as int;
  }
}
