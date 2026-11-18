enum AppThemePreference {
  light,
  dark,
  system;

  String get displayName {
    switch (this) {
      case AppThemePreference.light:
        return 'Claro';
      case AppThemePreference.dark:
        return 'Oscuro';
      case AppThemePreference.system:
        return 'Auto';
    }
  }
}

class PomodoroSettingsModel {
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int cyclesBeforeLongBreak;
  final bool autoStartBreaks;
  final bool autoStartFocus;
  final bool preventScreenLock;
  final int dailyGoalHours;
  final String completionSound;
  final AppThemePreference themePreference;
  final bool use24HourFormat;
  final String weekStartDay;
  final bool notifyUnattendedSubjects;
  final int unattendedDaysThreshold;
  final int priorityEventNoticeDays;

  PomodoroSettingsModel({
    this.focusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.cyclesBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartFocus = false,
    this.preventScreenLock = true,
    this.dailyGoalHours = 3,
    this.completionSound = 'Campana zen',
    this.themePreference = AppThemePreference.system,
    this.use24HourFormat = true,
    this.weekStartDay = 'Lunes',
    this.notifyUnattendedSubjects = true,
    this.unattendedDaysThreshold = 3,
    this.priorityEventNoticeDays = 2,
  });

  PomodoroSettingsModel copyWith({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? cyclesBeforeLongBreak,
    bool? autoStartBreaks,
    bool? autoStartFocus,
    bool? preventScreenLock,
    int? dailyGoalHours,
    String? completionSound,
    AppThemePreference? themePreference,
    bool? use24HourFormat,
    String? weekStartDay,
    bool? notifyUnattendedSubjects,
    int? unattendedDaysThreshold,
    int? priorityEventNoticeDays,
  }) {
    return PomodoroSettingsModel(
      focusMinutes: focusMinutes ?? this.focusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      cyclesBeforeLongBreak:
          (cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak).clamp(1, 16),
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      preventScreenLock: preventScreenLock ?? this.preventScreenLock,
      dailyGoalHours: (dailyGoalHours ?? this.dailyGoalHours).clamp(1, 24),
      completionSound: completionSound ?? this.completionSound,
      themePreference: themePreference ?? this.themePreference,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      weekStartDay: weekStartDay ?? this.weekStartDay,
      notifyUnattendedSubjects:
          notifyUnattendedSubjects ?? this.notifyUnattendedSubjects,
      unattendedDaysThreshold:
          unattendedDaysThreshold ?? this.unattendedDaysThreshold,
      priorityEventNoticeDays: (priorityEventNoticeDays ?? this.priorityEventNoticeDays).clamp(1, 14),
    );
  }

  Map<String, dynamic> toJson() => {
    'focusMinutes': focusMinutes,
    'shortBreakMinutes': shortBreakMinutes,
    'longBreakMinutes': longBreakMinutes,
    'cyclesBeforeLongBreak': cyclesBeforeLongBreak,
    'autoStartBreaks': autoStartBreaks,
    'autoStartFocus': autoStartFocus,
    'preventScreenLock': preventScreenLock,
    'dailyGoalHours': dailyGoalHours,
    'completionSound': completionSound,
    'themePreference': themePreference.name,
    'use24HourFormat': use24HourFormat,
    'weekStartDay': weekStartDay,
    'notifyUnattendedSubjects': notifyUnattendedSubjects,
    'unattendedDaysThreshold': unattendedDaysThreshold,
    'priorityEventNoticeDays': priorityEventNoticeDays,
  };

  factory PomodoroSettingsModel.fromJson(Map<String, dynamic> json) =>
      PomodoroSettingsModel(
        focusMinutes: json['focusMinutes'] as int? ?? 25,
        shortBreakMinutes: json['shortBreakMinutes'] as int? ?? 5,
        longBreakMinutes: json['longBreakMinutes'] as int? ?? 15,
        cyclesBeforeLongBreak: json['cyclesBeforeLongBreak'] as int? ?? 4,
        autoStartBreaks: json['autoStartBreaks'] as bool? ?? false,
        autoStartFocus: json['autoStartFocus'] as bool? ?? false,
        preventScreenLock: json['preventScreenLock'] as bool? ?? true,
        dailyGoalHours: json['dailyGoalHours'] as int? ?? 3,
        completionSound: json['completionSound'] as String? ?? 'Campana zen',
        themePreference: AppThemePreference.values.firstWhere(
          (t) => t.name == json['themePreference'],
          orElse: () => AppThemePreference.light,
        ),
        use24HourFormat: json['use24HourFormat'] as bool? ?? true,
        weekStartDay: json['weekStartDay'] as String? ?? 'Lunes',
        notifyUnattendedSubjects:
            json['notifyUnattendedSubjects'] as bool? ?? true,
        unattendedDaysThreshold:
            json['unattendedDaysThreshold'] as int? ?? 3,
        priorityEventNoticeDays:
            json['priorityEventNoticeDays'] as int? ?? 2,
      );
}
