import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String? description;
  final DateTime? lastUsed;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.description,
    this.lastUsed,
  });

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? description,
    DateTime? lastUsed,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  @override
  List<Object?> get props => [id];
}
