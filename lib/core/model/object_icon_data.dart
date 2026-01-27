import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import '../utils/colors.dart';

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

  const ObjectIconData.empty()
    : iconName = 'help_outline',
      backgroundColorHex = '#E0E0E0',
      iconColorHex = '#9E9E9E';

  Map<String, dynamic> toJson() {
    return {
      'icon_name': iconName,
      'background_color_hex': backgroundColorHex,
      'icon_color_hex': iconColorHex,
    };
  }

  factory ObjectIconData.fromJson(Map<String, dynamic> json) {
    return ObjectIconData(
      iconName: json['icon_name'] as String,
      backgroundColorHex: json['background_color_hex'] as String,
      iconColorHex: json['icon_color_hex'] as String,
    );
  }

  ObjectIconData.fromColors({
    required this.iconName,
    required Color backgroundColorHex,
    required Color iconColorHex,
  }) : backgroundColorHex = backgroundColorHex.toHex(),
       iconColorHex = iconColorHex.toHex();

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
