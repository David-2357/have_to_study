import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:have_to_study/main.dart';
import 'package:have_to_study/core/providers.dart';
import 'package:have_to_study/data/database/app_database.dart';
import 'package:have_to_study/data/database/daos/subjects_dao.dart';
import 'package:have_to_study/data/database/daos/academic_events_dao.dart';
import 'package:have_to_study/data/database/daos/focus_sessions_dao.dart';
import 'package:have_to_study/data/database/daos/pomodoro_dao.dart';
import 'package:have_to_study/data/database/daos/profile_dao.dart';

void main() {
  testWidgets('App initializes with Drift/SQLite and displays Pomodoro screen', (WidgetTester tester) async {
    // Base de datos en memoria para pruebas
    final db = AppDatabase(NativeDatabase.memory());

    final subjectsDao = SubjectsDao(db);
    final eventsDao = AcademicEventsDao(db);
    final sessionsDao = FocusSessionsDao(db);
    final pomodoroDao = PomodoroDao(db);
    final profileDao = ProfileDao(db);

    final initialSubjects = await subjectsDao.getAllSubjects();
    final initialEvents = await eventsDao.getAllEvents();
    final initialSessions = await sessionsDao.getAllSessions();
    final initialPomodoroState = await pomodoroDao.getStateWithDeterministicRecovery();
    final initialSettings = await pomodoroDao.getSettings();
    final initialProfile = await profileDao.getProfile();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          subjectsProvider.overrideWith((ref) => SubjectsNotifier(subjectsDao, initialSubjects)),
          academicEventsProvider.overrideWith((ref) => AcademicEventsNotifier(eventsDao, initialEvents)),
          focusSessionsProvider.overrideWith((ref) => FocusSessionsNotifier(sessionsDao, initialSessions)),
          pomodoroProvider.overrideWith((ref) => PomodoroNotifier(pomodoroDao, ref, initialPomodoroState)),
          settingsProvider.overrideWith((ref) => SettingsNotifier(pomodoroDao, initialSettings)),
          profileProvider.overrideWith((ref) => ProfileNotifier(profileDao, initialProfile)),
        ],
        child: const HaveToStudyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify app title and main components appear
    expect(find.text('Have to study'), findsWidgets);
    expect(find.text('POMODORO ACTIVO'), findsOneWidget);
    expect(find.text('Iniciar Enfoque'), findsOneWidget);

    await db.close();
  });
}
