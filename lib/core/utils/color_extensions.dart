import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Converts a hex color string to a Color.
  ///
  /// Supports formats:
  /// - `#RRGGBB`
  /// - `RRGGBB`
  /// - `#AARRGGBB`
  /// - `AARRGGBB`
  ///
  /// Returns [Colors.grey] if the string is invalid.
  static Color fromHex(String hexColor) {
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
}
