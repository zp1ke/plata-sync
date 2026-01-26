import 'package:equatable/equatable.dart';
import '../../../../core/model/object_icon_data.dart';
import '../../../../core/utils/random.dart';
import '../../model/enums/category_transaction_type.dart';

class Category extends Equatable {
  final String id;
  final DateTime createdAt;
  final String name;
  final ObjectIconData iconData;
  final DateTime? lastUsed;
  final String? description;
  final CategoryTransactionType? transactionType;
  final bool enabled; // Whether the category is enabled (defaults to true)

  const Category({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.iconData,
    this.lastUsed,
    this.description,
    this.transactionType,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'icon_data': iconData.toJson(),
      'last_used': lastUsed?.toIso8601String(),
      'description': description,
      'transaction_type': transactionType?.name,
      'enabled': enabled,
    };
  }

  Category.create({
    String? id,
    DateTime? createdAt,
    required this.name,
    required this.iconData,
    this.description,
    this.transactionType,
    this.enabled = true,
  }) : id = id ?? randomId(),
       createdAt = createdAt ?? DateTime.now(),
       lastUsed = null;

  Category copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    ObjectIconData? iconData,
    String? description,
    DateTime? lastUsed,
    CategoryTransactionType? transactionType,
    bool? enabled,
  }) {
    return Category(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      description: description ?? this.description,
      lastUsed: lastUsed ?? this.lastUsed,
      transactionType: transactionType ?? this.transactionType,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object?> get props => [id];

  /// Compares this category to another by lastUsed date, falling back to createdAt if lastUsed is null.
  /// Returns a negative integer if this category is earlier than [b],
  /// zero if they are equal, and a positive integer if this category is later than [b].
  /// If both lastUsed dates are null, compares by createdAt date.
  int compareByDateTo(Category b) {
    if (lastUsed == null && b.lastUsed == null) {
      return createdAt.compareTo(b.createdAt);
    }
    if (lastUsed == null) return -1;
    if (b.lastUsed == null) return 1;
    return lastUsed!.compareTo(b.lastUsed!);
  }
}
