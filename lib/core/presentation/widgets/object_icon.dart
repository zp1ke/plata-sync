import 'package:flutter/material.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';

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
    this.size = 42.0,
  });

  Color _parseColor(String hexColor) {
    try {
      var hex = hexColor.toUpperCase().replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _parseColor(backgroundColorHex);
    final fgColor = _parseColor(iconColorHex);
    final iconData = AppIcons.getIcon(iconName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(iconData, color: fgColor, size: size * 0.6),
      ),
    );
  }
}
