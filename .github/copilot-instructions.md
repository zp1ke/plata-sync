# GitHub Copilot Instructions

## Project Overview
**Plata-Sync** is a personal finance management application built with **Flutter**.

## Platform Support
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Technology Stack
- **Framework**: Flutter
- **Language**: Dart
- **UI**: Material Design 3
- **Navigation**: go_router (ShellRoute for bottom navigation)
- **Localization**: flutter_localizations, intl (AppL10n)
- **State Management**: *Pending selection* (TBD)
- **Local Storage**: *Pending selection* (TBD)

## Architecture
- **Feature-first** directory structure (e.g., `lib/features/<feature_name>`)
- **Clean Architecture** principles (Data, Domain, UI layers)
- **Core Module**: Shared resources in `lib/core` (Router, Widgets, Resources)

## Key Features
- **Transactions**: Main screen for viewing/managing transactions
- **Accounts**: Manage bank accounts and balances
- **Categories**: Manage transaction categories
- **Settings**: App configuration
- **Navigation**: Bottom navigation bar with 4 tabs
- **Internationalization**: English support (expandable)

## Important Guidelines
- **Localization**: Always use `AppL10n.of(context)` for UI strings. Define keys in `lib/l10n/app_en.arb`.
- **Icons**: Use `AppIcons` class in `lib/core/ui/resources/app_icons.dart` for all app icons.
- **Navigation**: Use `AppRouter` and `AppRoutes` constants for navigation.
- **Constructors**: Prefer `const` constructors for widgets.
- **Formatting**: Use `package:intl` for currency and date formatting.
- **Style**: Follow Dart style guide and enabled lints.
- **Data Types**: Store monetary values as integers (cents).
- **Testing**: Use `flutter_test` for unit and widget tests.
