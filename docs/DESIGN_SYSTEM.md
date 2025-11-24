# Design System - Spacing and Sizing Guide

This document provides an overview of the semantic spacing and sizing values used throughout the Plata-Sync application.

## AppSpacing

Semantic spacing values for consistent UI spacing throughout the app. Based on a scale of multiples of 4 for harmonious spacing.

### Base Values
- `none` = 0
- `xs` = 4px (extra small)
- `sm` = 8px (small)
- `md` = 12px (medium)
- `lg` = 16px (large)
- `xl` = 20px (extra large)
- `xxl` = 24px (double extra large)
- `xxxl` = 32px (triple extra large)

### Common EdgeInsets Presets
- `paddingXs`, `paddingSm`, `paddingMd`, `paddingLg`, `paddingXl`, `paddingXxl`
- `paddingHorizontalXs` through `paddingHorizontalXl`
- `paddingVerticalXs` through `paddingVerticalXl`

### Common SizedBox Gaps
- `gapXs`, `gapSm`, `gapMd`, `gapLg`, `gapXl` (works for both width and height)
- `gapHorizontalXs` through `gapHorizontalXl` (width only)
- `gapVerticalXs` through `gapVerticalXl` (height only)

### Usage Examples
```dart
// Padding
Padding(padding: AppSpacing.paddingMd)
Padding(padding: AppSpacing.paddingHorizontalLg)

// Gaps between widgets
AppSpacing.gapHorizontalSm  // Instead of SizedBox(width: 8)
AppSpacing.gapVerticalMd     // Instead of SizedBox(height: 12)
```

## AppSizing

Semantic sizing values for consistent UI elements throughout the app.

### Icon Sizes
- `iconXs` = 16px
- `iconSm` = 20px
- `iconMd` = 24px
- `iconLg` = 32px
- `iconXl` = 48px

### Border Radius
- `radiusXs` = 4px
- `radiusSm` = 8px
- `radiusMd` = 12px
- `radiusLg` = 16px
- `radiusXl` = 24px
- `radiusFull` = 9999px (fully rounded)

### BorderRadius Presets
- `borderRadiusXs` through `borderRadiusXl`
- `borderRadiusFull`

### Avatar/Object Icon Sizes
- `avatarSm` = 32px
- `avatarMd` = 40px (default for ObjectIcon)
- `avatarLg` = 48px
- `avatarXl` = 64px

### Other
- `minTouchTarget` = 48px (accessibility minimum)
- `gridSpacingSm` = 8px
- `gridSpacingMd` = 12px
- `gridSpacingLg` = 16px

### Usage Examples
```dart
// Icons
Icon(Icons.search, size: AppSizing.iconSm)

// Border radius
BorderRadius: AppSizing.borderRadiusMd
borderRadius: AppSizing.borderRadiusSm

// Grid spacing
SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisSpacing: AppSpacing.sm,
  mainAxisSpacing: AppSpacing.sm,
)
```

## Migration Summary

All hardcoded spacing and sizing values have been replaced with semantic constants in the following files:

### Core Widgets
- ✅ `app_top_bar.dart`
- ✅ `sort_selector.dart`
- ✅ `view_toggle.dart`
- ✅ `object_icon.dart`

### Feature Screens
- ✅ `categories_screen.dart`

## Benefits

1. **Consistency**: All UI elements use the same spacing scale
2. **Maintainability**: Change spacing/sizing in one place
3. **Semantic Meaning**: Values have clear intent (sm, md, lg)
4. **Accessibility**: Includes minimum touch target sizes
5. **Design System**: Foundation for future UI development
6. **Type Safety**: Compile-time checking of values

## Guidelines

1. **Always use semantic values** instead of hardcoded numbers
2. **Use the 4px base scale** for all spacing (4, 8, 12, 16, 20, 24, 32)
3. **Use predefined gaps** instead of creating new SizedBox widgets
4. **Use predefined padding** instead of hardcoded EdgeInsets
5. **Choose appropriate semantic names** (xs, sm, md, lg, xl)

