import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../features/pomodoro/domain/pomodoro_models.dart';

class FocusSessionsDao {
  final AppDatabase _db;

  FocusSessionsDao(this._db);

  FocusSessionModel _toModel(FocusSession row) {
    return FocusSessionModel(
      id: row.id,
      subjectId: row.subjectId,
      academicEventId: row.academicEventId,
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      durationSeconds: row.durationSeconds,
    );
  }

  Future<List<FocusSessionModel>> getAllSessions() async {
    final rows = await (_db.select(_db.focusSessions)
          ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Stream<List<FocusSessionModel>> watchAllSessions() {
    return (_db.select(_db.focusSessions)
          ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map(_toModel).toList());
  }

  Future<List<FocusSessionModel>> getSessionsBySubject(String subjectId) async {
    final rows = await (_db.select(_db.focusSessions)
          ..where((t) => t.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<List<FocusSessionModel>> getSessionsBetween(DateTime start, DateTime end) async {
    final rows = await (_db.select(_db.focusSessions)
          ..where((t) => t.completedAt.isBiggerOrEqualValue(start) & t.completedAt.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<List<FocusSessionModel>> getSessionsByEvent(String eventId) async {
    final rows = await (_db.select(_db.focusSessions)
          ..where((t) => t.academicEventId.equals(eventId))
          ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<void> insertSession(FocusSessionModel session) async {
    await _db.into(_db.focusSessions).insertOnConflictUpdate(
      FocusSessionsCompanion.insert(
        id: session.id,
        subjectId: Value(session.subjectId),
        academicEventId: Value(session.academicEventId),
        startedAt: session.startedAt,
        completedAt: session.completedAt,
        durationSeconds: session.durationSeconds,
        status: const Value('completed'),
      ),
    );
  }

  Future<void> deleteSession(String id) async {
    await (_db.delete(_db.focusSessions)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateSession(FocusSessionModel session) async {
    await (_db.update(_db.focusSessions)..where((t) => t.id.equals(session.id))).write(
      FocusSessionsCompanion(
        subjectId: Value(session.subjectId),
        academicEventId: Value(session.academicEventId),
        startedAt: Value(session.startedAt),
        completedAt: Value(session.completedAt),
        durationSeconds: Value(session.durationSeconds),
        status: const Value('completed'),
      ),
    );
  }
}
