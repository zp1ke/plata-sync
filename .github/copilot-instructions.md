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
- **State Management**: *Pending selection* (TBD)
- **Local Storage**: *Pending selection* (TBD)

## Architecture
- **Feature-first** directory structure (e.g., `lib/features/<feature_name>`)
- **Clean Architecture** principles (Data, Domain, Presentation layers)

## Key Features
- Account management with balance tracking
- Transaction management (Income, Expense, Transfer)
- Category management with icons
- Settings screen
- Dark/Light mode support
- Search and Filtering
- Responsive design for Desktop and Mobile

## Important Guidelines
- Prefer `const` constructors for widgets to improve performance.
- Use `package:intl` for currency and date formatting.
- Follow Dart style guide and enabled lints.
- Keep widgets small, focused, and reusable.
- Handle platform differences gracefully (e.g., navigation patterns, UI density).
- Store monetary values as integers (cents) to avoid floating-point errors.
- Use `flutter_test` for unit and widget tests.
