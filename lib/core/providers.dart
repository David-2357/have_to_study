import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../core/services/audio_feedback_service.dart';
import '../data/database/app_database.dart';
import '../data/database/daos/subjects_dao.dart';
import '../data/database/daos/academic_events_dao.dart';
import '../data/database/daos/focus_sessions_dao.dart';
import '../data/database/daos/pomodoro_dao.dart';
import '../data/database/daos/profile_dao.dart';
import '../features/subjects/domain/subject_model.dart';
import '../features/academic_events/domain/academic_event_model.dart';
import '../features/pomodoro/domain/pomodoro_models.dart';
import '../features/profile/domain/profile_model.dart';
import '../features/settings/domain/settings_models.dart';

// ==========================================
// DRIFT DATABASE & DAOS PROVIDERS
// ==========================================
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Initialize appDatabaseProvider in main');
});

final subjectsDaoProvider = Provider<SubjectsDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SubjectsDao(db);
});

final academicEventsDaoProvider = Provider<AcademicEventsDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AcademicEventsDao(db);
});

final focusSessionsDaoProvider = Provider<FocusSessionsDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return FocusSessionsDao(db);
});

final pomodoroDaoProvider = Provider<PomodoroDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PomodoroDao(db);
});

final profileDaoProvider = Provider<ProfileDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProfileDao(db);
});

// ==========================================
// SUBJECTS NOTIFIER
// ==========================================
class SubjectsNotifier extends StateNotifier<List<SubjectModel>> {
  final SubjectsDao _dao;

  SubjectsNotifier(this._dao, List<SubjectModel> initial) : super(initial);

  Future<void> createSubject({
    required String name,
    required String code,
    String period = '',
    required String iconKey,
    required int colorValue,
    bool isAnnual = false,
    DateTime? endDate,
  }) async {
    final newSubject = SubjectModel(
      id: const Uuid().v4(),
      name: name,
      code: code,
      period: period,
      iconKey: iconKey,
      colorValue: colorValue,
      isArchived: false,
      isAnnual: isAnnual,
      endDate: endDate,
      totalStudySeconds: 0,
      completedPomodoros: 0,
    );
    state = [...state, newSubject];
    await _dao.insertSubject(newSubject);
  }

  Future<void> updateSubject(SubjectModel updated) async {
    state = state.map((s) => s.id == updated.id ? updated : s).toList();
    await _dao.updateSubject(updated);
  }

  Future<void> toggleArchive(String id) async {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(isArchived: !s.isArchived);
      }
      return s;
    }).toList();
    await _dao.toggleArchive(id);
  }

  Future<void> togglePassed(String id) async {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(isPassed: !s.isPassed);
      }
      return s;
    }).toList();
    await _dao.togglePassed(id);
  }

  Future<void> addStudyTime(String subjectId, int seconds, [int pomodorosToAdd = 1]) async {
    state = state.map((s) {
      if (s.id == subjectId) {
        return s.copyWith(
          totalStudySeconds: s.totalStudySeconds + seconds,
          completedPomodoros: s.completedPomodoros + pomodorosToAdd,
          lastStudiedAt: DateTime.now(),
        );
      }
      return s;
    }).toList();
    await _dao.addStudyTime(subjectId, seconds, pomodorosToAdd);
  }

  Future<void> reload() async {
    state = await _dao.getAllSubjects();
  }
}

final subjectsProvider =
    StateNotifierProvider<SubjectsNotifier, List<SubjectModel>>((ref) {
  final dao = ref.watch(subjectsDaoProvider);
  return SubjectsNotifier(dao, []);
});

// ==========================================
// ACADEMIC EVENTS NOTIFIER
// ==========================================
class AcademicEventsNotifier extends StateNotifier<List<AcademicEventModel>> {
  final AcademicEventsDao _dao;

  AcademicEventsNotifier(this._dao, List<AcademicEventModel> initial) : super(initial);

  Future<void> createEvent({
    required String subjectId,
    required String title,
    required EventType type,
    String description = '',
    required DateTime dueAt,
    bool hasDueTime = true,
    int targetPomodoros = 4,
    int academicWeight = 0,
    bool isPriority = false,
  }) async {
    final newEvent = AcademicEventModel(
      id: const Uuid().v4(),
      subjectId: subjectId,
      title: title,
      type: type,
      description: description,
      dueAt: dueAt,
      hasDueTime: hasDueTime,
      targetPomodoros: targetPomodoros,
      completedPomodoros: 0,
      academicWeight: academicWeight,
      isPriority: isPriority,
    );
    state = [...state, newEvent];
    await _dao.insertEvent(newEvent);
  }

  Future<void> updateEvent(AcademicEventModel updated) async {
    state = state.map((e) => e.id == updated.id ? updated : e).toList();
    await _dao.updateEvent(updated);
  }

  Future<void> toggleComplete(String id) async {
    state = state.map((e) {
      if (e.id == id) {
        return e.copyWith(isCompleted: !e.isCompleted);
      }
      return e;
    }).toList();
    await _dao.toggleComplete(id);
  }

  Future<void> incrementEventPomodoro(String eventId, [int amount = 1]) async {
    state = state.map((e) {
      if (e.id == eventId) {
        return e.copyWith(
          completedPomodoros: e.completedPomodoros + amount,
        );
      }
      return e;
    }).toList();
    await _dao.incrementEventPomodoro(eventId, amount);
  }

  Future<void> reload() async {
    state = await _dao.getAllEvents();
  }
}

final academicEventsProvider =
    StateNotifierProvider<AcademicEventsNotifier, List<AcademicEventModel>>((ref) {
  final dao = ref.watch(academicEventsDaoProvider);
  return AcademicEventsNotifier(dao, []);
});

// ==========================================
// POMODORO NOTIFIER CON RECUPERACIÓN DETERMINISTA
// ==========================================
class PomodoroNotifier extends StateNotifier<PomodoroStateModel> {
  final PomodoroDao _dao;
  final Ref _ref;
  Timer? _timer;

  PomodoroNotifier(this._dao, this._ref, PomodoroStateModel initial)
      : super(initial);

  Future<void> selectSubjectAndEvent(String? subjectId, String? eventId) async {
    final hasChanged =
        state.activeSubjectId != subjectId || state.activeEventId != eventId;
    if (!hasChanged) return;

    // Si se cambia en medio de una sesión de concentración activa (no en reposo),
    // registrar el tiempo acumulado en la actividad/tarea anterior.
    if (state.phase == PomodoroPhase.focus && !state.isIdle) {
      final segmentStart =
          state.currentSegmentStartRemainingSeconds ?? state.totalSeconds;
      final elapsedInSegment = segmentStart - state.remainingSeconds;

      if (elapsedInSegment > 0) {
        final now = DateTime.now();
        final session = FocusSessionModel(
          id: const Uuid().v4(),
          subjectId: state.activeSubjectId,
          academicEventId: state.activeEventId,
          startedAt: now.subtract(Duration(seconds: elapsedInSegment)),
          completedAt: now,
          durationSeconds: elapsedInSegment,
        );
        await _ref.read(focusSessionsDaoProvider).insertSession(session);

        if (state.activeSubjectId != null) {
          await _ref
              .read(subjectsProvider.notifier)
              .addStudyTime(state.activeSubjectId!, elapsedInSegment);
        }

        await _ref.read(focusSessionsProvider.notifier).reload();
      }
    }

    state = state.copyWith(
      activeSubjectId: subjectId,
      activeEventId: eventId,
      clearActiveSubject: subjectId == null,
      clearActiveEvent: eventId == null,
      // La nueva actividad solo contabilizará el tiempo desde que se cambió
      currentSegmentStartRemainingSeconds: state.remainingSeconds,
    );
    await _dao.persistState(state: state);
  }

  Future<void> selectSubject(String? subjectId) async {
    await selectSubjectAndEvent(subjectId, null);
  }

  void startFocus() {
    final settings = _ref.read(settingsProvider);
    final focusSeconds = settings.focusMinutes * 60;
    final now = DateTime.now();
    final isResuming = state.phase == PomodoroPhase.focus && !state.isIdle;

    if (settings.preventScreenLock) {
      try {
        WakelockPlus.enable();
      } catch (_) {}
    }

    state = state.copyWith(
      phase: PomodoroPhase.focus,
      status: PomodoroStatus.running,
      remainingSeconds: isResuming ? state.remainingSeconds : focusSeconds,
      totalSeconds: focusSeconds,
      currentSegmentStartRemainingSeconds: isResuming
          ? (state.currentSegmentStartRemainingSeconds ?? state.remainingSeconds)
          : focusSeconds,
    );

    _dao.persistState(state: state, lastResumedAt: now);
    _startTicker();
  }

  void pause() {
    _timer?.cancel();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    state = state.copyWith(status: PomodoroStatus.paused);
    _dao.persistState(state: state, lastResumedAt: null);
  }

  void resume() {
    final settings = _ref.read(settingsProvider);
    if (settings.preventScreenLock) {
      try {
        WakelockPlus.enable();
      } catch (_) {}
    }
    final now = DateTime.now();
    state = state.copyWith(
      status: PomodoroStatus.running,
      currentSegmentStartRemainingSeconds:
          state.currentSegmentStartRemainingSeconds ?? state.remainingSeconds,
    );
    _dao.persistState(state: state, lastResumedAt: now);
    _startTicker();
  }

  void reset() {
    _timer?.cancel();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    final settings = _ref.read(settingsProvider);
    final duration = _getPhaseDuration(state.phase, settings);
    state = state.copyWith(
      status: PomodoroStatus.idle,
      remainingSeconds: duration,
      totalSeconds: duration,
      clearCurrentSegment: true,
    );
    _dao.persistState(state: state, lastResumedAt: null);
  }

  void skipToNextPhase() {
    _timer?.cancel();
    _handlePhaseTransition(isNatural: false);
  }

  void cancelSession() {
    _timer?.cancel();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    final settings = _ref.read(settingsProvider);
    final focusSeconds = settings.focusMinutes * 60;
    state = state.copyWith(
      phase: PomodoroPhase.focus,
      status: PomodoroStatus.idle,
      remainingSeconds: focusSeconds,
      totalSeconds: focusSeconds,
      clearCurrentSegment: true,
    );
    _dao.persistState(state: state, lastResumedAt: null);
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      } else {
        _timer?.cancel();
        _handlePhaseTransition(isNatural: true);
      }
    });
  }

  Future<void> _handlePhaseTransition({bool isNatural = true}) async {
    final settings = _ref.read(settingsProvider);

    // Reproducir alerta sonora de finalización solo si concluye naturalmente
    if (isNatural) {
      await AudioFeedbackService().playCompletionAlert(settings.completionSound);
    }

    if (state.phase == PomodoroPhase.focus) {
      // SOLO registrar la sesión si concluyó naturalmente sin saltar
      if (isNatural) {
        final segmentStart =
            state.currentSegmentStartRemainingSeconds ?? state.totalSeconds;
        final elapsedInFinalSegment = segmentStart;

        if (elapsedInFinalSegment > 0) {
          final now = DateTime.now();
          final session = FocusSessionModel(
            id: const Uuid().v4(),
            subjectId: state.activeSubjectId,
            academicEventId: state.activeEventId,
            startedAt: now.subtract(Duration(seconds: elapsedInFinalSegment)),
            completedAt: now,
            durationSeconds: elapsedInFinalSegment,
          );
          await _ref.read(focusSessionsDaoProvider).insertSession(session);

          // Actualizar asignatura con el tiempo transcurrido en este segmento
          if (state.activeSubjectId != null) {
            await _ref
                .read(subjectsProvider.notifier)
                .addStudyTime(state.activeSubjectId!, elapsedInFinalSegment);
          }
        }

        // Actualizar evento (pomodoro completado)
        if (state.activeEventId != null) {
          await _ref
              .read(academicEventsProvider.notifier)
              .incrementEventPomodoro(state.activeEventId!);
        }

        // Actualizar sesiones provider
        await _ref.read(focusSessionsProvider.notifier).reload();
      }

      // Transición a descanso: si el ciclo actual alcanza los ciclos por ronda -> Descanso largo
      final isLongBreak = state.currentCycle >= settings.cyclesBeforeLongBreak;

      if (isLongBreak) {
        final longBreakSeconds = settings.longBreakMinutes * 60;
        state = state.copyWith(
          phase: PomodoroPhase.longBreak,
          status: settings.autoStartBreaks
              ? PomodoroStatus.running
              : PomodoroStatus.idle,
          remainingSeconds: longBreakSeconds,
          totalSeconds: longBreakSeconds,
          currentCycle: state.currentCycle,
          cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak,
          clearCurrentSegment: true,
        );
      } else {
        final shortBreakSeconds = settings.shortBreakMinutes * 60;
        state = state.copyWith(
          phase: PomodoroPhase.shortBreak,
          status: settings.autoStartBreaks
              ? PomodoroStatus.running
              : PomodoroStatus.idle,
          remainingSeconds: shortBreakSeconds,
          totalSeconds: shortBreakSeconds,
          currentCycle: state.currentCycle,
          cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak,
          clearCurrentSegment: true,
        );
      }

      final nowBreak = DateTime.now();
      await _dao.persistState(
        state: state,
        lastResumedAt: settings.autoStartBreaks ? nowBreak : null,
      );

      if (settings.autoStartBreaks) {
        _startTicker();
      }
    } else {
      // Fin del descanso (corto o largo) -> Volver a focus
      // Si concluye un descanso largo, se reinicia la ronda al ciclo 1.
      // Si concluye un descanso corto, se avanza al siguiente ciclo.
      final nextCycle = (state.phase == PomodoroPhase.longBreak)
          ? 1
          : (state.currentCycle + 1);

      final focusSeconds = settings.focusMinutes * 60;
      state = state.copyWith(
        phase: PomodoroPhase.focus,
        status: settings.autoStartFocus
            ? PomodoroStatus.running
            : PomodoroStatus.idle,
        remainingSeconds: focusSeconds,
        totalSeconds: focusSeconds,
        currentCycle: nextCycle,
        cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak,
        currentSegmentStartRemainingSeconds: focusSeconds,
      );

      final nowFocus = DateTime.now();
      await _dao.persistState(
        state: state,
        lastResumedAt: settings.autoStartFocus ? nowFocus : null,
      );

      if (settings.autoStartFocus) {
        _startTicker();
      }
    }
  }

  void syncSettings(PomodoroSettingsModel settings) {
    state = state.copyWith(
      cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak,
    );
    _dao.persistState(state: state);
  }

  int _getPhaseDuration(PomodoroPhase phase, PomodoroSettingsModel settings) {
    switch (phase) {
      case PomodoroPhase.focus:
        return settings.focusMinutes * 60;
      case PomodoroPhase.shortBreak:
        return settings.shortBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return settings.longBreakMinutes * 60;
    }
  }

  Future<void> reload() async {
    _timer?.cancel();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    state = await _dao.getStateWithDeterministicRecovery();
  }

  @override
  void dispose() {
    _timer?.cancel();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    super.dispose();
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroStateModel>((ref) {
  final dao = ref.watch(pomodoroDaoProvider);
  return PomodoroNotifier(dao, ref, PomodoroStateModel());
});

// ==========================================
// FOCUS SESSIONS NOTIFIER
// ==========================================
class FocusSessionsNotifier extends StateNotifier<List<FocusSessionModel>> {
  final FocusSessionsDao _dao;

  FocusSessionsNotifier(this._dao, List<FocusSessionModel> initial) : super(initial);

  Future<void> reload() async {
    state = await _dao.getAllSessions();
  }
}

final focusSessionsProvider =
    StateNotifierProvider<FocusSessionsNotifier, List<FocusSessionModel>>((ref) {
  final dao = ref.watch(focusSessionsDaoProvider);
  return FocusSessionsNotifier(dao, []);
});

// ==========================================
// PROFILE NOTIFIER
// ==========================================
class ProfileNotifier extends StateNotifier<StudentProfileModel> {
  final ProfileDao _dao;

  ProfileNotifier(this._dao, StudentProfileModel initial) : super(initial);

  Future<void> updateProfile(StudentProfileModel updated) async {
    state = updated;
    await _dao.saveProfile(updated);
  }

  Future<void> reload() async {
    state = await _dao.getProfile();
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, StudentProfileModel>((ref) {
  final dao = ref.watch(profileDaoProvider);
  return ProfileNotifier(dao, StudentProfileModel());
});

// ==========================================
// SETTINGS NOTIFIER
// ==========================================
class SettingsNotifier extends StateNotifier<PomodoroSettingsModel> {
  final PomodoroDao _dao;
  final Ref? _ref;

  SettingsNotifier(this._dao, PomodoroSettingsModel initial, [this._ref])
      : super(initial);

  Future<void> updateSettings(PomodoroSettingsModel updated) async {
    state = updated;
    await _dao.saveSettings(updated);
    _ref?.read(pomodoroProvider.notifier).syncSettings(updated);
  }

  Future<void> resetToDefaults() async {
    final defaults = PomodoroSettingsModel();
    state = defaults;
    await _dao.saveSettings(defaults);
    _ref?.read(pomodoroProvider.notifier).syncSettings(defaults);
  }

  Future<void> reload() async {
    state = await _dao.getSettings();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, PomodoroSettingsModel>((ref) {
  final dao = ref.watch(pomodoroDaoProvider);
  return SettingsNotifier(dao, PomodoroSettingsModel(), ref);
});

// ==========================================
// SESIÓN SIN LÍMITES (CRONÓMETRO CONTINUO)
// ==========================================
class UnboundedSessionState {
  final int elapsedSeconds;
  final bool isRunning;
  final String? activeSubjectId;
  final String? activeEventId;

  const UnboundedSessionState({
    this.elapsedSeconds = 0,
    this.isRunning = false,
    this.activeSubjectId,
    this.activeEventId,
  });

  UnboundedSessionState copyWith({
    int? elapsedSeconds,
    bool? isRunning,
    String? activeSubjectId,
    String? activeEventId,
  }) {
    return UnboundedSessionState(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isRunning: isRunning ?? this.isRunning,
      activeSubjectId: activeSubjectId ?? this.activeSubjectId,
      activeEventId: activeEventId ?? this.activeEventId,
    );
  }
}

class UnboundedSessionNotifier extends StateNotifier<UnboundedSessionState> {
  final Ref _ref;
  Timer? _timer;

  UnboundedSessionNotifier(this._ref) : super(const UnboundedSessionState());

  void selectSubjectAndEvent(String? subjectId, String? eventId) {
    if (state.activeSubjectId == subjectId && state.activeEventId == eventId) return;

    if (state.isRunning && state.elapsedSeconds > 0) {
      _saveCurrentSession();
      state = state.copyWith(
        elapsedSeconds: 0,
        activeSubjectId: subjectId,
        activeEventId: eventId,
      );
    } else {
      state = state.copyWith(
        activeSubjectId: subjectId,
        activeEventId: eventId,
      );
    }
  }

  void start() {
    if (state.isRunning) return;
    _timer?.cancel();
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    start();
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(elapsedSeconds: 0, isRunning: false);
  }

  Future<({int pomodorosEarned, int secondsSaved})> finishAndSave() async {
    final seconds = state.elapsedSeconds;
    if (seconds <= 0) {
      reset();
      return (pomodorosEarned: 0, secondsSaved: 0);
    }

    final pomosEarned = (seconds / 1500).round();
    await _saveCurrentSession();

    reset();
    return (pomodorosEarned: pomosEarned, secondsSaved: seconds);
  }

  Future<void> _saveCurrentSession() async {
    final seconds = state.elapsedSeconds;
    if (seconds <= 0) return;

    final pomosEarned = (seconds / 1500).round();
    final subjectId = state.activeSubjectId;
    final eventId = state.activeEventId;

    if (subjectId != null && subjectId.isNotEmpty) {
      await _ref.read(subjectsProvider.notifier).addStudyTime(subjectId, seconds, pomosEarned);
    }

    if (eventId != null && eventId.isNotEmpty && pomosEarned > 0) {
      await _ref.read(academicEventsProvider.notifier).incrementEventPomodoro(eventId, pomosEarned);
    }

    final session = FocusSessionModel(
      id: const Uuid().v4(),
      subjectId: subjectId,
      academicEventId: eventId,
      startedAt: DateTime.now().subtract(Duration(seconds: seconds)),
      completedAt: DateTime.now(),
      durationSeconds: seconds,
    );

    await _ref.read(focusSessionsDaoProvider).insertSession(session);
    await _ref.read(focusSessionsProvider.notifier).reload();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final unboundedSessionProvider =
    StateNotifierProvider<UnboundedSessionNotifier, UnboundedSessionState>((ref) {
  return UnboundedSessionNotifier(ref);
});
