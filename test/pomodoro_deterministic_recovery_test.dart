import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:have_to_study/data/database/app_database.dart';
import 'package:have_to_study/data/database/daos/pomodoro_dao.dart';
import 'package:have_to_study/features/pomodoro/domain/pomodoro_models.dart';

void main() {
  group('Pomodoro Deterministic Time Recovery Tests', () {
    late AppDatabase db;
    late PomodoroDao pomodoroDao;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      pomodoroDao = PomodoroDao(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Recovers remaining seconds deterministically when app was in background', () async {
      final now = DateTime.now();
      // Simular que hace 5 minutos (300s) el temporizador estaba corriendo con 25 min (1500s)
      final pastResumeTime = now.subtract(const Duration(minutes: 5));

      final stateBefore = PomodoroStateModel(
        phase: PomodoroPhase.focus,
        status: PomodoroStatus.running,
        remainingSeconds: 1500,
        totalSeconds: 1500,
      );

      await pomodoroDao.persistState(
        state: stateBefore,
        lastResumedAt: pastResumeTime,
      );

      // Recuperar estado calculando el delta transcurrido
      final recovered = await pomodoroDao.getStateWithDeterministicRecovery();

      // Debe haber descontado ~300 segundos (tolerancia de 2 segundos por ejecución)
      expect(recovered.remainingSeconds, inInclusiveRange(1198, 1200));
      expect(recovered.status, equals(PomodoroStatus.running));
    });

    test('Marks phase as finished deterministically if time exceeded while app was closed', () async {
      final now = DateTime.now();
      // Simular que hace 30 minutos se inició una fase de 25 min (1500s)
      final pastResumeTime = now.subtract(const Duration(minutes: 30));

      final stateBefore = PomodoroStateModel(
        phase: PomodoroPhase.focus,
        status: PomodoroStatus.running,
        remainingSeconds: 1500,
        totalSeconds: 1500,
      );

      await pomodoroDao.persistState(
        state: stateBefore,
        lastResumedAt: pastResumeTime,
      );

      final recovered = await pomodoroDao.getStateWithDeterministicRecovery();

      // Los segundos deben haber llegado a 0 y el estado debe ser idle
      expect(recovered.remainingSeconds, equals(0));
      expect(recovered.status, equals(PomodoroStatus.idle));
    });
  });
}
