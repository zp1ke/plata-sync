import 'package:equatable/equatable.dart';

/// Tag entity for categorizing transactions
class Tag extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime lastUsedAt;

  const Tag({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastUsedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'last_used_at': lastUsedAt.toIso8601String(),
    };
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUsedAt: DateTime.parse(json['last_used_at'] as String),
    );
  }

  factory Tag.create({
    required String id,
    required String name,
    DateTime? createdAt,
  }) {
    final now = DateTime.now();
    return Tag(
      id: id,
      name: name,
      createdAt: createdAt ?? now,
      lastUsedAt: now,
    );
  }

  Tag copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, lastUsedAt];
}
