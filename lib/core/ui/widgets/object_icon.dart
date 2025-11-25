import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/utils/color_extensions.dart';

class ObjectIcon extends StatelessWidget {
  final String iconName;
  final String backgroundColorHex;
  final String iconColorHex;
  final double size;

  const ObjectIcon({
    super.key,
    required this.iconName,
    required this.backgroundColorHex,
    required this.iconColorHex,
    this.size = AppSizing.avatarMd,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = ColorExtensions.fromHex(backgroundColorHex);
    final fgColor = ColorExtensions.fromHex(iconColorHex);
    final iconWidget = AppIcons.getIcon(
      iconName,
      color: fgColor,
      size: size * 0.6,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(child: iconWidget),
    );
  }
}
