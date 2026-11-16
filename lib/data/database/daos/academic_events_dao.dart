import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../features/academic_events/domain/academic_event_model.dart';

class AcademicEventsDao {
  final AppDatabase _db;

  AcademicEventsDao(this._db);

  AcademicEventModel _toModel(AcademicEvent row) {
    return AcademicEventModel(
      id: row.id,
      subjectId: row.subjectId,
      title: row.title,
      type: EventType.values.firstWhere(
        (e) => e.name == row.type,
        orElse: () => EventType.exam,
      ),
      description: row.description,
      dueAt: row.dueAt,
      hasDueTime: row.hasDueTime,
      targetPomodoros: row.targetPomodoros,
      completedPomodoros: row.completedPomodoros,
      isCompleted: row.isCompleted,
      academicWeight: row.academicWeight,
      isPriority: row.isPriority,
    );
  }

  Future<List<AcademicEventModel>> getAllEvents() async {
    final rows = await (_db.select(_db.academicEvents)
          ..orderBy([(t) => OrderingTerm(expression: t.dueAt, mode: OrderingMode.asc)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Stream<List<AcademicEventModel>> watchAllEvents() {
    return (_db.select(_db.academicEvents)
          ..orderBy([(t) => OrderingTerm(expression: t.dueAt, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map(_toModel).toList());
  }

  Future<AcademicEventModel?> getEventById(String id) async {
    final row = await (_db.select(_db.academicEvents)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<List<AcademicEventModel>> getEventsBySubject(String subjectId) async {
    final rows = await (_db.select(_db.academicEvents)
          ..where((t) => t.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm(expression: t.dueAt, mode: OrderingMode.asc)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<void> insertEvent(AcademicEventModel event) async {
    await _db.into(_db.academicEvents).insertOnConflictUpdate(
      AcademicEventsCompanion.insert(
        id: event.id,
        subjectId: event.subjectId,
        title: event.title,
        type: event.type.name,
        description: Value(event.description),
        dueAt: event.dueAt,
        hasDueTime: Value(event.hasDueTime),
        targetPomodoros: Value(event.targetPomodoros),
        completedPomodoros: Value(event.completedPomodoros),
        isCompleted: Value(event.isCompleted),
        academicWeight: Value(event.academicWeight),
        isPriority: Value(event.isPriority),
      ),
    );
  }

  Future<void> updateEvent(AcademicEventModel event) async {
    await (_db.update(_db.academicEvents)..where((t) => t.id.equals(event.id))).write(
      AcademicEventsCompanion(
        subjectId: Value(event.subjectId),
        title: Value(event.title),
        type: Value(event.type.name),
        description: Value(event.description),
        dueAt: Value(event.dueAt),
        hasDueTime: Value(event.hasDueTime),
        targetPomodoros: Value(event.targetPomodoros),
        completedPomodoros: Value(event.completedPomodoros),
        isCompleted: Value(event.isCompleted),
        academicWeight: Value(event.academicWeight),
        isPriority: Value(event.isPriority),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> toggleComplete(String id) async {
    final current = await getEventById(id);
    if (current != null) {
      await updateEvent(current.copyWith(isCompleted: !current.isCompleted));
    }
  }

  Future<void> incrementEventPomodoro(String eventId, [int amount = 1]) async {
    final current = await getEventById(eventId);
    if (current != null) {
      await updateEvent(
        current.copyWith(completedPomodoros: current.completedPomodoros + amount),
      );
    }
  }

  Future<void> deleteEvent(String id) async {
    await (_db.delete(_db.academicEvents)..where((t) => t.id.equals(id))).go();
  }
}
