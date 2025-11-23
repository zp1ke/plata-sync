import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String backgroundColorHex;
  final String iconColorHex;
  final String? description;
  final DateTime? lastUsed;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.backgroundColorHex,
    required this.iconColorHex,
    this.description,
    this.lastUsed,
  });

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? backgroundColorHex,
    String? iconColorHex,
    String? description,
    DateTime? lastUsed,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
      iconColorHex: iconColorHex ?? this.iconColorHex,
      description: description ?? this.description,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  @override
  List<Object?> get props => [id];
}
