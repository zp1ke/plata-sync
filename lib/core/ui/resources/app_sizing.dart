import 'package:flutter/widgets.dart';

/// Semantic sizing values for consistent UI elements throughout the app.
class AppSizing {
  AppSizing._();

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 9999.0;

  // Common BorderRadius presets
  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );

  // Avatar/object icon sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;

  // Icon preview size (for detail views)
  static const double iconPreviewSize = 120.0;

  // Minimum touch target size (accessibility)
  static const double minTouchTarget = 48.0;

  // Standard box widths
  static const double boxWidthSm = 100.0;

  // Dialog constraints
  static const double dialogMaxWidth = 800.0;
  static const double dialogMaxHeight = 450.0;

  // Input widths
  static const double inputWidthMd = 250.0;

  // Font sizes following Material Design 3 type scale

  /// Display Large (57px) - Hero text, major headlines
  static const double fontSizeDisplayLarge = 57.0;

  /// Display Medium (45px) - Large headers
  static const double fontSizeDisplayMedium = 45.0;

  /// Display Small (36px) - Section headers
  static const double fontSizeDisplaySmall = 36.0;

  /// Headline Large (32px) - Page titles
  static const double fontSizeHeadlineLarge = 32.0;

  /// Headline Medium (28px) - Card titles
  static const double fontSizeHeadlineMedium = 28.0;

  /// Headline Small (24px) - List headers
  static const double fontSizeHeadlineSmall = 24.0;

  /// Title Large (22px) - App bar titles
  static const double fontSizeTitleLarge = 22.0;

  /// Title Medium (16px) - Button text, tab labels
  static const double fontSizeTitleMedium = 16.0;

  /// Title Small (14px) - List item titles
  static const double fontSizeTitleSmall = 14.0;

  /// Body Large (16px) - Prominent body text
  static const double fontSizeBodyLarge = 16.0;

  /// Body Medium (14px) - Standard body text
  static const double fontSizeBodyMedium = 14.0;

  /// Body Small (12px) - Supporting text
  static const double fontSizeBodySmall = 12.0;

  /// Label Large (14px) - Form labels
  static const double fontSizeLabelLarge = 14.0;

  /// Label Medium (12px) - Caption text
  static const double fontSizeLabelMedium = 12.0;

  /// Label Small (11px) - Small annotations
  static const double fontSizeLabelSmall = 11.0;

  // Material Design elevation levels for depth hierarchy

  /// No elevation (0dp) - For flat elements on background
  static const double elevationLevel0 = 0;

  /// Level 1 elevation (1dp) - For cards, buttons at rest
  static const double elevationLevel1 = 1;

  /// Level 2 elevation (3dp) - For raised buttons, switches
  static const double elevationLevel2 = 3;

  /// Level 3 elevation (6dp) - For floating action buttons
  static const double elevationLevel3 = 6;

  /// Level 4 elevation (8dp) - For navigation drawer, modal bottom sheets
  static const double elevationLevel4 = 8;

  /// Level 5 elevation (12dp) - For app bar, dialogs
  static const double elevationLevel5 = 12;

  // Border widths for outlines and dividers

  /// Thin border (1px) - For subtle outlines, dividers
  static const double borderWidthThin = 1.0;

  /// Medium border (2px) - For form fields, buttons
  static const double borderWidthMedium = 2.0;

  /// Thick border (4px) - For emphasis, focus states
  static const double borderWidthThick = 4.0;
}
