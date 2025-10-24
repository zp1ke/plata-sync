# Plata-Sync

Application to manage personal finances.
This is a Kotlin Multiplatform project targeting Android, Desktop (JVM).

* [/composeApp](./composeApp/src) is for code that will be shared across your Compose Multiplatform applications.
  It contains several subfolders:
  - [commonMain](./composeApp/src/commonMain/kotlin) is for code that’s common for all targets.
  - Other folders are for Kotlin code that will be compiled for only the platform indicated in the folder name.

### Run tests

To run tests, use the following command in the terminal:
- on macOS/Linux
  ```shell
  ./gradlew :composeApp:test
  ```
- on Windows
  ```shell
  .\gradlew.bat :composeApp:test
  ```

### Build and Run Android Application

To build and run the development version of the Android app, use the run configuration from the run widget
in your IDE’s toolbar or build it directly from the terminal:
- on macOS/Linux
  ```shell
  ./gradlew :composeApp:assembleDebug
  ```
- on Windows
  ```shell
  .\gradlew.bat :composeApp:assembleDebug
  ```

### Build and Run Desktop (JVM) Application

To build and run the development version of the desktop app, use the run configuration from the run widget
in your IDE’s toolbar or run it directly from the terminal:
- on macOS/Linux
  ```shell
  ./gradlew :composeApp:run
  ```
- on Windows
  ```shell
  .\gradlew.bat :composeApp:run
  ```

### Development Script

Use the provided dev script for common development tasks:

```shell
./.bin/dev <command> [options]
```

Available commands:
- `clean`: Clean the project
- `test`: Run tests
- `run-desktop`: Run the desktop application
- `version [type]`: Display or bump version (type: major|minor|patch)
- `help`: Show help message

Version management examples:
```shell
./.bin/dev version              # Display current version
./.bin/dev version patch        # Bump patch: 1.0.0 → 1.0.1
./.bin/dev version minor        # Bump minor: 1.0.0 → 1.1.0
./.bin/dev version major        # Bump major: 1.0.0 → 2.0.0
```

### Direnv Setup

This project uses [direnv](https://direnv.net/) to manage environment variables.

To set up direnv:

1. Install direnv if not already installed.
2. Allow the .envrc file in the project root:

```shell
direnv allow
```

This will add the `.bin` directory to your PATH and set the `PROJECT_ROOT` environment variable.

---

Learn more about [Kotlin Multiplatform](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html)…