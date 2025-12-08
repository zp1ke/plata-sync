import 'package:flutter/material.dart';

/// Light color scheme
ColorScheme lightScheme() {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0052CC),
    surfaceTint: Color(0xFF0052CC),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDEE4F9),
    onPrimaryContainer: Color(0xFF001533),
    secondary: Color(0xFF006644),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE3FCEF),
    onSecondaryContainer: Color(0xFF002114),
    tertiary: Color(0xFF004B50),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE6FCFF),
    onTertiaryContainer: Color(0xFF001F23),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF9F9F9),
    onSurface: Color(0xFF1A1C1E),
    onSurfaceVariant: Color(0xFF42474E),
    outline: Color(0xFF72777F),
    outlineVariant: Color(0xFFC2C7CF),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2F3033),
    onInverseSurface: Color(0xFFF1F0F4),
    inversePrimary: Color(0xFFB3D4FF),
    primaryFixed: Color(0xFFDEE4F9),
    onPrimaryFixed: Color(0xFF001533),
    primaryFixedDim: Color(0xFFB3D4FF),
    onPrimaryFixedVariant: Color(0xFF003E99),
    secondaryFixed: Color(0xFFE3FCEF),
    onSecondaryFixed: Color(0xFF002114),
    secondaryFixedDim: Color(0xFF79F2C0),
    onSecondaryFixedVariant: Color(0xFF005135),
    tertiaryFixed: Color(0xFFE6FCFF),
    onTertiaryFixed: Color(0xFF001F23),
    tertiaryFixedDim: Color(0xFF4FD8EB),
    onTertiaryFixedVariant: Color(0xFF003B3F),
    surfaceDim: Color(0xFFD9D9D9),
    surfaceBright: Color(0xFFF9F9F9),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF3F3F3),
    surfaceContainer: Color(0xFFEDEDED),
    surfaceContainerHigh: Color(0xFFE7E7E7),
    surfaceContainerHighest: Color(0xFFE1E1E1),
  );
}

/// Dark color scheme
ColorScheme darkScheme() {
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB3D4FF),
    surfaceTint: Color(0xFFB3D4FF),
    onPrimary: Color(0xFF002866),
    primaryContainer: Color(0xFF003E99),
    onPrimaryContainer: Color(0xFFDEE4F9),
    secondary: Color(0xFF79F2C0),
    onSecondary: Color(0xFF003824),
    secondaryContainer: Color(0xFF005135),
    onSecondaryContainer: Color(0xFFE3FCEF),
    tertiary: Color(0xFF4FD8EB),
    onTertiary: Color(0xFF00363A),
    tertiaryContainer: Color(0xFF004F53),
    onTertiaryContainer: Color(0xFFE6FCFF),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF121212), // Darker surface for better contrast
    onSurface: Color(0xFFE2E2E6),
    onSurfaceVariant: Color(0xFFC2C7CF),
    outline: Color(0xFF8C9199),
    outlineVariant: Color(0xFF42474E),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE2E2E6),
    onInverseSurface: Color(0xFF2F3033),
    inversePrimary: Color(0xFF0052CC),
    primaryFixed: Color(0xFFDEE4F9),
    onPrimaryFixed: Color(0xFF001533),
    primaryFixedDim: Color(0xFFB3D4FF),
    onPrimaryFixedVariant: Color(0xFF003E99),
    secondaryFixed: Color(0xFFE3FCEF),
    onSecondaryFixed: Color(0xFF002114),
    secondaryFixedDim: Color(0xFF79F2C0),
    onSecondaryFixedVariant: Color(0xFF005135),
    tertiaryFixed: Color(0xFFE6FCFF),
    onTertiaryFixed: Color(0xFF001F23),
    tertiaryFixedDim: Color(0xFF4FD8EB),
    onTertiaryFixedVariant: Color(0xFF003B3F),
    surfaceDim: Color(0xFF111315),
    surfaceBright: Color(0xFF37393B),
    surfaceContainerLowest: Color(0xFF0F0F0F),
    surfaceContainerLow: Color(0xFF1D1D1D), // Visible against surface
    surfaceContainer: Color(0xFF212121), // Standard dark mode card
    surfaceContainerHigh: Color(0xFF2B2B2B),
    surfaceContainerHighest: Color(0xFF333333),
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

  /// Color for warning states
  Color get warning => brightness == Brightness.light
      ? const Color(0xFFF9A825) // Dark yellow for light theme
      : const Color(0xFFBDAB07); // Light yellow for dark theme
}
