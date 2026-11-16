import 'package:drift/drift.dart';

// 1. Subjects Table
class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text().withDefault(const Constant(''))();
  TextColumn get period => text().withDefault(const Constant('Semestre Académico 2024–II'))();
  TextColumn get iconKey => text().withDefault(const Constant('book'))();
  IntColumn get colorValue => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get totalStudySeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastStudiedAt => dateTime().nullable()();
  IntColumn get completedPomodoros => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Academic Events Table
class AcademicEvents extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().references(Subjects, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get type => text()(); // exam, assignment, academicActivity
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get dueAt => dateTime()();
  BoolColumn get hasDueTime => boolean().withDefault(const Constant(true))();
  IntColumn get targetPomodoros => integer().withDefault(const Constant(4))();
  IntColumn get completedPomodoros => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get academicWeight => integer().withDefault(const Constant(0))();
  BoolColumn get isPriority => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. Focus Sessions Table
class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().nullable().references(Subjects, #id, onDelete: KeyAction.setNull)();
  TextColumn get academicEventId => text().nullable().references(AcademicEvents, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime()();
  IntColumn get durationSeconds => integer()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Pomodoro Settings Table (Singleton ID = 1)
class PomodoroSettingsEntries extends Table {
  IntColumn get id => integer()();
  IntColumn get focusMinutes => integer().withDefault(const Constant(25))();
  IntColumn get shortBreakMinutes => integer().withDefault(const Constant(5))();
  IntColumn get longBreakMinutes => integer().withDefault(const Constant(15))();
  IntColumn get cyclesBeforeLongBreak => integer().withDefault(const Constant(4))();
  BoolColumn get autoStartBreaks => boolean().withDefault(const Constant(false))();
  BoolColumn get autoStartFocus => boolean().withDefault(const Constant(false))();
  BoolColumn get preventScreenLock => boolean().withDefault(const Constant(true))();
  IntColumn get dailyGoalHours => integer().withDefault(const Constant(3))();
  TextColumn get completionSound => text().withDefault(const Constant('Campana zen'))();
  TextColumn get themePreference => text().withDefault(const Constant('light'))();
  BoolColumn get use24HourFormat => boolean().withDefault(const Constant(true))();
  TextColumn get weekStartDay => text().withDefault(const Constant('Lunes'))();
  BoolColumn get notifyUnattendedSubjects => boolean().withDefault(const Constant(true))();
  IntColumn get unattendedDaysThreshold => integer().withDefault(const Constant(3))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Pomodoro State Table (Singleton ID = 1) - Para cálculo y recuperación determinista
class PomodoroStateEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get phase => text().withDefault(const Constant('focus'))(); // focus, shortBreak, longBreak
  TextColumn get status => text().withDefault(const Constant('idle'))(); // idle, running, paused
  TextColumn get activeSubjectId => text().nullable()();
  TextColumn get activeEventId => text().nullable()();
  IntColumn get remainingSeconds => integer().withDefault(const Constant(1500))();
  IntColumn get totalSeconds => integer().withDefault(const Constant(1500))();
  IntColumn get currentCycle => integer().withDefault(const Constant(1))();
  IntColumn get cyclesBeforeLongBreak => integer().withDefault(const Constant(4))();
  DateTimeColumn get lastResumedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Student Profile Table (Singleton ID = 1)
class StudentProfileEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get displayName => text().withDefault(const Constant('Alejandro Gómez'))();
  TextColumn get degreeName => text().withDefault(const Constant('Grado en Ing. Informática'))();
  TextColumn get academicPeriod => text().withDefault(const Constant('2024-II'))();
  TextColumn get semester => text().withDefault(const Constant('4° Semestre'))();
  TextColumn get avatarPath => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
