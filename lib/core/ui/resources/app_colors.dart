import 'package:flutter/material.dart';

/// Light color scheme
ColorScheme lightScheme() {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2a631e),
    surfaceTint: Color(0xFF2a631e),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF7ab36e),
    onPrimaryContainer: Color(0xFF023b00),
    secondary: Color(0xFF86957d),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFFd6e5cd),
    onSecondaryContainer: Color(0xFF5e6d55),
    tertiary: Color(0xFF6b989b),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFFbbe8eb),
    onTertiaryContainer: Color(0xFF437073),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFF164f0a),
    primaryFixed: Color(0xFF7ab36e),
    onPrimaryFixed: Color(0xFF002700),
    primaryFixedDim: Color(0xFF669f5a),
    onPrimaryFixedVariant: Color(0xFF164f0a),
    secondaryFixed: Color(0xFFd6e5cd),
    onSecondaryFixed: Color(0xFF4a5941),
    secondaryFixedDim: Color(0xFFc2d1b9),
    onSecondaryFixedVariant: Color(0xFF728169),
    tertiaryFixed: Color(0xFFbbe8eb),
    onTertiaryFixed: Color(0xFF2f5c5f),
    tertiaryFixedDim: Color(0xFFa7d4d7),
    onTertiaryFixedVariant: Color(0xFF578487),
    surfaceDim: Color(0xFFE6E0E9),
    surfaceBright: Color(0xFFFFFBFE),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF7F2FA),
    surfaceContainer: Color(0xFFF3EDF7),
    surfaceContainerHigh: Color(0xFFECE6F0),
    surfaceContainerHighest: Color(0xFFE6E0E9),
  );
}

/// Dark color scheme
ColorScheme darkScheme() {
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF164f0a),
    surfaceTint: Color(0xFF164f0a),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF002700),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFF728169),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF4a5941),
    onSecondaryContainer: Color(0xFFFFFFFF),
    tertiary: Color(0xFF578487),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF2f5c5f),
    onTertiaryContainer: Color(0xFFFFFFFF),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF000000),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFFFFF),
    surface: Color(0xFF10090D),
    onSurface: Color(0xFFE6E0E9),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E0E9),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF2a631e),
    primaryFixed: Color(0xFF7ab36e),
    onPrimaryFixed: Color(0xFF002700),
    primaryFixedDim: Color(0xFF669f5a),
    onPrimaryFixedVariant: Color(0xFF164f0a),
    secondaryFixed: Color(0xFFd6e5cd),
    onSecondaryFixed: Color(0xFF4a5941),
    secondaryFixedDim: Color(0xFFc2d1b9),
    onSecondaryFixedVariant: Color(0xFF728169),
    tertiaryFixed: Color(0xFFbbe8eb),
    onTertiaryFixed: Color(0xFF2f5c5f),
    tertiaryFixedDim: Color(0xFFa7d4d7),
    onTertiaryFixedVariant: Color(0xFF578487),
    surfaceDim: Color(0xFF10090D),
    surfaceBright: Color(0xFF362F33),
    surfaceContainerLowest: Color(0xff000000),
    surfaceContainerLow: Color(0xFF1D1418),
    surfaceContainer: Color(0xFF211A1E),
    surfaceContainerHigh: Color(0xFF2B2329),
    surfaceContainerHighest: Color(0xFF362F33),
  );
}

/// Extension to add custom colors to ColorScheme
extension TransactionColors on ColorScheme {
  /// Color for expense transactions (negative amounts)
  Color get expense => error;

  /// Color for income transactions (positive amounts)
  Color get income => brightness == Brightness.light
      ? const Color(0xFF2E7D32) // Dark green for light theme
      : const Color(0xFF66BB6A); // Light green for dark theme

  /// Color for transfer transactions
  Color get transfer => brightness == Brightness.light
      ? const Color(0xFF1976D2) // Dark blue for light theme
      : const Color(0xFF64B5F6); // Light blue for dark theme
}
