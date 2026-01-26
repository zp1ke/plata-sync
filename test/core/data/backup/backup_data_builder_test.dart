import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:plata_sync/core/data/backup/backup_data_builder.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/features/accounts/domain/entities/account.dart';
import 'package:plata_sync/features/categories/domain/entities/category.dart';
import 'package:plata_sync/features/tags/domain/entities/tag.dart';
import 'package:plata_sync/features/transactions/domain/entities/transaction.dart';

void main() {
  group('BackupDataBuilder', () {
    test('builds valid JSON from empty lists', () {
      const builder = BackupDataBuilder();
      final result = builder.build(
        transactions: [],
        accounts: [],
        categories: [],
        tags: [],
      );

      final json = jsonDecode(result) as Map<String, dynamic>;
      expect(json['meta'], isA<Map>());
      expect((json['meta'] as Map)['version'], 1);
      expect(json['transactions'], isEmpty);
      expect(json['accounts'], isEmpty);
      expect(json['categories'], isEmpty);
      expect(json['tags'], isEmpty);
    });

    test('builds valid JSON with data', () {
      final now = DateTime.now();

      final accounts = [
        Account(
          id: 'acc1',
          createdAt: now,
          name: 'Bank',
          iconData: const ObjectIconData.empty(),
          balance: 1000,
        ),
      ];

      final categories = [
        Category(
          id: 'cat1',
          createdAt: now,
          name: 'Food',
          iconData: const ObjectIconData.empty(),
        ),
      ];

      final tags = [
        Tag(id: 'tag1', name: 'lunch', createdAt: now, lastUsedAt: now),
      ];

      final transactions = [
        Transaction(
          id: 'tx1',
          createdAt: now,
          accountId: 'acc1',
          categoryId: 'cat1',
          amount: -500,
          accountBalanceBefore: 1000,
          tagIds: const ['tag1'],
        ),
      ];

      const builder = BackupDataBuilder();
      final result = builder.build(
        transactions: transactions,
        accounts: accounts,
        categories: categories,
        tags: tags,
      );

      final json = jsonDecode(result) as Map<String, dynamic>;

      expect((json['accounts'] as List).length, 1);
      expect((json['accounts'] as List)[0]['id'], 'acc1');

      expect((json['categories'] as List).length, 1);
      expect((json['categories'] as List)[0]['id'], 'cat1');

      expect((json['tags'] as List).length, 1);
      expect((json['tags'] as List)[0]['id'], 'tag1');

      expect((json['transactions'] as List).length, 1);
      expect((json['transactions'] as List)[0]['id'], 'tx1');
      expect((json['transactions'] as List)[0]['tag_ids'], ['tag1']);
    });
  });
}
