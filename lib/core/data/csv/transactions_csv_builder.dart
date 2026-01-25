import '../../../features/accounts/domain/entities/account.dart';
import '../../../features/categories/domain/entities/category.dart';
import '../../../features/tags/domain/entities/tag.dart';
import '../../../features/transactions/domain/entities/transaction.dart';
import 'csv_encoder.dart';

class TransactionsCsvBuilder {
  const TransactionsCsvBuilder();

  String build({
    required List<Transaction> transactions,
    required List<Account> accounts,
    required List<Category> categories,
    required List<Tag> tags,
  }) {
    final accountNames = {
      for (final account in accounts) account.id: account.name,
    };
    final categoryNames = {
      for (final category in categories) category.id: category.name,
    };
    final tagNames = {for (final tag in tags) tag.id: tag.name};

    final sortedTransactions = [...transactions]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final rows = <List<String>>[
      [
        'id',
        'created_at',
        'type',
        'amount_cents',
        'amount',
        'account_id',
        'account_name',
        'account_balance_before_cents',
        'account_balance_after_cents',
        'category_id',
        'category_name',
        'target_account_id',
        'target_account_name',
        'target_account_balance_before_cents',
        'target_account_balance_after_cents',
        'notes',
        'tag_ids',
        'tag_names',
      ],
    ];

    for (final transaction in sortedTransactions) {
      final type = transaction.isTransfer
          ? 'transfer'
          : (transaction.isExpense ? 'expense' : 'income');
      final tagIds = transaction.tagIds;
      final tagNameList = tagIds
          .map((id) => tagNames[id] ?? id)
          .where((name) => name.isNotEmpty)
          .toList();

      rows.add([
        transaction.id,
        transaction.createdAt.toIso8601String(),
        type,
        transaction.amount.toString(),
        (transaction.amount / 100).toStringAsFixed(2),
        transaction.accountId,
        accountNames[transaction.accountId] ?? transaction.accountId,
        transaction.accountBalanceBefore.toString(),
        transaction.accountBalanceAfter.toString(),
        transaction.categoryId ?? '',
        transaction.categoryId == null
            ? ''
            : (categoryNames[transaction.categoryId] ??
                  transaction.categoryId!),
        transaction.targetAccountId ?? '',
        transaction.targetAccountId == null
            ? ''
            : (accountNames[transaction.targetAccountId] ??
                  transaction.targetAccountId!),
        transaction.targetAccountBalanceBefore?.toString() ?? '',
        transaction.targetAccountBalanceAfter?.toString() ?? '',
        transaction.notes ?? '',
        tagIds.join('|'),
        tagNameList.join('|'),
      ]);
    }

    return const CsvEncoder().encode(rows);
  }
}
