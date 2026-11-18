import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_color_theme.dart';
import 'core/providers.dart';
import 'data/database/app_database.dart';
import 'data/database/daos/subjects_dao.dart';
import 'data/database/daos/academic_events_dao.dart';
import 'data/database/daos/focus_sessions_dao.dart';
import 'data/database/daos/pomodoro_dao.dart';
import 'data/database/daos/profile_dao.dart';
import 'app/router.dart';
import 'features/settings/domain/settings_models.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar notificaciones locales y solicitar permisos para alertas en segundo plano
  await NotificationService().initialize();
  await NotificationService().requestPermissions();

  // Inicializar localización en español para fechas y calendarios
  await initializeDateFormatting('es', null);

  // Comprobar estado del asistente de bienvenida (Onboarding)
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;

  // Inicializar Base de Datos Drift/SQLite relacional
  final db = AppDatabase();

  if (!hasCompletedOnboarding) {
    // Si aún no ha completado el asistente, garantizar que la base de datos empiece completamente limpia
    await db.clearAllData();
  }

  // DAOs
  final subjectsDao = SubjectsDao(db);
  final eventsDao = AcademicEventsDao(db);
  final sessionsDao = FocusSessionsDao(db);
  final pomodoroDao = PomodoroDao(db);
  final profileDao = ProfileDao(db);

  // Carga inicial y recuperación determinista del Pomodoro
  final initialSubjects = await subjectsDao.getAllSubjects();
  final initialEvents = await eventsDao.getAllEvents();
  final initialSessions = await sessionsDao.getAllSessions();
  final initialPomodoroState = await pomodoroDao.getStateWithDeterministicRecovery();
  final initialSettings = await pomodoroDao.getSettings();
  final initialProfile = await profileDao.getProfile();

  final router = createAppRouter(
    initialLocation: '/splash',
  );

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        subjectsProvider.overrideWith((ref) => SubjectsNotifier(subjectsDao, initialSubjects, ref)),
        academicEventsProvider.overrideWith((ref) => AcademicEventsNotifier(eventsDao, initialEvents, ref)),
        focusSessionsProvider.overrideWith((ref) => FocusSessionsNotifier(sessionsDao, initialSessions, ref)),
        pomodoroProvider.overrideWith((ref) => PomodoroNotifier(pomodoroDao, ref, initialPomodoroState)),
        settingsProvider.overrideWith((ref) => SettingsNotifier(pomodoroDao, initialSettings, ref)),
        profileProvider.overrideWith((ref) => ProfileNotifier(profileDao, initialProfile)),
      ],
      child: HaveToStudyApp(router: router),
    ),
  );
}

class HaveToStudyApp extends ConsumerWidget {
  final GoRouter router;

  const HaveToStudyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    ThemeMode themeMode;
    switch (settings.themePreference) {
      case AppThemePreference.light:
        themeMode = ThemeMode.light;
        break;
      case AppThemePreference.dark:
        themeMode = ThemeMode.dark;
        break;
      case AppThemePreference.system:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: 'Have to Study',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final colors = context.colors;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: colors.surface,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
          child: child!,
        );
      },
    );
  }
}
