import 'package:flutter/material.dart';
import 'package:plata_sync/core/ui/resources/app_colors.dart';
import 'package:plata_sync/core/ui/resources/app_sizing.dart';
import 'package:plata_sync/core/ui/resources/app_spacing.dart';

/// Light theme configuration
ThemeData get lightTheme => _theme(lightScheme());

/// Dark theme configuration
ThemeData get darkTheme => _theme(darkScheme());

ThemeData _theme(ColorScheme colorScheme) => ThemeData(
  useMaterial3: true,
  brightness: colorScheme.brightness,
  colorScheme: colorScheme,
  textTheme: _textTheme,
  appBarTheme: colorScheme.brightness == Brightness.light
      ? _lightAppBarTheme
      : _darkAppBarTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  textButtonTheme: _textButtonTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
  inputDecorationTheme: _inputDecorationTheme(colorScheme),
  cardTheme: _cardTheme,
  chipTheme: _chipTheme,
  progressIndicatorTheme: _progressIndicatorTheme,
  dividerTheme: _dividerTheme,
  bottomNavigationBarTheme: _bottomNavigationBarTheme,
  tabBarTheme: _tabBarTheme,
  switchTheme: _switchTheme,
  checkboxTheme: _checkboxTheme,
  radioTheme: _radioTheme,
  sliderTheme: _sliderTheme,
  scaffoldBackgroundColor: colorScheme.surface,
  canvasColor: colorScheme.surface,
  dialogTheme: _dialogTheme,
);

const TextTheme _textTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: AppSizing.fontSizeDisplayLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.1228070175438596,
  ),
  displayMedium: TextStyle(
    fontSize: AppSizing.fontSizeDisplayMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.1555555555555554,
  ),
  displaySmall: TextStyle(
    fontSize: AppSizing.fontSizeDisplaySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.2222222222222223,
  ),
  headlineLarge: TextStyle(
    fontSize: AppSizing.fontSizeHeadlineLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  ),
  headlineMedium: TextStyle(
    fontSize: AppSizing.fontSizeHeadlineMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.2857142857142858,
  ),
  headlineSmall: TextStyle(
    fontSize: AppSizing.fontSizeHeadlineSmall,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.3333333333333333,
  ),
  titleLarge: TextStyle(
    fontSize: AppSizing.fontSizeTitleLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.2727272727272727,
  ),
  titleMedium: TextStyle(
    fontSize: AppSizing.fontSizeTitleMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
  ),
  titleSmall: TextStyle(
    fontSize: AppSizing.fontSizeTitleSmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4285714285714286,
  ),
  labelLarge: TextStyle(
    fontSize: AppSizing.fontSizeLabelLarge,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4285714285714286,
  ),
  labelMedium: TextStyle(
    fontSize: AppSizing.fontSizeLabelMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3333333333333333,
  ),
  labelSmall: TextStyle(
    fontSize: AppSizing.fontSizeLabelSmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4545454545454546,
  ),
  bodyLarge: TextStyle(
    fontSize: AppSizing.fontSizeBodyLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
  ),
  bodyMedium: TextStyle(
    fontSize: AppSizing.fontSizeBodyMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.4285714285714286,
  ),
  bodySmall: TextStyle(
    fontSize: AppSizing.fontSizeBodySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.3333333333333333,
  ),
);

/// Elevated button theme
final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: AppSizing.elevationLevel2,
    padding: AppSpacing.paddingLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizing.radiusMd),
    ),
  ),
);

/// Text button theme
final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    padding: AppSpacing.paddingLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizing.radiusMd),
    ),
  ),
);

/// Outlined button theme
final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: AppSpacing.paddingLg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizing.radiusMd),
    ),
  ),
);

/// Input decoration theme
InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) =>
    InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizing.radiusMd),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizing.radiusMd),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizing.radiusMd),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: AppSizing.borderWidthMedium,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizing.radiusMd),
        borderSide: BorderSide(color: colorScheme.error),
      ),
    );

/// App bar theme for light mode
const AppBarTheme _lightAppBarTheme = AppBarTheme(
  elevation: AppSizing.elevationLevel1,
  centerTitle: false,
  titleSpacing: AppSpacing.md,
  scrolledUnderElevation: AppSizing.elevationLevel1,
);

/// App bar theme for dark mode
const AppBarTheme _darkAppBarTheme = AppBarTheme(
  elevation: AppSizing.elevationLevel1,
  centerTitle: false,
  titleSpacing: AppSpacing.md,
  scrolledUnderElevation: AppSizing.elevationLevel1,
);

/// Card theme
final CardThemeData _cardTheme = CardThemeData(
  elevation: AppSizing.elevationLevel1,
  margin: EdgeInsets.all(AppSpacing.sm),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSizing.radiusLg),
  ),
);

/// Chip theme
final ChipThemeData _chipTheme = ChipThemeData(
  padding: EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSizing.radiusFull),
  ),
);

/// Progress indicator theme
const ProgressIndicatorThemeData _progressIndicatorTheme =
    ProgressIndicatorThemeData();

/// Divider theme
const DividerThemeData _dividerTheme = DividerThemeData(
  thickness: AppSizing.borderWidthThin,
  space: AppSpacing.md,
);

/// Bottom navigation bar theme
const BottomNavigationBarThemeData _bottomNavigationBarTheme =
    BottomNavigationBarThemeData(type: BottomNavigationBarType.fixed);

/// Tab bar theme
const TabBarThemeData _tabBarTheme = TabBarThemeData(
  labelPadding: EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  ),
);

/// Switch theme
final SwitchThemeData _switchTheme = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return lightScheme().primary;
    }
    return null;
  }),
);

/// Checkbox theme
final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSizing.radiusXs),
  ),
);

/// Radio theme
const RadioThemeData _radioTheme = RadioThemeData();

/// Slider theme
const SliderThemeData _sliderTheme = SliderThemeData();

/// Dialog theme
const _dialogTheme = DialogThemeData(
  insetPadding: EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.xxl,
  ),
);
