import '../../../../core/data/models/sort_param.dart';
import '../../../../core/services/database_service.dart';
import '../interfaces/transaction_data_source.dart';
import '../../domain/entities/transaction.dart' as model;
import '../../ui/widgets/transaction_type_selector.dart';
import 'package:sqflite/sqflite.dart';

class LocalTransactionDataSource extends TransactionDataSource {
  final DatabaseService _databaseService;

  LocalTransactionDataSource(this._databaseService);

  static const String _tableName = 'transactions';

  /// Convert a Transaction to a database map
  Map<String, dynamic> _toMap(model.Transaction transaction) {
    return {
      'id': transaction.id,
      'created_at': transaction.createdAt.millisecondsSinceEpoch,
      'account_id': transaction.accountId,
      'category_id': transaction.categoryId,
      'amount': transaction.amount,
      'account_balance_before': transaction.accountBalanceBefore,
      'target_account_id': transaction.targetAccountId,
      'target_account_balance_before': transaction.targetAccountBalanceBefore,
      'notes': transaction.notes,
      'tag_ids': transaction.tagIds.isEmpty
          ? null
          : transaction.tagIds.join(','),
    };
  }

  /// Convert a database map to a Transaction
  model.Transaction _fromMap(Map<String, dynamic> map) {
    final tagIdsString = map['tag_ids'] as String?;
    final tagIds = tagIdsString == null || tagIdsString.isEmpty
        ? <String>[]
        : tagIdsString.split(',');

    return model.Transaction(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      accountId: map['account_id'] as String,
      categoryId: map['category_id'] as String?,
      amount: map['amount'] as int,
      accountBalanceBefore: map['account_balance_before'] as int,
      targetAccountId: map['target_account_id'] as String?,
      targetAccountBalanceBefore: map['target_account_balance_before'] as int?,
      notes: map['notes'] as String?,
      tagIds: tagIds,
    );
  }

  @override
  Future<model.Transaction> create(model.Transaction item) async {
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
      throw Exception('Transaction with id $id not found');
    }
  }

  @override
  Future<List<model.Transaction>> getAll({
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

      if (filter.containsKey('accountId')) {
        conditions.add('account_id = ?');
        args.add(filter['accountId']);
      }

      if (filter.containsKey('categoryId')) {
        conditions.add('category_id = ?');
        args.add(filter['categoryId']);
      }

      if (filter.containsKey('targetAccountId')) {
        conditions.add('target_account_id = ?');
        args.add(filter['targetAccountId']);
      }

      if (filter.containsKey('from')) {
        conditions.add('created_at >= ?');
        args.add((filter['from'] as DateTime).millisecondsSinceEpoch);
      }

      if (filter.containsKey('to')) {
        conditions.add('created_at <= ?');
        args.add((filter['to'] as DateTime).millisecondsSinceEpoch);
      }

      if (filter.containsKey('tagIds')) {
        final tagIds = filter['tagIds'] as List<String>;
        // Create OR conditions for each tag
        final tagConditions = tagIds.map((_) => 'tag_ids LIKE ?').toList();
        conditions.add('(${tagConditions.join(' OR ')})');
        // Add wildcards for LIKE search
        for (var tagId in tagIds) {
          args.add('%$tagId%');
        }
      }

      if (filter.containsKey('transactionType')) {
        final transactionType = filter['transactionType'] as String;
        if (transactionType == TransactionType.expense.name) {
          conditions.add('amount < 0 AND target_account_id IS NULL');
        } else if (transactionType == TransactionType.income.name) {
          conditions.add('amount > 0 AND target_account_id IS NULL');
        } else if (transactionType == TransactionType.transfer.name) {
          conditions.add('target_account_id IS NOT NULL');
        }
      }

      if (conditions.isNotEmpty) {
        where = conditions.join(' AND ');
        whereArgs = args;
      }
    }

    String? orderBy;
    if (sort != null) {
      final direction = sort.ascending ? 'ASC' : 'DESC';
      if (sort.field == 'createdAt') {
        orderBy = 'created_at $direction';
      } else if (sort.field == 'amount') {
        orderBy = 'amount $direction';
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
  Future<model.Transaction?> read(String id) async {
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
  Future<model.Transaction> update(model.Transaction item) async {
    final db = await _databaseService.database;
    final count = await db.update(
      _tableName,
      _toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    if (count == 0) {
      throw Exception('Transaction with id ${item.id} not found');
    }
    return item;
  }

  @override
  Future<bool> hasData() async {
    final db = await _databaseService.database;
    final result = await db.query(_tableName, limit: 1);
    return result.isNotEmpty;
  }
}
