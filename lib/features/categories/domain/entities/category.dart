import 'package:equatable/equatable.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/utils/random.dart';

class Category extends Equatable {
  final String id;
  final DateTime createdAt;
  final String name;
  final ObjectIconData iconData;
  final DateTime? lastUsed;
  final String? description;

  const Category({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.iconData,
    this.lastUsed,
    this.description,
  });

  Category.create({
    String? id,
    DateTime? createdAt,
    required this.name,
    required this.iconData,
    this.description,
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
  }) {
    return Category(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      iconData: iconData ?? this.iconData,
      description: description ?? this.description,
      lastUsed: lastUsed ?? this.lastUsed,
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
