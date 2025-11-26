import 'package:flutter/material.dart';
import 'package:plata_sync/core/model/object_icon_data.dart';
import 'package:plata_sync/core/ui/resources/app_icons.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/utils/colors.dart';

class ObjectIcon extends StatelessWidget {
  final ObjectIconData iconData;
  final double size;

  const ObjectIcon({
    super.key,
    required this.iconData,
    this.size = AppSizing.avatarMd,
  });

  ObjectIcon.raw({
    super.key,
    required String iconName,
    required String backgroundColorHex,
    required String iconColorHex,
    this.size = AppSizing.avatarMd,
  }) : iconData = ObjectIconData(
         iconName: iconName,
         backgroundColorHex: backgroundColorHex,
         iconColorHex: iconColorHex,
       );

  @override
  Widget build(BuildContext context) {
    final bgColor = ColorExtensions.fromHex(iconData.backgroundColorHex);
    final fgColor = ColorExtensions.fromHex(iconData.iconColorHex);
    final iconWidget = AppIcons.getIcon(
      iconData.iconName,
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
