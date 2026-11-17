# Technical Requirements

## Environment & SDKs

| Component | Required Version / Constraint | Source File |
|---|---|---|
| Dart SDK | `^3.12.0` | `pubspec.yaml` |
| Flutter SDK | Flutter 3.x (compatible with Dart ^3.12.0) | `pubspec.yaml` |
| Java / JVM Target | Java 17 (`JavaVersion.VERSION_17` / `JVM_17`) | `android/app/build.gradle.kts` |

## Platform Compatibility

### Android
| Component | Value / Constraint | Source File |
|---|---|---|
| Application ID / Namespace | `com.havetostudy.have_to_study` | `android/app/build.gradle.kts` |
| Compile SDK | Dynamic via Flutter SDK (`flutter.compileSdkVersion`) | `android/app/build.gradle.kts` |
| Minimum SDK | Dynamic via Flutter SDK (`flutter.minSdkVersion`) | `android/app/build.gradle.kts` |
| Target SDK | Dynamic via Flutter SDK (`flutter.targetSdkVersion`) | `android/app/build.gradle.kts` |
| Android Gradle Plugin (AGP) | `9.0.1` | `android/settings.gradle.kts` |
| Kotlin Gradle Plugin | `2.3.20` | `android/settings.gradle.kts` |
| Gradle Distribution | `9.1.0-all` | `android/gradle/wrapper/gradle-wrapper.properties` |

### iOS
| Component | Value / Constraint | Source File |
|---|---|---|
| Minimum Deployment Target | iOS `13.0` (`IPHONEOS_DEPLOYMENT_TARGET = 13.0`) | `ios/Runner.xcodeproj/project.pbxproj` |

## Frameworks & Direct Runtime Dependencies

| Package | Version Constraint | Category / Purpose |
|---|---|---|
| `flutter` | `sdk: flutter` | Core UI SDK |
| `cupertino_icons` | `^1.0.8` | Cupertino icon assets |
| `flutter_riverpod` | `^2.6.1` | State management runtime |
| `riverpod_annotation` | `^2.6.1` | Annotations for Riverpod providers |
| `drift` | `^2.22.1` | SQLite persistence ORM |
| `sqlite3_flutter_libs` | `^0.5.28` | Native SQLite libraries for Flutter platforms |
| `path_provider` | `^2.1.5` | Platform-specific file system directories |
| `path` | `^1.9.1` | Path manipulation utilities |
| `go_router` | `^14.8.1` | Declarative routing |
| `table_calendar` | `^3.1.3` | Calendar UI component |
| `fl_chart` | `^0.70.2` | Data visualization charts |
| `intl` | `^0.19.0` | Date formatting and localization |
| `uuid` | `^4.5.1` | UUID generation |
| `wakelock_plus` | `^1.2.10` | Screen wake-lock for active sessions |
| `audioplayers` | `^6.1.0` | Audio playback for notifications and timer alerts |
| `shared_preferences` | `^2.3.4` | Key-value persistent storage |
| `freezed_annotation` | `^2.4.4` | Data class annotations |
| `json_annotation` | `^4.9.0` | JSON serialization annotations |
| `share_plus` | `^13.3.1` | System share dialog integration |
| `file_picker` | `^13.3.3` | Native file picker for database imports |

## Development & Code Generation Tools

| Package / Tool | Version Constraint | Purpose |
|---|---|---|
| `flutter_test` | `sdk: flutter` | Unit and widget test framework |
| `flutter_lints` | `^6.0.0` | Dart and Flutter static analysis rules |
| `build_runner` | `^2.4.14` | Code generation orchestration tool |
| `drift_dev` | `^2.22.1` | Code generator for Drift SQLite tables and DAOs |
| `riverpod_generator` | `^2.6.3` | Code generator for Riverpod providers (disabled in `build.yaml`) |
| `freezed` | `^2.5.7` | Code generator for immutable models (disabled in `build.yaml`) |
| `json_serializable` | `^6.9.2` | Code generator for JSON serializers (disabled in `build.yaml`) |

## Relevant Transitive & Native Dependencies

| Dependency | Required By | Role |
|---|---|---|
| `sqlite3` | `drift`, `sqlite3_flutter_libs` | Native C SQLite bindings |
| `audioplayers_android` | `audioplayers` | Android native audio engine |
| `audioplayers_darwin` | `audioplayers` | iOS / macOS native audio engine |
| `audioplayers_linux` | `audioplayers` | Linux native audio engine |
| `audioplayers_windows` | `audioplayers` | Windows native audio engine |
| `audioplayers_web` | `audioplayers` | Web audio player implementation |
| `android_file_picker` | `file_picker` | Android native file selection handler |

## Build & Code Generation Configuration

### Code Generation (`build.yaml`)
- **Active Builders**:
  - `drift_dev`: Targets `lib/data/database/**`
- **Disabled Builders**:
  - `riverpod_generator`: Disabled (`enabled: false`)
  - `freezed`: Disabled (`enabled: false`)
  - `json_serializable`: Disabled (`enabled: false`)
