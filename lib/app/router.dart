import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_navigation_scaffold.dart';
import '../features/pomodoro/presentation/pomodoro_screen.dart';
import '../features/pomodoro/presentation/active_session_screen.dart';
import '../features/subjects/presentation/studies_screen.dart';
import '../features/subjects/presentation/create_subject_screen.dart';
import '../features/subjects/presentation/subject_detail_screen.dart';
import '../features/subjects/presentation/course_closure_screen.dart';
import '../features/calendar/presentation/calendar_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/splash/presentation/splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createAppRouter({String initialLocation = '/splash'}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Rama 1: Pomodoro
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pomodoro',
                builder: (context, state) => const PomodoroScreen(),
              ),
            ],
          ),

          // Rama 2: Estudios
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/studies',
                builder: (context, state) => const StudiesScreen(),
              ),
            ],
          ),

          // Rama 3: Calendario
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),

          // Rama 4: Estadísticas
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/statistics',
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Pantalla de bienvenida / Splash
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final next = state.uri.queryParameters['next'];
          return SplashScreen(nextRoute: next);
        },
      ),

      // Asistente de inicio (Onboarding)
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Rutas de pantalla completa / secundarias
      GoRoute(
        path: '/session',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ActiveSessionScreen(),
      ),
      GoRoute(
        path: '/create-subject',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          return CreateSubjectScreen(subjectId: id);
        },
      ),
      GoRoute(
        path: '/subject-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final subjectId = state.uri.queryParameters['id'] ?? '';
          return SubjectDetailScreen(subjectId: subjectId);
        },
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/course-closure',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final onlyExpired = state.uri.queryParameters['onlyExpired'] == 'true';
          return CourseClosureScreen(onlyExpired: onlyExpired);
        },
      ),
    ],
  );
}

final appRouter = createAppRouter();
