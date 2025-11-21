# GitHub Copilot Instructions

## Project Overview
**Plata-Sync** is a personal finance management application built with Compose Multiplatform.

## Platform Support
- ✅ Android (minSdk: 26, targetSdk: 36)
- ✅ Desktop (JVM)
- ❌ iOS (not supported)

## Technology Stack
- **UI**: Compose Multiplatform (1.9.3) with Material 3
- **Navigation**: Voyager (tab and screen navigation)
- **Database**: Room (2.8.3) with SQLite
- **DI**: Koin (4.1.2) with annotations and KSP
- **Lifecycle**: AndroidX Lifecycle (ViewModel, Compose)
- **Coroutines**: Kotlinx Coroutines with Swing support for JVM

## Architecture
- **Domain Layer**: Room entities (`UserAccount`, `UserTransaction`, `UserCategory`, `UserSetting`)
- **Data Layer**: DAOs and Repositories with Koin annotations
- **Presentation Layer**: Screen ViewModels with state management
- **UI Layer**: Composable screens organized by feature

## Key Features
- Account management with balance tracking
- Transaction management (Income, Expense, Transfer)
- Category management with icons and transaction type filtering
- Settings screen
- Dark mode support
- Filtering and sorting (name, date, balance)
- List and Grid view modes
- Debounced search functionality
- Date range filtering with presets
- Money input with decimal handling
- Platform-specific formatters (currency, dates)

## Important Guidelines
- Use common Compose Multiplatform APIs that work across Android and JVM platforms
- Avoid iOS-specific or Apple platform code
- Do not use Android-only APIs in common code (e.g., `BottomNavigation`, Android Context without platform-specific implementations)
- Use `expect`/`actual` pattern for platform-specific implementations
- Utilize string resources for internationalization support
- Follow Material 3 design patterns
- Use Koin annotations (`@Factory`, `@Single`) for dependency injection
- Implement Room entities in the `domain` package
- Store ViewModels in `data.viewModel` package
- Organize UI features in `ui.feature.<feature>` packages
- Use `AppIcon` enum for icon references across the app
- Format money as cents (Int) in database, display with `formatMoney()` utility
- Use `OffsetDateTime` for timestamps with Room converters
