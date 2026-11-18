import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_database.dart';
import '../../../features/pomodoro/domain/pomodoro_models.dart';
import '../../../features/settings/domain/settings_models.dart';

class PomodoroDao {
  final AppDatabase _db;

  PomodoroDao(this._db);

  // ==========================================
  // SETTINGS (Singleton ID = 1)
  // ==========================================
  Future<PomodoroSettingsModel> getSettings() async {
    final row = await (_db.select(_db.pomodoroSettingsEntries)..where((t) => t.id.equals(1))).getSingleOrNull();
    final prefs = await SharedPreferences.getInstance();
    final priorityNoticeDays = prefs.getInt('priority_event_notice_days') ?? 2;

    if (row == null) {
      return PomodoroSettingsModel(priorityEventNoticeDays: priorityNoticeDays);
    }
    return PomodoroSettingsModel(
      focusMinutes: row.focusMinutes,
      shortBreakMinutes: row.shortBreakMinutes,
      longBreakMinutes: row.longBreakMinutes,
      cyclesBeforeLongBreak: row.cyclesBeforeLongBreak,
      autoStartBreaks: row.autoStartBreaks,
      autoStartFocus: row.autoStartFocus,
      preventScreenLock: row.preventScreenLock,
      dailyGoalHours: row.dailyGoalHours,
      completionSound: row.completionSound,
      themePreference: AppThemePreference.values.firstWhere(
        (t) => t.name == row.themePreference,
        orElse: () => AppThemePreference.system,
      ),
      use24HourFormat: row.use24HourFormat,
      weekStartDay: row.weekStartDay,
      notifyUnattendedSubjects: row.notifyUnattendedSubjects,
      unattendedDaysThreshold: row.unattendedDaysThreshold,
      priorityEventNoticeDays: priorityNoticeDays,
    );
  }

  Future<void> saveSettings(PomodoroSettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('priority_event_notice_days', settings.priorityEventNoticeDays);

    await _db.into(_db.pomodoroSettingsEntries).insertOnConflictUpdate(
      PomodoroSettingsEntriesCompanion(
        id: const Value(1),
        focusMinutes: Value(settings.focusMinutes),
        shortBreakMinutes: Value(settings.shortBreakMinutes),
        longBreakMinutes: Value(settings.longBreakMinutes),
        cyclesBeforeLongBreak: Value(settings.cyclesBeforeLongBreak),
        autoStartBreaks: Value(settings.autoStartBreaks),
        autoStartFocus: Value(settings.autoStartFocus),
        preventScreenLock: Value(settings.preventScreenLock),
        dailyGoalHours: Value(settings.dailyGoalHours),
        completionSound: Value(settings.completionSound),
        themePreference: Value(settings.themePreference.name),
        use24HourFormat: Value(settings.use24HourFormat),
        weekStartDay: Value(settings.weekStartDay),
        notifyUnattendedSubjects: Value(settings.notifyUnattendedSubjects),
        unattendedDaysThreshold: Value(settings.unattendedDaysThreshold),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ==========================================
  // STATE & DETERMINISTIC TIME RECOVERY (Singleton ID = 1)
  // ==========================================
  Future<PomodoroStateModel> getStateWithDeterministicRecovery() async {
    final row = await (_db.select(_db.pomodoroStateEntries)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) {
      return PomodoroStateModel();
    }

    final phase = PomodoroPhase.values.firstWhere(
      (p) => p.name == row.phase,
      orElse: () => PomodoroPhase.focus,
    );
    final status = PomodoroStatus.values.firstWhere(
      (s) => s.name == row.status,
      orElse: () => PomodoroStatus.idle,
    );

    int remainingSeconds = row.remainingSeconds;
    PomodoroStatus calculatedStatus = status;

    // Cálculo determinista tras segundo plano o reinicio de la app
    if (status == PomodoroStatus.running && row.lastResumedAt != null) {
      final elapsedSeconds = DateTime.now().difference(row.lastResumedAt!).inSeconds;
      if (elapsedSeconds > 0) {
        remainingSeconds = row.remainingSeconds - elapsedSeconds;
        if (remainingSeconds <= 0) {
          // La fase venció en segundo plano
          remainingSeconds = 0;
          calculatedStatus = PomodoroStatus.idle;
        }
      }
    }

    return PomodoroStateModel(
      phase: phase,
      status: calculatedStatus,
      remainingSeconds: remainingSeconds > 0 ? remainingSeconds : 0,
      totalSeconds: row.totalSeconds,
      currentCycle: row.currentCycle,
      cyclesBeforeLongBreak: row.cyclesBeforeLongBreak,
      activeSubjectId: row.activeSubjectId,
      activeEventId: row.activeEventId,
    );
  }

  Future<void> persistState({
    required PomodoroStateModel state,
    DateTime? lastResumedAt,
  }) async {
    await _db.into(_db.pomodoroStateEntries).insertOnConflictUpdate(
      PomodoroStateEntriesCompanion(
        id: const Value(1),
        phase: Value(state.phase.name),
        status: Value(state.status.name),
        activeSubjectId: Value(state.activeSubjectId),
        activeEventId: Value(state.activeEventId),
        remainingSeconds: Value(state.remainingSeconds),
        totalSeconds: Value(state.totalSeconds),
        currentCycle: Value(state.currentCycle),
        cyclesBeforeLongBreak: Value(state.cyclesBeforeLongBreak),
        lastResumedAt: Value(lastResumedAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
