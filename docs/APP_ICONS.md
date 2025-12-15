# App Icons Generation Summary

## Overview
Platform-specific app icons have been successfully generated for **Plata Sync** using the inline SVG files.

## Source Files
- **Light Theme**: `assets/icons/app_icon_light_inline.svg` → `app_icon_light_inline.png` (1024x1024)
- **Dark Theme**: `assets/icons/app_icon_dark_inline.svg` → `app_icon_dark_inline.png` (1024x1024)

The inline SVG files have CSS colors hardcoded (no CSS variables) for full compatibility with `flutter_svg`.

## Generated Icons by Platform

### ✅ Android
**Location**: `android/app/src/main/res/`

#### Standard Icons (5 files)
- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)

#### Adaptive Icons (Android 8.0+)
- Foreground images in `drawable-*` folders (5 densities)
- Configuration: `mipmap-anydpi-v26/ic_launcher.xml`
- Background color: `#ffffff` (white) in `values/colors.xml`

### ✅ iOS
**Location**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

**21 icon files** covering all required sizes:
- iPhone: 20pt, 29pt, 40pt, 60pt (2x and 3x)
- iPad: 20pt, 29pt, 40pt, 76pt (1x and 2x)
- App Store: 1024pt (1x)

### ✅ Web
**Location**: `web/icons/`

**4 files**:
- `Icon-192.png` - Standard PWA icon
- `Icon-512.png` - Large PWA icon
- `Icon-maskable-192.png` - Maskable icon for adaptive display
- `Icon-maskable-512.png` - Large maskable icon

### ✅ macOS
**Location**: `macos/Runner/Assets.xcassets/AppIcon.appiconset/`

**7 files**:
- `app_icon_16.png`
- `app_icon_32.png`
- `app_icon_64.png`
- `app_icon_128.png`
- `app_icon_256.png`
- `app_icon_512.png`
- `app_icon_1024.png`

### ✅ Windows
**Location**: `windows/runner/resources/`

**1 file**:
- `app_icon.ico` (48x48)

### ⚠️ Linux
Linux icon generation is included in the configuration but may require manual setup depending on the distribution packaging method.

## Configuration

The icon generation is configured in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
    image_path: "assets/icons/app_icon_light_inline.png"
    background_color: "#ffffff"
  windows:
    generate: true
    image_path: "assets/icons/app_icon_light_inline.png"
    icon_size: 48
  macos:
    generate: true
    image_path: "assets/icons/app_icon_light_inline.png"
  linux:
    generate: true
    image_path: "assets/icons/app_icon_light_inline.png"
  image_path: "assets/icons/app_icon_light_inline.png"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/icons/app_icon_light_inline.png"
  remove_alpha_ios: true
```

## Regenerating Icons

To regenerate icons after making changes to the source SVG files:

1. Update the SVG files in `assets/icons/`
2. Convert SVG to PNG (if using a tool like sharp/ImageMagick)
3. Run: `dart run flutter_launcher_icons`

## Notes

- The light theme icon is used for all platforms
- The dark theme icon (`app_icon_dark_inline.png`) is available but not currently used in platform icons
- Android adaptive icons use a white background (#ffffff)
- iOS icons have alpha channel removed (`remove_alpha_ios: true`)
- PNG files at 1024x1024 resolution are included in `assets/icons/` for icon generation

## Package Used

- **flutter_launcher_icons**: ^0.14.2 (dev dependency)

