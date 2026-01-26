import 'package:equatable/equatable.dart';
import '../../../../core/utils/random.dart';

class Transaction extends Equatable {
  final String id;
  final DateTime createdAt;
  final String accountId;
  final String? categoryId;
  final int amount;
  final int accountBalanceBefore;
  final String? targetAccountId;
  final int? targetAccountBalanceBefore;
  final String? notes;
  final List<String> tagIds;

  const Transaction({
    required this.id,
    required this.createdAt,
    required this.accountId,
    required this.amount,
    required this.accountBalanceBefore,
    this.categoryId,
    this.targetAccountId,
    this.targetAccountBalanceBefore,
    this.notes,
    this.tagIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'account_id': accountId,
      'category_id': categoryId,
      'amount': amount,
      'account_balance_before': accountBalanceBefore,
      'target_account_id': targetAccountId,
      'target_account_balance_before': targetAccountBalanceBefore,
      'notes': notes,
      'tag_ids': tagIds,
    };
  }

  Transaction.create({
    String? id,
    DateTime? createdAt,
    required this.accountId,
    required this.amount,
    required this.accountBalanceBefore,
    this.categoryId,
    this.targetAccountId,
    this.targetAccountBalanceBefore,
    this.notes,
    this.tagIds = const [],
  }) : id = id ?? randomId(),
       createdAt = createdAt ?? DateTime.now();

  Transaction copyWith({
    String? id,
    DateTime? createdAt,
    String? accountId,
    String? categoryId,
    int? amount,
    int? accountBalanceBefore,
    String? targetAccountId,
    int? targetAccountBalanceBefore,
    String? notes,
    List<String>? tagIds,
  }) {
    return Transaction(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      accountBalanceBefore: accountBalanceBefore ?? this.accountBalanceBefore,
      targetAccountId: targetAccountId ?? this.targetAccountId,
      targetAccountBalanceBefore:
          targetAccountBalanceBefore ?? this.targetAccountBalanceBefore,
      notes: notes ?? this.notes,
      tagIds: tagIds ?? this.tagIds,
    );
  }

  @override
  List<Object?> get props => [id];

  /// Returns true if this is a transfer transaction (has a target account)
  bool get isTransfer => targetAccountId != null;

  /// Returns true if this is an expense (negative amount and not a transfer)
  bool get isExpense => amount < 0 && !isTransfer;

  /// Returns true if this is an income (positive amount and not a transfer)
  bool get isIncome => amount > 0 && !isTransfer;

  /// Calculates the account balance after this transaction
  int get accountBalanceAfter => accountBalanceBefore + amount;

  /// Calculates the target account balance after this transaction (for transfers)
  int? get targetAccountBalanceAfter {
    if (targetAccountBalanceBefore == null) return null;
    return targetAccountBalanceBefore! - amount;
  }

  int get effectiveAmount => isTransfer ? amount.abs() : amount;
}
