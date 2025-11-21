# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-10-24

### Added

**Core Features**
- Account management (create, edit, delete, view)
- Transaction management with three types: Income, Expense, Transfer
- Category management with customizable icons and transaction type filtering
- Settings screen with app information and version details

**User Interface**
- Tab-based navigation (Accounts, Transactions, Categories, Settings)
- List and Grid view modes for all data screens
- Dark mode support with Material 3 theming
- Responsive layouts for Android and Desktop platforms
- Custom icon system with 50+ icons for categories and features
- Empty state messaging for all screens
- Loading states with proper feedback

**Data Management**
- Local persistence with Room database
- Account balance tracking with automatic updates
- Transaction history with full audit trail
- Category organization by transaction type
- Balance statistics (current, income, expense)
- Date range filtering with presets (Today, Week, Month, Year)

**Search & Filtering**
- Debounced search by name for accounts, transactions, and categories
- Advanced filtering by date range
- Transaction filtering by account, category, and type
- Sort by name, created date, balance, or last used date
- Ascending/descending sort order toggle

**Input & Validation**
- Custom money input field with decimal separator
- Maximum account limit configuration (default: 10)
- Form validation for all inputs
- Clear actions for search fields

**Platform Support**
- Android (minSdk 26, targetSdk 36)
- Desktop (JVM) with persistent data storage

### Technical

**Architecture & Dependencies**
- Compose Multiplatform 1.9.3 UI framework
- Voyager navigation with tab support
- Room 2.8.3 database with SQLite
- Koin 4.1.2 dependency injection with annotations
- KSP code generation
- Kotlin Coroutines for async operations
- AndroidX Lifecycle (ViewModel, Compose)

**Code Organization**
- Multi-module architecture (commonMain, androidMain, jvmMain)
- Domain-driven design with Room entities
- Repository pattern with DAOs
- MVVM pattern with ViewModels
- Composable components organized by feature
- Platform-specific implementations using expect/actual

**Developer Tools**
- Development script (`.bin/dev`) for common tasks
- Automated version management (major, minor, patch)
- Gradle test configuration with detailed logging
- Direnv support for environment management
- Unit tests for platform-specific formatters

**Internationalization**
- String resources for all UI text
- Platform-specific formatters (currency, dates)
- Multi-language support infrastructure

### Fixed
- Text color visibility in dark mode
- Dialog margins on Android
- Database persistence on JVM after system restart
- Focus loss issue in debounced text fields
- Transaction type filter validation
- Balance calculation for transfers
