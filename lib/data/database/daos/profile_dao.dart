import 'package:drift/drift.dart';
import '../app_database.dart';
import '../../../features/profile/domain/profile_model.dart';

class ProfileDao {
  final AppDatabase _db;

  ProfileDao(this._db);

  Future<StudentProfileModel> getProfile() async {
    final row = await (_db.select(_db.studentProfileEntries)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) {
      return StudentProfileModel();
    }
    return StudentProfileModel(
      displayName: row.displayName,
      degreeName: row.degreeName,
      academicPeriod: row.academicPeriod,
      semester: row.semester,
      avatarPath: row.avatarPath,
    );
  }

  Future<void> saveProfile(StudentProfileModel profile) async {
    await _db.into(_db.studentProfileEntries).insertOnConflictUpdate(
      StudentProfileEntriesCompanion(
        id: const Value(1),
        displayName: Value(profile.displayName),
        degreeName: Value(profile.degreeName),
        academicPeriod: Value(profile.academicPeriod),
        semester: Value(profile.semester),
        avatarPath: Value(profile.avatarPath),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
