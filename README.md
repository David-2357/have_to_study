# HaveToStudy

An offline-first academic study tracker and focus timer built with Flutter and Drift (SQLite).

## Overview

HaveToStudy helps students organize their academic schedule, track study time, and manage course deliverables with zero cloud dependency. All data is stored locally on the device with backup, export, and restore capabilities.

## Features

- **Focus Sessions**:
  - **Pomodoro Mode**: Configurable study blocks (25 min default), short breaks (5 min), and long breaks (15 min) with audio alerts and notification support.
  - **Unbounded Session Mode**: Continuous stopwatch mode for open-ended study sessions, converting accumulated focus time into Pomodoro units `(time / 25 min)` towards subject goals.
- **Subject & Course Management**:
  - Support for annual and semestral subjects with automatic smart end-date defaults (January / June).
  - Track study hours, target goals, passed courses, and associated assignments.
- **Academic Events & Deliverables**:
  - Track assignments, projects, and exams with due dates, priority tags, and completion status.
  - Mark deliverables completed directly from active sessions or task cards.
- **Calendar & Planning**:
  - Monthly calendar view displaying scheduled deliveries and exams.
  - Dynamic indicator dots reflecting pending work for each day.
- **Statistics & Insights**:
  - Total study hours and Pomodoros completed.
  - Time distribution across subjects and peak study hour analysis.
- **Data & Backups**:
  - Local SQLite persistence powered by Drift.
  - Automated periodic local backups (configurable interval).
  - JSON and SQLite export/import with system share dialog integration.

## Tech Stack

- **Framework**: Flutter (Dart ^3.5.0)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Database**: Drift (`drift`, `drift_flutter`, `sqlite3_flutter_libs`)
- **Audio**: `audioplayers`
- **File & Share**: `file_picker`, `share_plus`, `path_provider`

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.5.0)
- Android Studio / Xcode (for device emulators or physical deployment)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/David-2357/have_to_study.git
   cd have_to_study
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation (for Drift database models):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Launch the application:
   ```bash
   flutter run
   ```

## Project Structure

```text
lib/
├── app/                  # App routing and shell navigation scaffold
├── core/
│   ├── providers.dart    # Riverpod state notifiers and providers
│   ├── services/         # Audio feedback and backup services
│   ├── theme/            # Color palettes and app themes
│   └── widgets/          # Shared atomic widgets (header, avatar)
├── data/
│   └── database/         # Drift tables, DAOs, and database configuration
├── features/
│   ├── academic_events/  # Assignment and exam management
│   ├── calendar/         # Monthly calendar and scheduling
│   ├── onboarding/       # Initial setup walkthrough
│   ├── pomodoro/         # Pomodoro timer and unbounded session screens
│   ├── profile/          # User profile and stats
│   ├── settings/         # Preferences, backups, and data management
│   ├── splash/           # Splash screen
│   ├── statistics/       # Study analytics and charts
│   └── subjects/         # Subjects CRUD, detail views, and course modes
└── main.dart             # Application entry point
```

## Testing

Run unit and widget tests:
```bash
flutter test
```
