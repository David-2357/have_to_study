import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum PomodoroPhase {
  focus,
  shortBreak,
  longBreak;

  String get label {
    switch (this) {
      case PomodoroPhase.focus:
        return 'FASE: CONCENTRACIÓN';
      case PomodoroPhase.shortBreak:
        return 'DESCANSO CORTO';
      case PomodoroPhase.longBreak:
        return 'DESCANSO LARGO';
    }
  }

  Color get color {
    switch (this) {
      case PomodoroPhase.focus:
        return AppColors.primary;
      case PomodoroPhase.shortBreak:
        return AppColors.teal;
      case PomodoroPhase.longBreak:
        return AppColors.info;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PomodoroPhase.focus:
        return AppColors.primaryLight;
      case PomodoroPhase.shortBreak:
        return AppColors.tealLight;
      case PomodoroPhase.longBreak:
        return AppColors.infoLight;
    }
  }

  Color displayBackgroundColor(bool isDark) {
    if (isDark) {
      return color.withValues(alpha: 0.22);
    }
    return backgroundColor;
  }

  Color displayForegroundColor(bool isDark) {
    if (isDark) {
      switch (this) {
        case PomodoroPhase.focus:
          return const Color(0xFFF87171);
        case PomodoroPhase.shortBreak:
          return const Color(0xFF5EEAD4);
        case PomodoroPhase.longBreak:
          return const Color(0xFF93C5FD);
      }
    }
    return color;
  }
}

enum PomodoroStatus {
  idle,
  running,
  paused,
}

class PomodoroStateModel {
  final PomodoroPhase phase;
  final PomodoroStatus status;
  final int remainingSeconds;
  final int totalSeconds;
  final int currentCycle;
  final int cyclesBeforeLongBreak;
  final String? activeSubjectId;
  final String? activeEventId;
  final int? currentSegmentStartRemainingSeconds;

  PomodoroStateModel({
    this.phase = PomodoroPhase.focus,
    this.status = PomodoroStatus.idle,
    this.remainingSeconds = 25 * 60,
    this.totalSeconds = 25 * 60,
    this.currentCycle = 1,
    this.cyclesBeforeLongBreak = 4,
    this.activeSubjectId,
    this.activeEventId,
    this.currentSegmentStartRemainingSeconds,
  });

  bool get isRunning => status == PomodoroStatus.running;
  bool get isPaused => status == PomodoroStatus.paused;
  bool get isIdle => status == PomodoroStatus.idle;

  double get progress {
    if (totalSeconds <= 0) return 1.0;
    return (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  PomodoroStateModel copyWith({
    PomodoroPhase? phase,
    PomodoroStatus? status,
    int? remainingSeconds,
    int? totalSeconds,
    int? currentCycle,
    int? cyclesBeforeLongBreak,
    String? activeSubjectId,
    String? activeEventId,
    int? currentSegmentStartRemainingSeconds,
    bool clearActiveSubject = false,
    bool clearActiveEvent = false,
    bool clearCurrentSegment = false,
  }) {
    return PomodoroStateModel(
      phase: phase ?? this.phase,
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      currentCycle: currentCycle ?? this.currentCycle,
      cyclesBeforeLongBreak:
          cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
      activeSubjectId:
          clearActiveSubject ? null : (activeSubjectId ?? this.activeSubjectId),
      activeEventId:
          clearActiveEvent ? null : (activeEventId ?? this.activeEventId),
      currentSegmentStartRemainingSeconds: clearCurrentSegment
          ? null
          : (currentSegmentStartRemainingSeconds ??
              this.currentSegmentStartRemainingSeconds),
    );
  }
}

class FocusSessionModel {
  final String id;
  final String? subjectId;
  final String? academicEventId;
  final DateTime startedAt;
  final DateTime completedAt;
  final int durationSeconds;

  FocusSessionModel({
    required this.id,
    this.subjectId,
    this.academicEventId,
    required this.startedAt,
    required this.completedAt,
    required this.durationSeconds,
  });

  FocusSessionModel copyWith({
    String? id,
    String? subjectId,
    String? academicEventId,
    DateTime? startedAt,
    DateTime? completedAt,
    int? durationSeconds,
    bool clearSubject = false,
    bool clearEvent = false,
  }) {
    return FocusSessionModel(
      id: id ?? this.id,
      subjectId: clearSubject ? null : (subjectId ?? this.subjectId),
      academicEventId: clearEvent ? null : (academicEventId ?? this.academicEventId),
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'academicEventId': academicEventId,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt.toIso8601String(),
    'durationSeconds': durationSeconds,
  };

  factory FocusSessionModel.fromJson(Map<String, dynamic> json) =>
      FocusSessionModel(
        id: json['id'] as String,
        subjectId: json['subjectId'] as String?,
        academicEventId: json['academicEventId'] as String?,
        startedAt: DateTime.parse(json['startedAt'] as String),
        completedAt: DateTime.parse(json['completedAt'] as String),
        durationSeconds: json['durationSeconds'] as int,
      );
}
