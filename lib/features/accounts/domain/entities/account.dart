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
  final bool enabled; // Whether the account is enabled (defaults to true)
  final bool
  supportsEffectiveDate; // Whether the account supports effective dates for transactions
  final bool
  supportsInstallments; // Whether the account supports installment payments

  const Account({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.iconData,
    required this.balance,
    this.lastUsed,
    this.description,
    this.enabled = true,
    this.supportsEffectiveDate = false,
    this.supportsInstallments = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'icon_data': iconData.toJson(),
      'last_used': lastUsed?.toIso8601String(),
      'description': description,
      'balance': balance,
      'enabled': enabled,
      'supports_effective_date': supportsEffectiveDate,
      'supports_installments': supportsInstallments,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      name: json['name'] as String,
      iconData: ObjectIconData.fromJson(
        json['icon_data'] as Map<String, dynamic>,
      ),
      lastUsed: json['last_used'] != null
          ? DateTime.parse(json['last_used'] as String)
          : null,
      description: json['description'] as String?,
      balance: json['balance'] as int,
      enabled: json['enabled'] as bool? ?? true,
      supportsEffectiveDate: json['supports_effective_date'] as bool? ?? false,
      supportsInstallments: json['supports_installments'] as bool? ?? false,
    );
  }

  Account.create({
    String? id,
    DateTime? createdAt,
    required this.name,
    required this.iconData,
    this.description,
    this.balance = 0,
    this.enabled = true,
    this.supportsEffectiveDate = false,
    this.supportsInstallments = false,
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
    bool? enabled,
    bool? supportsEffectiveDate,
    bool? supportsInstallments,
  }) {
    return Account(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      description: description ?? this.description,
      lastUsed: lastUsed ?? this.lastUsed,
      balance: balance ?? this.balance,
      enabled: enabled ?? this.enabled,
      supportsEffectiveDate:
          supportsEffectiveDate ?? this.supportsEffectiveDate,
      supportsInstallments: supportsInstallments ?? this.supportsInstallments,
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
