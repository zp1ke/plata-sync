import '../../../../core/data/models/sort_param.dart';
import '../../../../core/model/object_icon_data.dart';
import '../../../../core/services/database_service.dart';
import '../interfaces/account_data_source.dart';
import '../../domain/entities/account.dart';
import 'package:sqflite/sqflite.dart';

class LocalAccountDataSource extends AccountDataSource {
  final DatabaseService _databaseService;

  LocalAccountDataSource(this._databaseService);

  static const String _tableName = 'accounts';

  /// Convert an Account to a database map
  Map<String, dynamic> _toMap(Account account) {
    return {
      'id': account.id,
      'created_at': account.createdAt.millisecondsSinceEpoch,
      'name': account.name,
      'icon_name': account.iconData.iconName,
      'background_color_hex': account.iconData.backgroundColorHex,
      'icon_color_hex': account.iconData.iconColorHex,
      'last_used': account.lastUsed?.millisecondsSinceEpoch,
      'description': account.description,
      'balance': account.balance,
      'enabled': account.enabled ? 1 : 0,
    };
  }

  /// Convert a database map to an Account
  Account _fromMap(Map<String, dynamic> map) {
    return Account(
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
      balance: map['balance'] as int,
      enabled: (map['enabled'] as int?) == 1,
    );
  }

  @override
  Future<Account> create(Account item) async {
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
      throw Exception('Account with id $id not found');
    }
  }

  @override
  Future<List<Account>> getAll({
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
      // By default, only show enabled accounts
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
      } else if (sort.field == 'balance') {
        orderBy = 'balance $direction';
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
  Future<Account?> read(String id) async {
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
  Future<Account> update(Account item) async {
    final db = await _databaseService.database;
    final count = await db.update(
      _tableName,
      _toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    if (count == 0) {
      throw Exception('Account with id ${item.id} not found');
    }
    return item;
  }

  @override
  Future<bool> hasData() async {
    final db = await _databaseService.database;
    final result = await db.query(_tableName, limit: 1);
    return result.isNotEmpty;
  }

  @override
  Future<bool> hasTransactions(String accountId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) as count FROM transactions
      WHERE account_id = ? OR target_account_id = ?
    ''',
      [accountId, accountId],
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
      // By default, only show enabled accounts
      where = 'enabled = 1';
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName${where != null ? " WHERE $where" : ""}',
      whereArgs,
    );

    return result.first['count'] as int;
  }
}
