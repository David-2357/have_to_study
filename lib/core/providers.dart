import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'services/audio_feedback_service.dart';
import 'services/notification_service.dart';
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
  final Ref? _ref;

  SubjectsNotifier(this._dao, List<SubjectModel> initial, [this._ref]) : super(initial) {
    Future.microtask(() => rescheduleAllUnattendedSubjectNotifications());
  }

  void _syncNotificationForSubject(SubjectModel subject, [PomodoroSettingsModel? currentSettings]) {
    if (_ref == null) return;
    final PomodoroSettingsModel settings = currentSettings ?? _ref!.read(settingsProvider);

    if (!settings.notifyUnattendedSubjects || subject.isArchived || subject.isPassed) {
      NotificationService().cancelSubjectNotification(subject.id);
      return;
    }

    NotificationService().scheduleUnattendedSubjectNotification(
      subject: subject,
      thresholdDays: settings.unattendedDaysThreshold,
    );
  }

  void rescheduleAllUnattendedSubjectNotifications() {
    if (_ref == null) return;
    final settings = _ref!.read(settingsProvider);
    for (final subject in state) {
      _syncNotificationForSubject(subject, settings);
    }
  }

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
    _syncNotificationForSubject(newSubject);
  }

  Future<void> updateSubject(SubjectModel updated) async {
    state = state.map((s) => s.id == updated.id ? updated : s).toList();
    await _dao.updateSubject(updated);
    _syncNotificationForSubject(updated);
  }

  Future<void> updateSubjects(List<SubjectModel> updatedList) async {
    final map = {for (final s in updatedList) s.id: s};
    state = state.map((s) => map[s.id] ?? s).toList();
    for (final s in updatedList) {
      await _dao.updateSubject(s);
      _syncNotificationForSubject(s);
    }
  }

  Future<void> toggleArchive(String id) async {
    SubjectModel? updatedSubject;
    state = state.map((s) {
      if (s.id == id) {
        final updated = s.copyWith(isArchived: !s.isArchived);
        updatedSubject = updated;
        return updated;
      }
      return s;
    }).toList();
    await _dao.toggleArchive(id);
    if (updatedSubject != null) {
      _syncNotificationForSubject(updatedSubject!);
    }
  }

  Future<void> togglePassed(String id) async {
    SubjectModel? updatedSubject;
    state = state.map((s) {
      if (s.id == id) {
        final updated = s.copyWith(isPassed: !s.isPassed);
        updatedSubject = updated;
        return updated;
      }
      return s;
    }).toList();
    await _dao.togglePassed(id);
    if (updatedSubject != null) {
      _syncNotificationForSubject(updatedSubject!);
    }
  }

  Future<void> addStudyTime(String subjectId, int seconds, [int pomodorosToAdd = 0]) async {
    SubjectModel? updatedSubject;
    state = state.map((s) {
      if (s.id == subjectId) {
        final updated = s.copyWith(
          totalStudySeconds: s.totalStudySeconds + seconds,
          completedPomodoros: s.completedPomodoros + pomodorosToAdd,
          lastStudiedAt: DateTime.now(),
        );
        updatedSubject = updated;
        return updated;
      }
      return s;
    }).toList();
    await _dao.addStudyTime(subjectId, seconds, pomodorosToAdd);
    if (updatedSubject != null) {
      _syncNotificationForSubject(updatedSubject!);
    }
  }

  Future<void> reload() async {
    state = await _dao.getAllSubjects();
    rescheduleAllUnattendedSubjectNotifications();
  }
}

final subjectsProvider =
    StateNotifierProvider<SubjectsNotifier, List<SubjectModel>>((ref) {
  final dao = ref.watch(subjectsDaoProvider);
  return SubjectsNotifier(dao, [], ref);
});

// ==========================================
// ACADEMIC EVENTS NOTIFIER
// ==========================================
class AcademicEventsNotifier extends StateNotifier<List<AcademicEventModel>> {
  final AcademicEventsDao _dao;
  final Ref? _ref;

  AcademicEventsNotifier(this._dao, List<AcademicEventModel> initial, [this._ref])
      : super(initial) {
    // Sincronizar notificaciones de actividades prioritarias
    Future.microtask(() => rescheduleAllPriorityNotifications());
  }

  void _syncNotificationForEvent(AcademicEventModel event) {
    if (_ref == null) return;
    if (!event.isPriority || event.isCompleted) {
      NotificationService().cancelEventNotification(event.id);
      return;
    }

    final subjects = _ref!.read(subjectsProvider);
    final subject = subjects.firstWhere(
      (s) => s.id == event.subjectId,
      orElse: () => SubjectModel(id: '', name: 'General', colorValue: 0),
    );
    final settings = _ref!.read(settingsProvider);

    NotificationService().schedulePriorityEventNotification(
      event: event,
      subjectName: subject.name,
      noticeDays: settings.priorityEventNoticeDays,
    );
  }

  void rescheduleAllPriorityNotifications() {
    if (_ref == null) return;
    for (final event in state) {
      _syncNotificationForEvent(event);
    }
  }

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
    _syncNotificationForEvent(newEvent);
  }

  Future<void> updateEvent(AcademicEventModel updated) async {
    state = state.map((e) => e.id == updated.id ? updated : e).toList();
    await _dao.updateEvent(updated);
    _syncNotificationForEvent(updated);
  }

  Future<void> toggleComplete(String id) async {
    AcademicEventModel? toggled;
    state = state.map((e) {
      if (e.id == id) {
        final updated = e.copyWith(isCompleted: !e.isCompleted);
        toggled = updated;
        return updated;
      }
      return e;
    }).toList();
    await _dao.toggleComplete(id);
    if (toggled != null) {
      _syncNotificationForEvent(toggled!);
    }
  }

  Future<void> deleteEvent(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _dao.deleteEvent(id);
    NotificationService().cancelEventNotification(id);
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

  Future<void> recordEventStudyTime(String eventId, int addedSeconds, {bool isNatural = false}) async {
    final event = state.where((e) => e.id == eventId).firstOrNull;
    if (event == null) return;

    final focusMinutes = _ref?.read(settingsProvider).focusMinutes ?? 25;
    final pomodoroSeconds = focusMinutes * 60;
    final targetSeconds = event.targetPomodoros * pomodoroSeconds;

    // Obtener todas las sesiones dedicadas a este evento
    final eventSessions = await _ref?.read(focusSessionsDaoProvider).getSessionsByEvent(eventId) ?? [];
    final totalDedicatedSeconds = eventSessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);

    // Los pomodoros equivalentes se calculan por el tiempo acumulado
    final equivalentPomos = pomodoroSeconds > 0 ? (totalDedicatedSeconds ~/ pomodoroSeconds) : 0;

    // La meta se completa por tiempo si el acumulado alcanza o supera el objetivo
    final isGoalReached = targetSeconds > 0 && totalDedicatedSeconds >= targetSeconds;

    final updated = event.copyWith(
      completedPomodoros: equivalentPomos.clamp(0, event.targetPomodoros),
      isCompleted: isGoalReached ? true : event.isCompleted,
    );

    state = state.map((e) => e.id == eventId ? updated : e).toList();
    await _dao.updateEvent(updated);
    _syncNotificationForEvent(updated);
  }

  Future<void> reload() async {
    state = await _dao.getAllEvents();
    rescheduleAllPriorityNotifications();
  }
}

final academicEventsProvider =
    StateNotifierProvider<AcademicEventsNotifier, List<AcademicEventModel>>((ref) {
  final dao = ref.watch(academicEventsDaoProvider);
  return AcademicEventsNotifier(dao, [], ref);
});

// Provider para controlar la pestaña activa en Estudios (0: Asignaturas, 1: Actividades)
final studiesActiveTabProvider = StateProvider<int>((ref) => 0);

// ==========================================
// POMODORO NOTIFIER CON RECUPERACIÓN DETERMINISTA Y NOTIFICACIONES
// ==========================================
class PomodoroNotifier extends StateNotifier<PomodoroStateModel>
    with WidgetsBindingObserver {
  final PomodoroDao _dao;
  final Ref _ref;
  Timer? _timer;
  DateTime? _lastResumedAt;

  PomodoroNotifier(this._dao, this._ref, PomodoroStateModel initial)
      : super(initial) {
    WidgetsBinding.instance.addObserver(this);
    if (state.status == PomodoroStatus.running) {
      _lastResumedAt = DateTime.now();
      if (state.remainingSeconds > 0) {
        _startTicker();
        _scheduleNotificationForCurrentPhase();
      } else {
        Future.microtask(() => _handlePhaseTransition(isNatural: true));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      syncWithRealTime();
    } else if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      if (state.status == PomodoroStatus.running) {
        _dao.persistState(state: state, lastResumedAt: _lastResumedAt);
      }
    }
  }

  void syncWithRealTime() {
    if (state.status != PomodoroStatus.running || _lastResumedAt == null) return;

    final now = DateTime.now();
    final elapsed = now.difference(_lastResumedAt!).inSeconds;

    if (elapsed > 0) {
      final newRemaining = state.remainingSeconds - elapsed;
      if (newRemaining <= 0) {
        _timer?.cancel();
        _handlePhaseTransition(isNatural: true);
      } else {
        state = state.copyWith(remainingSeconds: newRemaining);
        _lastResumedAt = now;
        _dao.persistState(state: state, lastResumedAt: now);
      }
    }
  }

  void _scheduleNotificationForCurrentPhase() {
    if (state.status != PomodoroStatus.running || state.remainingSeconds <= 0) {
      NotificationService().cancelPomodoroNotification();
      return;
    }

    final now = DateTime.now();
    final scheduledTime = now.add(Duration(seconds: state.remainingSeconds));

    String? subjectName;
    if (state.activeSubjectId != null) {
      try {
        final subjects = _ref.read(subjectsProvider);
        final match = subjects.firstWhere(
          (s) => s.id == state.activeSubjectId,
        );
        subjectName = match.name;
      } catch (_) {}
    }

    NotificationService().schedulePomodoroCompletion(
      scheduledTime: scheduledTime,
      phase: state.phase,
      subjectName: subjectName,
    );
  }

  Future<void> _recordFocusSession({required bool isNatural}) async {
    if (state.phase != PomodoroPhase.focus) return;

    final segmentStart =
        state.currentSegmentStartRemainingSeconds ?? state.totalSeconds;
    final elapsed = isNatural
        ? segmentStart
        : (segmentStart - state.remainingSeconds);

    // Solo se registra si el tiempo dura más de un minuto (>= 60 segundos)
    if (elapsed >= 60) {
      final now = DateTime.now();
      final session = FocusSessionModel(
        id: const Uuid().v4(),
        subjectId: state.activeSubjectId,
        academicEventId: state.activeEventId,
        startedAt: now.subtract(Duration(seconds: elapsed)),
        completedAt: now,
        durationSeconds: elapsed,
      );
      await _ref.read(focusSessionsDaoProvider).insertSession(session);

      // Si es natural cuenta como pomodoro natural completado (1).
      // Si fue cancelado o saltado antes de terminar, NO cuenta como pomodoro natural (0).
      if (state.activeSubjectId != null) {
        await _ref.read(subjectsProvider.notifier).addStudyTime(
              state.activeSubjectId!,
              elapsed,
              isNatural ? 1 : 0,
            );
      }

      // La meta de la actividad se completa por tiempo acumulado
      if (state.activeEventId != null) {
        await _ref.read(academicEventsProvider.notifier).recordEventStudyTime(
              state.activeEventId!,
              elapsed,
              isNatural: isNatural,
            );
      }

      await _ref.read(focusSessionsProvider.notifier).reload();
    }
  }

  Future<void> selectSubjectAndEvent(String? subjectId, String? eventId) async {
    final hasChanged =
        state.activeSubjectId != subjectId || state.activeEventId != eventId;
    if (!hasChanged) return;

    // Si se cambia en medio de una sesión de concentración activa (no en reposo),
    // registrar el tiempo si duró más de 1 minuto (sin contar como pomodoro natural)
    if (state.phase == PomodoroPhase.focus && !state.isIdle) {
      await _recordFocusSession(isNatural: false);
    }

    state = state.copyWith(
      activeSubjectId: subjectId,
      activeEventId: eventId,
      clearActiveSubject: subjectId == null,
      clearActiveEvent: eventId == null,
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

    _lastResumedAt = now;
    _dao.persistState(state: state, lastResumedAt: now);
    _startTicker();
    _scheduleNotificationForCurrentPhase();
  }

  void pause() {
    _timer?.cancel();
    _lastResumedAt = null;
    try {
      WakelockPlus.disable();
    } catch (_) {}
    state = state.copyWith(status: PomodoroStatus.paused);
    _dao.persistState(state: state, lastResumedAt: null);
    NotificationService().cancelPomodoroNotification();
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
    _lastResumedAt = now;
    _dao.persistState(state: state, lastResumedAt: now);
    _startTicker();
    _scheduleNotificationForCurrentPhase();
  }

  void reset() {
    _timer?.cancel();
    _lastResumedAt = null;
    try {
      WakelockPlus.disable();
    } catch (_) {}
    NotificationService().cancelPomodoroNotification();

    // Si estaba en concentración y no en reposo, registrar el tiempo si duró >= 60s (sin contar como pomodoro natural)
    if (state.phase == PomodoroPhase.focus && !state.isIdle) {
      _recordFocusSession(isNatural: false);
    }

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
    _lastResumedAt = null;
    NotificationService().cancelPomodoroNotification();
    _handlePhaseTransition(isNatural: false);
  }

  void cancelSession() {
    _timer?.cancel();
    _lastResumedAt = null;
    try {
      WakelockPlus.disable();
    } catch (_) {}
    NotificationService().cancelPomodoroNotification();

    // Si estaba en concentración y no en reposo, registrar el tiempo si duró >= 60s (sin contar como pomodoro natural)
    if (state.phase == PomodoroPhase.focus && !state.isIdle) {
      _recordFocusSession(isNatural: false);
    }

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

    // Cancelar cualquier notificación pendiente previa
    NotificationService().cancelPomodoroNotification();

    // Reproducir alerta sonora de finalización solo si concluye naturalmente
    if (isNatural) {
      await AudioFeedbackService().playCompletionAlert(settings.completionSound);
    }

    if (state.phase == PomodoroPhase.focus) {
      // Registrar sesión (si es natural cuenta como pomodoro natural; si no, solo si duró >= 60s y sin pomodoro natural)
      await _recordFocusSession(isNatural: isNatural);

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
        _lastResumedAt = nowBreak;
        _startTicker();
        _scheduleNotificationForCurrentPhase();
      } else {
        _lastResumedAt = null;
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
        _lastResumedAt = nowFocus;
        _startTicker();
        _scheduleNotificationForCurrentPhase();
      } else {
        _lastResumedAt = null;
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
    WidgetsBinding.instance.removeObserver(this);
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
    final noticeDaysChanged =
        state.priorityEventNoticeDays != updated.priorityEventNoticeDays;
    final unattendedSettingsChanged =
        state.notifyUnattendedSubjects != updated.notifyUnattendedSubjects ||
        state.unattendedDaysThreshold != updated.unattendedDaysThreshold;
    state = updated;
    await _dao.saveSettings(updated);
    _ref?.read(pomodoroProvider.notifier).syncSettings(updated);
    if (noticeDaysChanged) {
      _ref
          ?.read(academicEventsProvider.notifier)
          .rescheduleAllPriorityNotifications();
    }
    if (unattendedSettingsChanged) {
      _ref
          ?.read(subjectsProvider.notifier)
          .rescheduleAllUnattendedSubjectNotifications();
    }
  }

  Future<void> resetToDefaults() async {
    final defaults = PomodoroSettingsModel();
    state = defaults;
    await _dao.saveSettings(defaults);
    _ref?.read(pomodoroProvider.notifier).syncSettings(defaults);
    _ref
        ?.read(academicEventsProvider.notifier)
        .rescheduleAllPriorityNotifications();
    _ref
        ?.read(subjectsProvider.notifier)
        .rescheduleAllUnattendedSubjectNotifications();
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
    // Solo se registra si duró al menos un minuto (>= 60s)
    if (seconds < 60) return;

    final pomosEarned = (seconds / 1500).round();
    final subjectId = state.activeSubjectId;
    final eventId = state.activeEventId;

    final session = FocusSessionModel(
      id: const Uuid().v4(),
      subjectId: subjectId,
      academicEventId: eventId,
      startedAt: DateTime.now().subtract(Duration(seconds: seconds)),
      completedAt: DateTime.now(),
      durationSeconds: seconds,
    );

    await _ref.read(focusSessionsDaoProvider).insertSession(session);

    if (subjectId != null && subjectId.isNotEmpty) {
      await _ref.read(subjectsProvider.notifier).addStudyTime(subjectId, seconds, pomosEarned);
    }

    if (eventId != null && eventId.isNotEmpty) {
      await _ref.read(academicEventsProvider.notifier).recordEventStudyTime(eventId, seconds, isNatural: false);
    }

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
