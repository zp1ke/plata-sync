# Plata-Sync

A personal finance management application built with Compose Multiplatform.

## Features

- 💰 **Account Management**: Create, edit, and delete accounts with balance tracking
- 📊 **Transaction Management**: Track income, expenses, and transfers between accounts
- 🏷️ **Categories**: Organize transactions with customizable categories and icons
- 🔍 **Filtering & Sorting**: Search by name, filter by date range, and sort by various criteria
- 📱 **Multi-View**: Switch between list and grid views for better data visualization
- 🌙 **Dark Mode**: Full dark mode support with Material 3 design
- 💾 **Local Storage**: All data stored locally using Room database
- 🖥️ **Multi-Platform**: Runs on Android and Desktop (JVM)

## Tech Stack

- **Compose Multiplatform** (1.9.3) - UI framework
- **Material 3** - Design system
- **Voyager** (1.1.0) - Navigation and tab management
- **Room** (2.8.3) - Local database with SQLite
- **Koin** (4.1.2) - Dependency injection with annotations
- **KSP** - Code generation
- **Kotlin Coroutines** - Async operations
- **AndroidX Lifecycle** - ViewModel and state management

## Project Structure

This is a Kotlin Multiplatform project targeting Android and Desktop (JVM).

* `/composeApp/src` contains the application code:
  - `commonMain/kotlin` - Shared code for all platforms
    - `data/` - DAOs, repositories, Room database, and ViewModels
    - `domain/` - Room entities (UserAccount, UserTransaction, UserCategory, UserSetting)
    - `model/` - Data models and enums
    - `ui/` - Composable screens and components
      - `common/` - Reusable UI components
      - `feature/` - Feature-specific UI (accounts, transactions, categories)
      - `input/` - Input components (MoneyField, DebounceTextField)
      - `screen/` - Main screens (Accounts, Transactions, Categories, Settings)
      - `theme/` - Theme configuration and colors
    - `util/` - Utility functions and formatters
  - `androidMain/kotlin` - Android-specific code
  - `jvmMain/kotlin` - Desktop-specific code

## Development

### Prerequisites

- JDK 17 or higher
- Android SDK (for Android builds)
- [direnv](https://direnv.net/) (optional, for environment management)

### Setup

1. Clone the repository
2. If using direnv, allow the `.envrc` file:
   ```shell
   direnv allow
   ```

### Development Script

Use the provided dev script for common development tasks:

```shell
./.bin/dev <command> [options]
```

Available commands:
- `clean` - Clean the project build artifacts
- `test` - Run all tests with detailed output
- `run-desktop` - Run the desktop application
- `version [type]` - Display or bump version (type: major|minor|patch)
- `help` - Show help message

**Version management examples:**
```shell
./.bin/dev version              # Display current version
./.bin/dev version patch        # Bump patch: 1.0.0 → 1.0.1
./.bin/dev version minor        # Bump minor: 1.0.0 → 1.1.0
./.bin/dev version major        # Bump major: 1.0.0 → 2.0.0
```

### Running Tests

Run tests using the dev script:
```shell
./.bin/dev test
```

Or directly with Gradle:
- macOS/Linux: `./gradlew :composeApp:test`
- Windows: `.\gradlew.bat :composeApp:test`

### Running the Application

**Desktop (JVM):**
```shell
./.bin/dev run-desktop
```
Or: `./gradlew :composeApp:run`

**Android:**
- Use the run configuration in your IDE
- Or build manually: `./gradlew :composeApp:assembleDebug`

### Direnv Setup

This project uses [direnv](https://direnv.net/) to manage environment variables.

1. Install direnv if not already installed
2. Allow the `.envrc` file in the project root:
   ```shell
   direnv allow
   ```

This adds the `.bin` directory to your PATH and sets the `PROJECT_ROOT` environment variable.

## License

See [LICENSE](LICENSE) file for details.

---

Learn more about [Kotlin Multiplatform](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html)
