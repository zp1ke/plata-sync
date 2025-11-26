import 'package:equatable/equatable.dart';

/// Holds the properties needed to display an ObjectIcon
class ObjectIconData extends Equatable {
  final String iconName;
  final String backgroundColorHex;
  final String iconColorHex;

  const ObjectIconData({
    required this.iconName,
    required this.backgroundColorHex,
    required this.iconColorHex,
  });

  ObjectIconData copyWith({
    String? iconName,
    String? backgroundColorHex,
    String? iconColorHex,
  }) {
    return ObjectIconData(
      iconName: iconName ?? this.iconName,
      backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
      iconColorHex: iconColorHex ?? this.iconColorHex,
    );
  }

  @override
  List<Object?> get props => [iconName, backgroundColorHex, iconColorHex];
}
