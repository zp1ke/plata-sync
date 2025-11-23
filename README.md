# Plata-Sync

A personal finance management application built with Flutter.

## Features

- 💰 **Account Management**: Create, edit, and delete accounts with balance tracking
- 📊 **Transaction Management**: Track income, expenses, and transfers between accounts
- 🏷️ **Categories**: Organize transactions with customizable categories and icons
- 🔍 **Filtering & Sorting**: Search by name, filter by date range, and sort by various criteria
- 📱 **Responsive Design**: Optimized for both mobile and desktop layouts
- 🌙 **Dark Mode**: Full dark mode support with Material 3 design
- 🖥️ **Multi-Platform**: Runs on Android, iOS, Web, Windows, macOS, and Linux

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **UI**: Material Design 3

## Development

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / Xcode (for mobile development)
- VS Code (recommended)

### Development Script

Use the provided dev script for common development tasks:

```shell
./.bin/dev <command> [options]
```

Available commands:

- `clean` - Clean build artifacts
- `deps [cmd]` - Manage dependencies (`get`, `outdated`, `upgrade`)
- `test` - Run tests
- `run [args]` - Run application (passes args to `flutter run`)
- `build <platform>` - Build application (apk, ios, web, etc.)
- `version [type]` - Display or bump version (major, minor, patch)
- `help` - Show help message

### Examples

**Run on Linux:**
```shell
./.bin/dev run -d linux
```

**Build for Web:**
```shell
./.bin/dev build web
```

**Bump Patch Version:**
```shell
./.bin/dev version patch
```

**Check Outdated Dependencies:**
```shell
./.bin/dev deps outdated
```
