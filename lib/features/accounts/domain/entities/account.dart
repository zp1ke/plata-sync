import 'package:equatable/equatable.dart';
import '../../../../core/model/object_icon_data.dart';
import '../../../../core/utils/random.dart';

class Account extends Equatable {
  final String id;
  final DateTime createdAt;
  final String name;
  final ObjectIconData iconData;
  final DateTime? lastUsed;
  final String? description;
  final int balance; // Balance in cents

  const Account({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.iconData,
    required this.balance,
    this.lastUsed,
    this.description,
  });

  Account.create({
    String? id,
    DateTime? createdAt,
    required this.name,
    required this.iconData,
    this.description,
    this.balance = 0,
  }) : id = id ?? randomId(),
       createdAt = createdAt ?? DateTime.now(),
       lastUsed = null;

  Account copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    ObjectIconData? iconData,
    String? description,
    DateTime? lastUsed,
    int? balance,
  }) {
    return Account(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      description: description ?? this.description,
      lastUsed: lastUsed ?? this.lastUsed,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [id];

  /// Compares this account to another by lastUsed date, falling back to createdAt if lastUsed is null.
  /// Returns a negative integer if this account is earlier than [b],
  /// zero if they are equal, and a positive integer if this account is later than [b].
  /// If both lastUsed dates are null, compares by createdAt date.
  int compareByDateTo(Account b) {
    if (lastUsed == null && b.lastUsed == null) {
      return createdAt.compareTo(b.createdAt);
    }
    if (lastUsed == null) return -1;
    if (b.lastUsed == null) return 1;
    return lastUsed!.compareTo(b.lastUsed!);
  }
}
