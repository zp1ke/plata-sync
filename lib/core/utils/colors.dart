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
      } else if (hex.length != 8) {
        return Colors.grey;
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  /// Converts a Color to a hex color string.
  ///
  /// Returns a string in the format `#AARRGGBB`.
  String toHex() {
    final a = (this.a * 255).round().toRadixString(16).padLeft(2, '0');
    final r = (this.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (this.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (this.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$a$r$g$b'.toUpperCase();
  }

  /// Validates if a string is a valid hex color.
  ///
  /// Supports formats:
  /// - `#RRGGBB`
  /// - `RRGGBB`
  /// - `#AARRGGBB`
  /// - `AARRGGBB`
  ///
  /// Returns `true` if valid, `false` otherwise.
  static bool isValidHex(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex) ||
        RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(hex);
  }
}
