import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers.dart';
import '../../features/subjects/domain/subject_model.dart';
import '../../features/academic_events/domain/academic_event_model.dart';
import '../../features/pomodoro/domain/pomodoro_models.dart';
import '../../features/profile/domain/profile_model.dart';
import '../../features/settings/domain/settings_models.dart';

class BackupService {
  static const String localBackupFileName = 'have_to_study_local_backup.json';
  static const String keyAutoBackupEnabled = 'auto_backup_enabled';
  static const String keyAutoBackupDays = 'auto_backup_days';
  static const String keyLastAutoBackup = 'last_auto_backup_timestamp';

  // Métodos de compatibilidad previa
  static Future<File> exportBackupToFile(WidgetRef ref) => createLocalBackup(ref);
  static Future<File?> getBackupFileIfExists() => getLocalBackupFile();

  // ==========================================
  // CONFIGURACIÓN DE COPIA AUTOMÁTICA
  // ==========================================
  static Future<bool> isAutoBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAutoBackupEnabled) ?? true;
  }

  static Future<void> setAutoBackupEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAutoBackupEnabled, enabled);
  }

  static Future<int> getAutoBackupDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyAutoBackupDays) ?? 20; // 20 días por defecto
  }

  static Future<void> setAutoBackupDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyAutoBackupDays, days.clamp(1, 90));
  }

  static Future<DateTime?> getLastAutoBackupDate() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(keyLastAutoBackup);
    if (str != null && str.isNotEmpty) {
      return DateTime.tryParse(str);
    }
    return null;
  }

  // Verifica y ejecuta la copia automática si han pasado los X días
  static Future<bool> checkAndPerformAutoBackup(WidgetRef ref) async {
    try {
      final enabled = await isAutoBackupEnabled();
      if (!enabled) return false;

      final intervalDays = await getAutoBackupDays();
      final lastBackup = await getLastAutoBackupDate();
      final now = DateTime.now();

      if (lastBackup == null || now.difference(lastBackup).inDays >= intervalDays) {
        await createLocalBackup(ref);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(keyLastAutoBackup, now.toIso8601String());
        return true;
      }
    } catch (_) {}
    return false;
  }

  // ==========================================
  // GENERACIÓN DE DATOS JSON
  // ==========================================
  static Future<String> getBackupJsonString(WidgetRef ref) async {
    final subjects = ref.read(subjectsProvider);
    final events = ref.read(academicEventsProvider);
    final sessions = ref.read(focusSessionsProvider);
    final profile = ref.read(profileProvider);
    final settings = ref.read(settingsProvider);

    final data = {
      'app': 'Have to Study',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'subjects': subjects.map((s) => s.toJson()).toList(),
      'academicEvents': events.map((e) => e.toJson()).toList(),
      'focusSessions': sessions.map((s) => s.toJson()).toList(),
      'profile': profile.toJson(),
      'settings': settings.toJson(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  // ==========================================
  // COPIAS DE SEGURIDAD LOCALES (INSTANTÁNEAS)
  // ==========================================
  static Future<File> createLocalBackup(WidgetRef ref) async {
    final jsonStr = await getBackupJsonString(ref);
    final appDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(appDir.path, localBackupFileName));
    await file.writeAsString(jsonStr);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastAutoBackup, DateTime.now().toIso8601String());
    return file;
  }

  static Future<File?> getLocalBackupFile() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File(p.join(appDir.path, localBackupFileName));
      if (await file.exists()) {
        return file;
      }
    } catch (_) {}
    return null;
  }

  static Future<void> restoreFromLocalBackup(WidgetRef ref) async {
    final file = await getLocalBackupFile();
    if (file == null || !await file.exists()) {
      throw Exception('No se encontró archivo de copia de seguridad local.');
    }
    final jsonStr = await file.readAsString();
    await restoreFromJsonString(ref, jsonStr);
  }

  // ==========================================
  // EXPORTAR BASE DE DATOS SQLITE (.SQLITE) CON SHARE
  // ==========================================
  static Future<void> exportAndShareSqliteDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(appDir.path, 'have_to_study.sqlite'));

    if (!await dbFile.exists()) {
      throw Exception('El archivo de la base de datos no existe.');
    }

    // Crear una copia temporal con fecha en el nombre para compartir
    final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final tempDir = await getTemporaryDirectory();
    final exportFile = File(p.join(tempDir.path, 'have_to_study_database_$dateStr.sqlite'));
    await dbFile.copy(exportFile.path);

    final xfile = XFile(
      exportFile.path,
      name: 'have_to_study_database_$dateStr.sqlite',
      mimeType: 'application/x-sqlite3',
    );

    await Share.shareXFiles(
      [xfile],
      subject: 'Base de datos Have to Study ($dateStr)',
      text: 'Copia de seguridad física de la base de datos SQLite de Have to Study.',
    );
  }

  // ==========================================
  // EXPORTAR ARCHIVO JSON (.JSON) CON SHARE
  // ==========================================
  static Future<void> exportAndShareJson(WidgetRef ref) async {
    final jsonStr = await getBackupJsonString(ref);
    final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final tempDir = await getTemporaryDirectory();
    final exportFile = File(p.join(tempDir.path, 'have_to_study_backup_$dateStr.json'));
    await exportFile.writeAsString(jsonStr);

    final xfile = XFile(
      exportFile.path,
      name: 'have_to_study_backup_$dateStr.json',
      mimeType: 'application/json',
    );

    await Share.shareXFiles(
      [xfile],
      subject: 'Copia de seguridad Have to Study ($dateStr)',
      text: 'Exportación completa de datos de Have to Study en formato JSON.',
    );
  }

  // ==========================================
  // IMPORTAR DESDE ARCHIVO JSON (.JSON)
  // ==========================================
  static Future<Map<String, dynamic>?> pickJsonFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result.isEmpty) {
      return null;
    }

    final path = result.first.path;
    if (path == null) {
      throw Exception('No se pudo acceder a la ruta del archivo seleccionado.');
    }

    final file = File(path);
    final jsonStr = await file.readAsString();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    return {
      'path': path,
      'name': result.first.name,
      'json': jsonStr,
      'data': data,
    };
  }

  // ==========================================
  // RESTAURACIÓN EN LA BASE DE DATOS
  // ==========================================
  static Future<void> restoreFromJsonString(WidgetRef ref, String jsonStr) async {
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    final subjectsDao = ref.read(subjectsDaoProvider);
    final eventsDao = ref.read(academicEventsDaoProvider);
    final sessionsDao = ref.read(focusSessionsDaoProvider);
    final profileDao = ref.read(profileDaoProvider);
    final pomodoroDao = ref.read(pomodoroDaoProvider);

    // Restaurar materias
    if (data['subjects'] is List) {
      final subjectsList = (data['subjects'] as List)
          .map((item) => SubjectModel.fromJson(item as Map<String, dynamic>))
          .toList();
      for (final s in subjectsList) {
        await subjectsDao.insertSubject(s);
      }
    }

    // Restaurar eventos / tareas
    if (data['academicEvents'] is List) {
      final eventsList = (data['academicEvents'] as List)
          .map((item) => AcademicEventModel.fromJson(item as Map<String, dynamic>))
          .toList();
      for (final e in eventsList) {
        await eventsDao.insertEvent(e);
      }
    }

    // Restaurar sesiones de concentración
    if (data['focusSessions'] is List) {
      final sessionsList = (data['focusSessions'] as List)
          .map((item) => FocusSessionModel.fromJson(item as Map<String, dynamic>))
          .toList();
      for (final s in sessionsList) {
        await sessionsDao.insertSession(s);
      }
    }

    // Restaurar perfil
    if (data['profile'] is Map) {
      final profile = StudentProfileModel.fromJson(data['profile'] as Map<String, dynamic>);
      await profileDao.saveProfile(profile);
    }

    // Restaurar ajustes
    if (data['settings'] is Map) {
      final settings = PomodoroSettingsModel.fromJson(data['settings'] as Map<String, dynamic>);
      await pomodoroDao.saveSettings(settings);
    }

    // Recargar notifiers
    await ref.read(subjectsProvider.notifier).reload();
    await ref.read(academicEventsProvider.notifier).reload();
    await ref.read(focusSessionsProvider.notifier).reload();
    await ref.read(profileProvider.notifier).reload();
    await ref.read(settingsProvider.notifier).reload();
  }
}
