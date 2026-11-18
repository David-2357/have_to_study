# Project Structure

This document serves as the single reference for the project's directory and file organization.

## Root Directory Organization

```text
have_to_study/
├── android/              # Android platform configuration and build scripts
├── assets/               # Application static assets (icons, images)
│   └── icon/             # Launcher and application branding icons
├── docs/                 # Project documentation
│   ├── PROJECT_STRUCTURE.md       # Directory organization and module responsibilities
│   ├── TECHNICAL_REQUIREMENTS.md  # Technical inventory, dependencies, and versions
│   └── THEME_GUIDELINES.md        # Semantic theme color tokens and UI role usage guide
├── ios/                  # iOS platform configuration and build scripts
├── lib/                  # Dart/Flutter source code
├── test/                 # Unit and widget test suite
├── AGENTS.md             # Development, commit, and documentation rules
├── pubspec.yaml          # Project metadata and dependencies manifest
├── pubspec.lock          # Locked package dependency versions
└── README.md             # General project overview and getting started guide
```

## Source Code Organization (`lib/`)

The application follows a feature-first architecture separated into top-level layers:

```text
lib/
├── app/                  # Application initialization and navigation scaffolding
├── core/                 # Core cross-cutting infrastructure and global state
├── data/                 # Local persistence layer (Drift/SQLite)
├── features/             # Feature-specific business logic and presentation
├── shared/               # Reusable widgets and utilities shared across features
└── main.dart             # Application entry point
```

### 1. `lib/app/`
Application bootstrap and global navigation.
- `main_navigation_scaffold.dart`: Root shell scaffold with bottom navigation bar.
- `router.dart`: GoRouter declarative routing configuration and path declarations.

### 2. `lib/core/`
Foundational services, state notifiers, and design system definitions.
- `providers.dart`: Riverpod state notifiers managing global application state (timer, database notifiers, user profile, settings).
- `services/`:
  - `audio_feedback_service.dart`: Sound effect generation and playback for timer events.
  - `backup_service.dart`: Automated and manual SQLite/JSON backup, restore, and file sharing.
  - `notification_service.dart`: Scheduled and immediate local device notifications for Pomodoro and break completion.
- `theme/`:
  - `app_colors.dart`: Static brand tokens, status colors, and event milestone palettes.
  - `app_color_theme.dart`: Reactive ThemeExtension with dynamic surface and typography tokens.
  - `app_theme.dart`: ThemeData configurations registering extensions for light and dark modes.

### 3. `lib/data/`
Local data persistence using Drift and SQLite.
- `database/`:
  - `app_database.dart`: Database singleton, table registry, and initialization logic.
  - `app_database.g.dart`: Generated Drift query code and table data classes.
  - `tables/`: Schema definitions for SQLite tables (`Subjects`, `AcademicEvents`, `FocusSessions`, `PomodoroSettings`, `StudentProfile`).
  - `daos/`: Data Access Objects encapsulating domain-specific database queries.

### 4. `lib/features/`
Autonomous feature modules grouped by business capability. Each feature directory contains its domain models and presentation screens/widgets:
- `academic_events/`: Management of homework, deliverables, and exams (`create_event_sheet.dart`).
- `calendar/`: Monthly calendar view with scheduled activity indicators (`calendar_screen.dart`).
- `onboarding/`: First-run tutorial and student profile setup flow (`onboarding_screen.dart`).
- `pomodoro/`: Focus tracking timers, including standard Pomodoro and continuous Unbounded sessions (`active_session_screen.dart`, `pomodoro_screen.dart`, `pomodoro_quick_settings_sheet.dart`).
- `profile/`: Student profile details, avatar selector, and academic status (`profile_screen.dart`).
- `settings/`: Application preferences, timer defaults, and backup management (`settings_screen.dart`).
- `splash/`: Application launch screen with database initialization check (`splash_screen.dart`).
- `statistics/`: Visual charts, focus metrics, and subject time distribution (`statistics_screen.dart`).
- `subjects/`: Course management with smart deadlines, course modes, and year-end closure classification (`studies_screen.dart`, `create_subject_screen.dart`, `subject_detail_screen.dart`, `course_closure_screen.dart`).

### 5. `lib/shared/`
Reusable components, widgets, and utilities shared across multiple features. Feature-agnostic by design.
- `utils/`:
  - `time_utils.dart`: Reusable time formatting, countdown calculations, and date display helpers.
- `widgets/`:
  - `academic_event_card.dart`: Reusable expandable card for academic deadlines, exams, and deliverables used across Calendar and Studies.
  - `app_header.dart`: Common header displaying screen title, logo, settings shortcut, and user avatar.
  - `student_avatar.dart`: Reusable avatar widget rendering custom presets, user images, or initials.

## Placement Guidelines

1. **Feature-specific code**: Place inside `lib/features/<feature_name>/` (e.g. `domain/` for entities, `presentation/` for UI).
2. **Shared cross-feature code**: Place reusable UI components and helper utilities in `lib/shared/`.
3. **Core infrastructure**: Place database access in `lib/data/` and global state/services in `lib/core/`.
