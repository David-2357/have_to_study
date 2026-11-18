import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../features/subjects/domain/subject_model.dart';

class SubjectsDao {
  final AppDatabase _db;

  SubjectsDao(this._db);

  SubjectModel _toModel(Subject row) {
    final parsed = SubjectModel.parsePeriodString(row.period);
    return SubjectModel(
      id: row.id,
      name: row.name,
      code: row.code,
      period: row.period,
      iconKey: row.iconKey,
      colorValue: row.colorValue,
      isArchived: row.isArchived,
      isPassed: parsed.isPassed,
      isAnnual: parsed.isAnnual,
      startDate: parsed.startDate,
      endDate: parsed.endDate,
      totalStudySeconds: row.totalStudySeconds,
      lastStudiedAt: row.lastStudiedAt,
      completedPomodoros: row.completedPomodoros,
    );
  }

  Future<List<SubjectModel>> getAllSubjects() async {
    final rows = await _db.select(_db.subjects).get();
    return rows.map(_toModel).toList();
  }

  Stream<List<SubjectModel>> watchAllSubjects() {
    return _db.select(_db.subjects).watch().map((rows) => rows.map(_toModel).toList());
  }

  Future<SubjectModel?> getSubjectById(String id) async {
    final row = await (_db.select(_db.subjects)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  Future<void> insertSubject(SubjectModel subject) async {
    final periodStr = SubjectModel.formatPeriodString(
      isAnnual: subject.isAnnual,
      startDate: subject.startDate,
      endDate: subject.endDate,
      isPassed: subject.isPassed,
    );
    await _db.into(_db.subjects).insertOnConflictUpdate(
      SubjectsCompanion.insert(
        id: subject.id,
        name: subject.name,
        code: Value(subject.code),
        period: Value(periodStr),
        iconKey: Value(subject.iconKey),
        colorValue: subject.colorValue,
        isArchived: Value(subject.isArchived),
        totalStudySeconds: Value(subject.totalStudySeconds),
        lastStudiedAt: Value(subject.lastStudiedAt),
        completedPomodoros: Value(subject.completedPomodoros),
      ),
    );
  }

  Future<void> updateSubject(SubjectModel subject) async {
    final periodStr = SubjectModel.formatPeriodString(
      isAnnual: subject.isAnnual,
      startDate: subject.startDate,
      endDate: subject.endDate,
      isPassed: subject.isPassed,
    );
    await (_db.update(_db.subjects)..where((t) => t.id.equals(subject.id))).write(
      SubjectsCompanion(
        name: Value(subject.name),
        code: Value(subject.code),
        period: Value(periodStr),
        iconKey: Value(subject.iconKey),
        colorValue: Value(subject.colorValue),
        isArchived: Value(subject.isArchived),
        totalStudySeconds: Value(subject.totalStudySeconds),
        lastStudiedAt: Value(subject.lastStudiedAt),
        completedPomodoros: Value(subject.completedPomodoros),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> toggleArchive(String id) async {
    final current = await getSubjectById(id);
    if (current != null) {
      await updateSubject(current.copyWith(isArchived: !current.isArchived));
    }
  }

  Future<void> togglePassed(String id) async {
    final current = await getSubjectById(id);
    if (current != null) {
      await updateSubject(current.copyWith(isPassed: !current.isPassed));
    }
  }

  Future<void> addStudyTime(String subjectId, int seconds, [int pomodorosToAdd = 0]) async {
    final current = await getSubjectById(subjectId);
    if (current != null) {
      await updateSubject(
        current.copyWith(
          totalStudySeconds: current.totalStudySeconds + seconds,
          completedPomodoros: current.completedPomodoros + pomodorosToAdd,
          lastStudiedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> deleteSubject(String id) async {
    await (_db.delete(_db.subjects)..where((t) => t.id.equals(id))).go();
  }
}
