import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:plata_sync/core/utils/colors.dart';

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
