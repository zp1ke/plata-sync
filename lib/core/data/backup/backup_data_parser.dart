import 'dart:convert';

import '../../../features/accounts/domain/entities/account.dart';
import '../../../features/categories/domain/entities/category.dart';
import '../../../features/tags/domain/entities/tag.dart';
import '../../../features/transactions/domain/entities/transaction.dart';

class BackupData {
  final List<Transaction> transactions;
  final List<Account> accounts;
  final List<Category> categories;
  final List<Tag> tags;

  const BackupData({
    required this.transactions,
    required this.accounts,
    required this.categories,
    required this.tags,
  });
}

class BackupDataParser {
  const BackupDataParser();

  BackupData parse(String jsonContent) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonContent);

      // Validate meta information
      if (!data.containsKey('meta') || data['meta'] is! Map) {
        throw const FormatException(
          'Invalid backup file: missing meta information',
        );
      }

      final meta = data['meta'] as Map<String, dynamic>;
      if (!meta.containsKey('version')) {
        throw const FormatException('Invalid backup file: missing version');
      }

      final version = meta['version'];
      if (version != 1) {
        throw FormatException('Unsupported backup version: $version');
      }

      // Parse entities
      final transactions = _parseList<Transaction>(
        data['transactions'],
        (json) => Transaction.fromJson(json),
        'transactions',
      );

      final accounts = _parseList<Account>(
        data['accounts'],
        (json) => Account.fromJson(json),
        'accounts',
      );

      final categories = _parseList<Category>(
        data['categories'],
        (json) => Category.fromJson(json),
        'categories',
      );

      final tags = _parseList<Tag>(
        data['tags'],
        (json) => Tag.fromJson(json),
        'tags',
      );

      return BackupData(
        transactions: transactions,
        accounts: accounts,
        categories: categories,
        tags: tags,
      );
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException('Invalid backup file format: $e');
    }
  }

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
    String fieldName,
  ) {
    if (data == null) {
      return [];
    }

    if (data is! List) {
      throw FormatException('Invalid backup file: $fieldName must be a list');
    }

    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('Invalid backup file: invalid $fieldName item');
      }
      return fromJson(item);
    }).toList();
  }
}
