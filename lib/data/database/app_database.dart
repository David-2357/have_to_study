import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Subjects,
  AcademicEvents,
  FocusSessions,
  PomodoroSettingsEntries,
  PomodoroStateEntries,
  StudentProfileEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Habilitar Foreign Keys según technical_specification.md §3
        await customStatement('PRAGMA foreign_keys = ON');

        if (details.wasCreated) {
          // Inicializar filas singleton
          await into(pomodoroSettingsEntries).insert(
            const PomodoroSettingsEntriesCompanion(
              id: Value(1),
              focusMinutes: Value(25),
              shortBreakMinutes: Value(5),
              longBreakMinutes: Value(15),
              cyclesBeforeLongBreak: Value(4),
              autoStartBreaks: Value(false),
              autoStartFocus: Value(false),
              preventScreenLock: Value(true),
              dailyGoalHours: Value(3),
              completionSound: Value('Campana zen'),
              themePreference: Value('system'),
              use24HourFormat: Value(true),
              weekStartDay: Value('Lunes'),
            ),
          );

          await into(pomodoroStateEntries).insert(
            const PomodoroStateEntriesCompanion(
              id: Value(1),
              phase: Value('focus'),
              status: Value('idle'),
              remainingSeconds: Value(25 * 60),
              totalSeconds: Value(25 * 60),
              currentCycle: Value(1),
              cyclesBeforeLongBreak: Value(4),
            ),
          );

          await into(studentProfileEntries).insert(
            const StudentProfileEntriesCompanion(
              id: Value(1),
              displayName: Value('Estudiante'),
              degreeName: Value(''),
              academicPeriod: Value(''),
              semester: Value(''),
            ),
          );

          // No sembrar datos iniciales por defecto (empieza limpio según requerimiento)
        }
      },
    );
  }

  Future<void> clearAllData() async {
    await delete(focusSessions).go();
    await delete(academicEvents).go();
    await delete(subjects).go();
    await (update(studentProfileEntries)..where((t) => t.id.equals(1))).write(
      const StudentProfileEntriesCompanion(
        displayName: Value('Estudiante'),
        degreeName: Value(''),
        academicPeriod: Value(''),
        semester: Value(''),
        avatarPath: Value(null),
      ),
    );
    await (update(pomodoroSettingsEntries)..where((t) => t.id.equals(1))).write(
      const PomodoroSettingsEntriesCompanion(
        focusMinutes: Value(25),
        shortBreakMinutes: Value(5),
        longBreakMinutes: Value(15),
        cyclesBeforeLongBreak: Value(4),
        autoStartBreaks: Value(false),
        autoStartFocus: Value(false),
        preventScreenLock: Value(true),
        dailyGoalHours: Value(3),
        completionSound: Value('Campana zen'),
        themePreference: Value('system'),
        use24HourFormat: Value(true),
        weekStartDay: Value('Lunes'),
      ),
    );
    await (update(pomodoroStateEntries)..where((t) => t.id.equals(1))).write(
      const PomodoroStateEntriesCompanion(
        phase: Value('focus'),
        status: Value('idle'),
        remainingSeconds: Value(25 * 60),
        totalSeconds: Value(25 * 60),
        currentCycle: Value(1),
        cyclesBeforeLongBreak: Value(4),
        activeSubjectId: Value(null),
        activeEventId: Value(null),
        lastResumedAt: Value(null),
      ),
    );
  }

  Future<void> clearAndReseed() async {
    await clearAllData();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'have_to_study.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
