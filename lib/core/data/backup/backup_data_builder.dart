import 'dart:convert';

import '../../../features/accounts/domain/entities/account.dart';
import '../../../features/categories/domain/entities/category.dart';
import '../../../features/tags/domain/entities/tag.dart';
import '../../../features/transactions/domain/entities/transaction.dart';

class BackupDataBuilder {
  const BackupDataBuilder();

  String build({
    required List<Transaction> transactions,
    required List<Account> accounts,
    required List<Category> categories,
    required List<Tag> tags,
  }) {
    final data = {
      'meta': {'version': 1, 'created_at': DateTime.now().toIso8601String()},
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'accounts': accounts.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'tags': tags.map((e) => e.toJson()).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }
}
