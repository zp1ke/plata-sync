import 'package:flex_color_scheme/flex_color_scheme.dart';

/// AppTheme provides light and dark theme data using FlexColorScheme.
/// https://rydmike.com/flexcolorscheme/themesplayground-latest/
class AppTheme {
  static final light = FlexThemeData.light(
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
  );

  static final dark = FlexThemeData.dark(
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
  );
}
