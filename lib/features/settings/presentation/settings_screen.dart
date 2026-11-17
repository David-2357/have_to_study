import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../core/providers.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/services/audio_feedback_service.dart';
import '../domain/settings_models.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  AppColorTheme get colors => context.colors;
  bool _autoBackupEnabled = true;
  int _autoBackupDays = 20;
  DateTime? _lastAutoBackupDate;
  File? _localBackupFile;

  @override
  void initState() {
    super.initState();
    _loadBackupSettings();
  }

  Future<void> _loadBackupSettings() async {
    final enabled = await BackupService.isAutoBackupEnabled();
    final days = await BackupService.getAutoBackupDays();
    final lastDate = await BackupService.getLastAutoBackupDate();
    final file = await BackupService.getLocalBackupFile();
    if (mounted) {
      setState(() {
        _autoBackupEnabled = enabled;
        _autoBackupDays = days;
        _lastAutoBackupDate = lastDate;
        _localBackupFile = file;
      });
    }
  }

  Future<void> _handleCreateLocalBackup() async {
    try {
      await BackupService.createLocalBackup(ref);
      await _loadBackupSettings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copia de seguridad local creada (${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}).'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF0D9488),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear copia local: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleRestoreLocalBackup() async {
    final file = _localBackupFile ?? await BackupService.getLocalBackupFile();
    if (file == null || !await file.exists()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró ninguna copia de seguridad local en el dispositivo.')),
        );
      }
      return;
    }

    final lastModified = await file.lastModified();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(lastModified);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Restaurar Copia Local', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Se restaurarán los datos desde la última copia de seguridad local guardada:\n\n• Fecha: $formattedDate\n• Archivo: ${p.basename(file.path)}\n\n¿Deseas sobreescribir los datos actuales?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  await BackupService.restoreFromLocalBackup(ref);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Copia de seguridad local restaurada exitosamente!'),
                      backgroundColor: Color(0xFF0D9488),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al restaurar: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Restaurar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleExportJson() async {
    try {
      await BackupService.exportAndShareJson(ref);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar JSON: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleImportJson() async {
    try {
      final result = await BackupService.pickJsonFile();
      if (result == null) return;

      final fileName = result['name'] as String? ?? 'archivo.json';
      final jsonStr = result['json'] as String;
      final data = result['data'] as Map<String, dynamic>;

      final subjectsCount = (data['subjects'] as List?)?.length ?? 0;
      final eventsCount = (data['academicEvents'] as List?)?.length ?? 0;
      final sessionsCount = (data['focusSessions'] as List?)?.length ?? 0;

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Importar Archivo JSON', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Archivo: $fileName', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Text('Contenido detectado:'),
                const SizedBox(height: 6),
                Text('• $subjectsCount asignaturas'),
                Text('• $eventsCount pendientes / eventos'),
                Text('• $sessionsCount sesiones de estudio'),
                const SizedBox(height: 14),
                const Text(
                  '¿Deseas restaurar e importar estos datos en la aplicación?',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  try {
                    await BackupService.restoreFromJsonString(ref, jsonStr);
                    await _loadBackupSettings();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Datos importados con éxito desde $fileName!'),
                        backgroundColor: const Color(0xFF0D9488),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al importar: $e'), backgroundColor: Colors.red),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Importar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar archivo: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
          label: const Text('Volver', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        leadingWidth: 100,
        title: Text('Ajustes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
        actions: [
          Icon(Icons.settings_outlined, color: colors.textPrimary),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacidad Soberana Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: colors.isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF0D2924), Color(0xFF133630)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFE6FFFA), Color(0xFFF0FDF4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colors.isDark ? const Color(0xFF115E59) : const Color(0xFFB2F5EA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shield_rounded,
                              color: colors.isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0F766E),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Privacidad\nSoberana',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: colors.isDark ? const Color(0xFF5EEAD4) : const Color(0xFF134E4A),
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2DD4BF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'OFFLINE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF134E4A),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tus notas, estadísticas y sesiones se guardan únicamente en el almacenamiento interno de este dispositivo. Sin servidores remotos, sin rastreo y sin conexión obligatoria.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.isDark ? const Color(0xFFCCFBF1) : const Color(0xFF115E59),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Meta Diaria
              _buildSectionHeader(Icons.flag_rounded, 'Meta Diaria', AppColors.primary),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meta diaria de estudio',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Objetivo de horas de estudio para\nestadísticas y ritmo semanal',
                          style: TextStyle(fontSize: 11, color: colors.textSecondary),
                        ),
                      ],
                    ),
                    _buildStepper(
                      value: '${settings.dailyGoalHours} h',
                      onDecrement: () {
                        if (settings.dailyGoalHours > 1) {
                          notifier.updateSettings(settings.copyWith(dailyGoalHours: settings.dailyGoalHours - 1));
                        }
                      },
                      onIncrement: () {
                        if (settings.dailyGoalHours < 24) {
                          notifier.updateSettings(settings.copyWith(dailyGoalHours: settings.dailyGoalHours + 1));
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Temporizador de Enfoque
              _buildSectionHeader(Icons.timer_outlined, 'Temporizador de Enfoque', AppColors.primary),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    _buildSettingStepperRow(
                      title: 'Sesión de estudio',
                      subtitle: 'Bloque de alta concentración',
                      value: '${settings.focusMinutes} min',
                      onDecrement: () {
                        if (settings.focusMinutes > 5) {
                          notifier.updateSettings(settings.copyWith(focusMinutes: settings.focusMinutes - 5));
                        }
                      },
                      onIncrement: () {
                        notifier.updateSettings(settings.copyWith(focusMinutes: settings.focusMinutes + 5));
                      },
                    ),
                    const Divider(height: 20),
                    _buildSettingStepperRow(
                      title: 'Descanso corto',
                      subtitle: 'Pausa para hidratación o estiramiento',
                      value: '${settings.shortBreakMinutes} min',
                      onDecrement: () {
                        if (settings.shortBreakMinutes > 1) {
                          notifier.updateSettings(settings.copyWith(shortBreakMinutes: settings.shortBreakMinutes - 1));
                        }
                      },
                      onIncrement: () {
                        notifier.updateSettings(settings.copyWith(shortBreakMinutes: settings.shortBreakMinutes + 1));
                      },
                    ),
                    const Divider(height: 20),
                    _buildSettingStepperRow(
                      title: 'Descanso largo',
                      subtitle: 'Recuperación profunda de fatiga cognitiva',
                      value: '${settings.longBreakMinutes} min',
                      onDecrement: () {
                        if (settings.longBreakMinutes > 5) {
                          notifier.updateSettings(settings.copyWith(longBreakMinutes: settings.longBreakMinutes - 5));
                        }
                      },
                      onIncrement: () {
                        notifier.updateSettings(settings.copyWith(longBreakMinutes: settings.longBreakMinutes + 5));
                      },
                    ),
                    const Divider(height: 20),
                    _buildSettingStepperRow(
                      title: 'Ciclos por ronda',
                      subtitle: 'Sesiones antes del descanso largo',
                      value: '${settings.cyclesBeforeLongBreak}',
                      onDecrement: () {
                        if (settings.cyclesBeforeLongBreak > 1) {
                          notifier.updateSettings(settings.copyWith(cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak - 1));
                        }
                      },
                      onIncrement: () {
                        if (settings.cyclesBeforeLongBreak < 16) {
                          notifier.updateSettings(settings.copyWith(cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak + 1));
                        }
                      },
                    ),
                    const Divider(height: 20),
                    _buildSettingSwitchRow(
                      title: 'Iniciar descanso automáticamente',
                      subtitle: 'Transición inmediata sin tocar la pantalla',
                      value: settings.autoStartBreaks,
                      onChanged: (val) {
                        notifier.updateSettings(settings.copyWith(autoStartBreaks: val));
                      },
                    ),
                    const Divider(height: 20),
                    _buildSettingSwitchRow(
                      title: 'Iniciar siguiente pomodoro automáticamente',
                      subtitle: 'Mantén una inercia continua de estudio',
                      value: settings.autoStartFocus,
                      onChanged: (val) {
                        notifier.updateSettings(settings.copyWith(autoStartFocus: val));
                      },
                    ),
                    const Divider(height: 20),
                    _buildSettingSwitchRow(
                      title: 'Prevenir bloqueo de pantalla',
                      subtitle: 'Mantiene el dial visible durante el ciclo',
                      value: settings.preventScreenLock,
                      onChanged: (val) {
                        notifier.updateSettings(settings.copyWith(preventScreenLock: val));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Sonidos y Notificaciones
              _buildSectionHeader(Icons.volume_up_rounded, 'Sonidos y Notificaciones', const Color(0xFF4F46E5)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Alarma de finalización',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                        ),
                        InkWell(
                          onTap: () {
                            AudioFeedbackService().playTone(settings.completionSound);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Probar sonido',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Campana zen', 'Cuenco tibetano', 'Tono suave'].map((sound) {
                        final isSelected = settings.completionSound == sound;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                notifier.updateSettings(settings.copyWith(completionSound: sound));
                                AudioFeedbackService().playTone(sound);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected ? AppColors.primary : colors.surfaceVariant,
                                foregroundColor: isSelected ? Colors.white : colors.textPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              child: Text(sound, textAlign: TextAlign.center, maxLines: 1),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aviso de asignatura desatendida',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: colors.textPrimary),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Alerta si pasan días sin sesiones en una materia activa',
                              style: TextStyle(fontSize: 11, color: colors.textSecondary),
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: settings.notifyUnattendedSubjects,
                          activeThumbColor: AppColors.primary,
                          onChanged: (val) {
                            notifier.updateSettings(settings.copyWith(notifyUnattendedSubjects: val));
                          },
                        ),
                      ],
                    ),
                    if (settings.notifyUnattendedSubjects) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [3, 5, 7].map((days) {
                          final isSelected = settings.unattendedDaysThreshold == days;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                onPressed: () {
                                  notifier.updateSettings(settings.copyWith(unattendedDaysThreshold: days));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? AppColors.primary
                                      : (colors.isDark ? colors.surfaceVariant : const Color(0xFFEEF2FF)),
                                  foregroundColor: isSelected
                                      ? Colors.white
                                      : (colors.isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                child: Text('$days días', textAlign: TextAlign.center),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Gestión Académica y Fin de Curso
              _buildSectionHeader(Icons.school_rounded, 'Gestión Académica y Fin de Curso', const Color(0xFF4F46E5)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.isDark
                              ? const Color(0xFF4F46E5).withValues(alpha: 0.22)
                              : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.fact_check_rounded,
                          color: colors.isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                          size: 22,
                        ),
                      ),
                      title: const Text(
                        'Cierre de Fin de Curso',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        'Revisa y clasifica tus asignaturas para determinar cuáles continúan el próximo ciclo y cuáles has aprobado o finalizado.',
                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colors.textSecondary),
                      onTap: () => context.push('/course-closure'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Copias de Seguridad y Almacenamiento
              _buildSectionHeader(Icons.backup_rounded, 'Copias de Seguridad y Almacenamiento', const Color(0xFF0F766E)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    // --- 1. COPIA AUTOMÁTICA PERIÓDICA ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: colors.isDark
                                          ? const Color(0xFF0D9488).withValues(alpha: 0.22)
                                          : const Color(0xFFE6FFFA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.sync_rounded,
                                      color: colors.isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Copia automática periódica',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        _autoBackupEnabled
                                            ? 'Cada $_autoBackupDays días se creará una copia interna'
                                            : 'Copia automática desactivada',
                                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Switch(
                                value: _autoBackupEnabled,
                                activeThumbColor: Colors.white,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) async {
                                  await BackupService.setAutoBackupEnabled(val);
                                  setState(() => _autoBackupEnabled = val);
                                },
                              ),
                            ],
                          ),
                          if (_autoBackupEnabled) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Frecuencia de respaldo',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        _lastAutoBackupDate != null
                                            ? 'Última: ${DateFormat('dd/MM/yyyy HH:mm').format(_lastAutoBackupDate!)}'
                                            : 'Pendiente de realizar la primera copia',
                                        style: TextStyle(fontSize: 10, color: colors.textSecondary),
                                      ),
                                    ],
                                  ),
                                  _buildStepper(
                                    value: '$_autoBackupDays d',
                                    onDecrement: () async {
                                      if (_autoBackupDays > 5) {
                                        final newDays = _autoBackupDays - 5;
                                        await BackupService.setAutoBackupDays(newDays);
                                        setState(() => _autoBackupDays = newDays);
                                      }
                                    },
                                    onIncrement: () async {
                                      if (_autoBackupDays < 90) {
                                        final newDays = _autoBackupDays + 5;
                                        await BackupService.setAutoBackupDays(newDays);
                                        setState(() => _autoBackupDays = newDays);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // --- 2. COPIA DE SEGURIDAD LOCAL (MANTENIDA) ---
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.isDark
                              ? const Color(0xFF16A34A).withValues(alpha: 0.22)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.save_rounded,
                          color: colors.isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                          size: 20,
                        ),
                      ),
                      title: const Text('Crear copia de seguridad local', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        _localBackupFile != null
                            ? 'Instantánea guardada en el dispositivo'
                            : 'Crea un punto de respaldo interno en tu teléfono',
                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      ),
                      trailing: Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
                      onTap: _handleCreateLocalBackup,
                    ),

                    const Divider(height: 1),

                    // --- 3. RESTAURAR COPIA LOCAL (MANTENIDA) ---
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.isDark
                              ? const Color(0xFF4F46E5).withValues(alpha: 0.22)
                              : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.settings_backup_restore_rounded,
                          color: colors.isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                          size: 20,
                        ),
                      ),
                      title: const Text('Restaurar copia de seguridad local', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text('Restaura la última instantánea guardada en la app', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                      trailing: Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
                      onTap: _handleRestoreLocalBackup,
                    ),

                    const Divider(height: 1),

                    // --- 4. EXPORTAR DATOS A JSON (.JSON) CON SHARE ---
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.isDark
                              ? const Color(0xFF9333EA).withValues(alpha: 0.22)
                              : const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.file_download_outlined,
                          color: colors.isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                          size: 20,
                        ),
                      ),
                      title: const Text('Exportar como archivo JSON (.json)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text('Exporta asignaturas, tareas y sesiones en formato JSON transferible', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                      trailing: Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
                      onTap: _handleExportJson,
                    ),

                    const Divider(height: 1),

                    // --- 6. IMPORTAR DATOS DESDE JSON (.JSON) ---
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.file_upload_outlined, color: Color(0xFFD97706), size: 20),
                      ),
                      title: const Text('Importar desde archivo JSON (.json)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text('Selecciona un archivo .json desde tu explorador para cargar datos', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                      trailing: Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
                      onTap: _handleImportJson,
                    ),

                    const Divider(height: 1),

                    // --- 7. BORRAR TODOS LOS DATOS LOCALES ---
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.delete_forever_rounded, color: Color(0xFFDC2626), size: 20),
                      ),
                      title: const Text(
                        'Borrar todos los datos locales',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                      ),
                      subtitle: Text('Acción irreversible en el almacenamiento interno', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFDC2626)),
                      onTap: () => _confirmResetAll(context, ref),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Preferencias de Sistema
              _buildSectionHeader(Icons.tune_rounded, 'Preferencias de Sistema', colors.textPrimary),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Aspecto visual', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            SizedBox(height: 2),
                            Text('Diseñado con calma y alto contraste', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: AppThemePreference.values.map((pref) {
                              final isSelected = settings.themePreference == pref;
                              return GestureDetector(
                                onTap: () => notifier.updateSettings(settings.copyWith(themePreference: pref)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    pref.displayName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? Colors.white : colors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Formato de hora', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            SizedBox(height: 2),
                            Text('Estilo de registro horario', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: colors.isDark ? colors.surfaceVariant : const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              _buildChoicePill('24 h', settings.use24HourFormat, () {
                                notifier.updateSettings(settings.copyWith(use24HourFormat: true));
                              }),
                              _buildChoicePill('12 h', !settings.use24HourFormat, () {
                                notifier.updateSettings(settings.copyWith(use24HourFormat: false));
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botón para restablecer ajustes predeterminados
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmResetDefaults(context, ref),
                  icon: const Icon(Icons.restore_rounded, size: 18),
                  label: const Text(
                    'Restablecer ajustes predeterminados',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Footer con Versión
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.isDark ? colors.surfaceVariant : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: Color(0xFF10B981)),
                          SizedBox(width: 6),
                          Text(
                            'HAVE TO STUDY · v1.2.0 (LOCAL BUILD)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4F46E5),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Diseñado para estudiantes autónomos que priorizan concentración profunda, sosiego cognitivo y soberanía total sobre sus datos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: colors.textSecondary, height: 1.3),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined, size: 14, color: AppColors.teal),
                        SizedBox(width: 4),
                        Text(
                          'Almacenamiento 100% local en este dispositivo',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.teal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepper({
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    final activeColor = colors.isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.isDark ? colors.surfaceVariant : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.remove_rounded, size: 18, color: activeColor),
            onPressed: onDecrement,
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: activeColor),
          ),
          const SizedBox(width: 10),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.add_rounded, size: 18, color: activeColor),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingStepperRow({
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: colors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
            ],
          ),
        ),
        _buildStepper(value: value, onDecrement: onDecrement, onIncrement: onIncrement),
      ],
    );
  }

  Widget _buildSettingSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: colors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11, color: colors.textSecondary)),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildChoicePill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? (colors.isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5))
                : colors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _confirmResetDefaults(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('¿Restablecer ajustes predeterminados?', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'Esta acción restaurará los valores predeterminados de Pomodoro (25 min concentración, 5 min descanso corto, 15 min descanso largo, 4 ciclos por ronda), el objetivo diario (3 h), el sonido y las preferencias del sistema.\n\nTus asignaturas, pendientes e historial de sesiones permanecerán intactos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref.read(settingsProvider.notifier).resetToDefaults();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ajustes restablecidos a sus valores predeterminados.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Restablecer'),
            ),
          ],
        );
      },
    );
  }

  void _confirmResetAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('¿Borrar todos los datos locales?', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'Esta acción eliminará todas las asignaturas, tareas, sesiones de estudio y configuraciones de este dispositivo, devolviendo la app a su estado inicial de bienvenida.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);

                // 1. Limpiar completamente la base de datos sin datos de muestra
                await ref.read(appDatabaseProvider).clearAllData();

                // 2. Eliminar marcas de Onboarding y preferencias guardadas
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // 3. Recargar notifiers para reflejar el estado limpio
                await ref.read(subjectsProvider.notifier).reload();
                await ref.read(academicEventsProvider.notifier).reload();
                await ref.read(focusSessionsProvider.notifier).reload();
                await ref.read(settingsProvider.notifier).reload();
                await ref.read(profileProvider.notifier).reload();
                await ref.read(pomodoroProvider.notifier).reload();

                // 4. Redirigir a la pantalla que sale al abrir por primera vez la app
                if (context.mounted) {
                  context.go('/splash');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
              child: const Text('Borrar Todo'),
            ),
          ],
        );
      },
    );
  }
}
