import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';

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

/// AppTheme provides light and dark theme data using FlexColorScheme.
/// https://rydmike.com/flexcolorscheme/themesplayground-latest/
class AppTheme {
  static final light =
      FlexThemeData.light(
        useMaterial3: true,
        scheme: FlexScheme.tealM3,
        useMaterial3ErrorColors: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
        blendLevel: 1,
        subThemesData: const FlexSubThemesData(
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorIsFilled: true,
          inputDecoratorBackgroundAlpha: 19,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorFocusedBorderWidth: 1.0,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        ),
      ).copyWith(
        dialogTheme: const DialogThemeData(
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxl,
          ),
        ),
        dividerTheme: const DividerThemeData(thickness: 1, space: 1),
      );

  static final dark =
      FlexThemeData.dark(
        useMaterial3: true,
        scheme: FlexScheme.tealM3,
        useMaterial3ErrorColors: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
        blendLevel: 2,
        subThemesData: const FlexSubThemesData(
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorIsFilled: true,
          inputDecoratorBackgroundAlpha: 22,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorFocusedBorderWidth: 1.0,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        ),
      ).copyWith(
        dialogTheme: const DialogThemeData(
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xxl,
          ),
        ),
        dividerTheme: const DividerThemeData(thickness: 1, space: 1),
      );
}
