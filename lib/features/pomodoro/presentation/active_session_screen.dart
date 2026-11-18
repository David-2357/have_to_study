import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../shared/utils/time_utils.dart';
import '../../../core/providers.dart';
import '../../../shared/widgets/student_avatar.dart';
import '../../../shared/widgets/app_chip.dart';
import '../domain/pomodoro_models.dart';
import '../../subjects/domain/subject_model.dart';
import '../../academic_events/domain/academic_event_model.dart';
import 'widgets/circular_timer_widget.dart';
import 'widgets/select_activity_sheet.dart';
import 'widgets/pomodoro_quick_settings_sheet.dart';
import 'widgets/session_history_widget.dart';

enum ActiveSessionMode { pomodoro, unbounded }

class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  ConsumerState<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  AppColorTheme get colors => context.colors;
  ActiveSessionMode _activeMode = ActiveSessionMode.pomodoro;

  @override
  void initState() {
    super.initState();
    final unbounded = ref.read(unboundedSessionProvider);
    if (unbounded.isRunning) {
      _activeMode = ActiveSessionMode.unbounded;
    }
  }

  Widget _buildModeTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? colors.textPrimary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pomodoro = ref.watch(pomodoroProvider);
    final unbounded = ref.watch(unboundedSessionProvider);
    final subjects = ref.watch(subjectsProvider);
    final events = ref.watch(academicEventsProvider);
    final profile = ref.watch(profileProvider);
    final sessions = ref.watch(focusSessionsProvider);
    final settings = ref.watch(settingsProvider);

    final activeSubjectId = _activeMode == ActiveSessionMode.pomodoro
        ? pomodoro.activeSubjectId
        : (unbounded.activeSubjectId ?? pomodoro.activeSubjectId);

    final activeEventId = _activeMode == ActiveSessionMode.pomodoro
        ? pomodoro.activeEventId
        : (unbounded.activeEventId ?? pomodoro.activeEventId);

    SubjectModel? currentSubject;
    if (activeSubjectId != null) {
      currentSubject = subjects.firstWhere(
        (s) => s.id == activeSubjectId,
        orElse: () => subjects.isNotEmpty ? subjects.first : SubjectModel(id: '', name: 'General', colorValue: AppColors.primary.toARGB32()),
      );
    } else if (subjects.isNotEmpty) {
      currentSubject = subjects.first;
    }

    final AcademicEventModel? currentEvent = activeEventId != null
        ? events.where((e) => e.id == activeEventId).firstOrNull
        : null;

    final isFocus = pomodoro.phase == PomodoroPhase.focus;

    // Subtítulo descriptivo de fase y ciclo
    final String cycleSubtitle;
    if (pomodoro.phase == PomodoroPhase.longBreak) {
      cycleSubtitle = 'Descanso largo • Ronda de ${pomodoro.cyclesBeforeLongBreak} ciclos';
    } else if (pomodoro.phase == PomodoroPhase.shortBreak) {
      cycleSubtitle = 'Descanso corto tras ciclo ${pomodoro.currentCycle}';
    } else {
      cycleSubtitle = 'Ciclo ${pomodoro.currentCycle} de ${pomodoro.cyclesBeforeLongBreak}';
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Sesión en Curso',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        actions: [
          if (currentEvent != null && currentEvent.type != EventType.exam)
            IconButton(
              icon: Icon(
                currentEvent.isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                color: currentEvent.isCompleted ? const Color(0xFF16A34A) : colors.textPrimary,
              ),
              tooltip: currentEvent.isCompleted ? 'Desmarcar actividad' : 'Completar actividad',
              onPressed: () async {
                final wasCompleted = currentEvent.isCompleted;
                await ref.read(academicEventsProvider.notifier).toggleComplete(currentEvent.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(wasCompleted
                          ? 'Actividad reabierta.'
                          : '¡Actividad "${currentEvent.title}" completada! 🎉'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: wasCompleted ? colors.surfaceVariant : const Color(0xFF16A34A),
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Deshacer',
                        textColor: Colors.white,
                        onPressed: () {
                          ref.read(academicEventsProvider.notifier).toggleComplete(currentEvent.id);
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Cambiar actividad',
            onPressed: () => showSelectActivitySheet(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Ajustes del Pomodoro',
            onPressed: () => showPomodoroQuickSettingsSheet(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StudentAvatar(
              profile: profile,
              size: 36,
              borderRadius: 18,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
          child: Column(
            children: [
              // Tabs superiores: [ Pomodoro ] [ Sin límites ]
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModeTab(
                      label: 'Pomodoro',
                      icon: Icons.timer_outlined,
                      isSelected: _activeMode == ActiveSessionMode.pomodoro,
                      onTap: () {
                        setState(() => _activeMode = ActiveSessionMode.pomodoro);
                      },
                    ),
                    const SizedBox(width: 4),
                    _buildModeTab(
                      label: 'Sin límites',
                      icon: Icons.all_inclusive_rounded,
                      isSelected: _activeMode == ActiveSessionMode.unbounded,
                      onTap: () {
                        setState(() => _activeMode = ActiveSessionMode.unbounded);
                      },
                    ),
                  ],
                ),
              ),

              if (_activeMode == ActiveSessionMode.pomodoro) ...[
                // Píldora dinámica de Fase actual
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: pomodoro.phase.displayBackgroundColor(colors.isDark),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: pomodoro.phase.displayForegroundColor(colors.isDark),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFocus
                            ? 'EN CONCENTRACIÓN ACTIVA'
                            : pomodoro.phase.label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: pomodoro.phase.displayForegroundColor(colors.isDark),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Círculo del temporizador
                CircularTimerWidget(
                  remainingSeconds: pomodoro.remainingSeconds,
                  totalSeconds: pomodoro.totalSeconds,
                  phase: pomodoro.phase,
                  centerSubtitle: cycleSubtitle,
                  size: 260,
                ),

                const SizedBox(height: 16),

                // Indicadores de ciclo con Wrap para evitar overflow con > 9 ciclos
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(pomodoro.cyclesBeforeLongBreak, (index) {
                    final bool isCompleted;
                    final bool isCurrent;

                    if (pomodoro.phase == PomodoroPhase.longBreak) {
                      isCompleted = true;
                      isCurrent = false;
                    } else if (pomodoro.phase == PomodoroPhase.shortBreak) {
                      isCompleted = index <= pomodoro.currentCycle - 1;
                      isCurrent = false;
                    } else {
                      isCompleted = index < pomodoro.currentCycle - 1;
                      isCurrent = index == pomodoro.currentCycle - 1;
                    }

                    return Container(
                      width: isCurrent ? 22 : 9,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.primary
                            : (isCompleted
                                ? AppColors.teal
                                : colors.surfaceVariant),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 12),

                // Botón directo a ajustes de Pomodoro y ciclos
                InkWell(
                  onTap: () => showPomodoroQuickSettingsSheet(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune_rounded, size: 14, color: colors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'Ajustes de pomodoro y ciclos',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Dos botones: Volver a 0 y Pasar de fase
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => ref.read(pomodoroProvider.notifier).reset(),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text(
                          'Volver a 0',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.textPrimary,
                          side: BorderSide(color: colors.border),
                          backgroundColor: colors.surface,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => ref.read(pomodoroProvider.notifier).skipToNextPhase(),
                        icon: Icon(
                          Icons.fast_forward_rounded,
                          size: 18,
                          color: isFocus
                              ? (pomodoro.currentCycle >= pomodoro.cyclesBeforeLongBreak
                                  ? AppColors.info
                                  : AppColors.teal)
                              : AppColors.primary,
                        ),
                        label: Text(
                          isFocus ? 'Descanso' : 'Concentración',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isFocus
                                ? (pomodoro.currentCycle >= pomodoro.cyclesBeforeLongBreak
                                    ? AppColors.info
                                    : AppColors.teal)
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.border),
                          backgroundColor: colors.surface,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Botón Principal: Pausar / Reanudar (dinámico según fase y estado)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (pomodoro.isRunning) {
                        ref.read(pomodoroProvider.notifier).pause();
                      } else {
                        ref.read(unboundedSessionProvider.notifier).pause();
                        ref.read(pomodoroProvider.notifier).resume();
                      }
                    },
                    icon: Icon(
                      pomodoro.isRunning
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 24,
                    ),
                    label: Text(
                      pomodoro.isRunning ? 'Pausar' : 'Reanudar',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pomodoro.phase.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 3,
                      shadowColor: pomodoro.phase.color.withValues(alpha: 0.35),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Botón texto: Cancelar sesión
                TextButton.icon(
                  onPressed: () {
                    final hasProgress = pomodoro.remainingSeconds < pomodoro.totalSeconds;
                    if (hasProgress) {
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Text('¿Cancelar sesión de estudio?', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: const Text(
                            'Si cancelas ahora y has estudiado más de 1 minuto, el tiempo transcurrido se guardará en tus estadísticas, pero no contará como pomodoro natural completado.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogCtx),
                              child: const Text('Continuar sesión'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogCtx);
                                ref.read(pomodoroProvider.notifier).cancelSession();
                                context.pop();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                              child: const Text('Sí, cancelar'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ref.read(pomodoroProvider.notifier).cancelSession();
                      context.pop();
                    }
                  },
                  icon: Icon(Icons.close_rounded, size: 16, color: colors.textSecondary),
                  label: Text(
                    'Cancelar sesión',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ] else ...[
                // MODO: SESIÓN SIN LÍMITES (CRONÓMETRO CONTINUO)
                Builder(
                  builder: (context) {
                    final elapsed = unbounded.elapsedSeconds;
                    final hours = elapsed ~/ 3600;
                    final mins = (elapsed % 3600) ~/ 60;
                    final secs = elapsed % 60;
                    final stopwatchTimeStr = hours > 0
                        ? '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}'
                        : '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
                    final pomosEarned = (elapsed / 1500).round();
                    final progressTowardsPomo = elapsed > 0 ? (elapsed % 1500) / 1500.0 : 0.0;

                    return Column(
                      children: [
                        // Píldora de estado del cronómetro
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2563EB),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                unbounded.isRunning ? 'CRONÓMETRO ACTIVO • FLUJO CONTINUO' : 'SESIÓN SIN LÍMITES',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2563EB),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Círculo del cronómetro
                        CircularTimerWidget(
                          remainingSeconds: elapsed,
                          totalSeconds: 1500,
                          phase: PomodoroPhase.focus,
                          customTimeStr: stopwatchTimeStr,
                          customProgress: elapsed > 0 ? progressTowardsPomo : 1.0,
                          customColor: const Color(0xFF2563EB),
                          centerSubtitle: '$pomosEarned pomos para metas',
                          size: 260,
                        ),

                        const SizedBox(height: 16),

                        // Indicador de pomodoros acumulados
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.all_inclusive_rounded, size: 16, color: Color(0xFF2563EB)),
                              const SizedBox(width: 8),
                              Text(
                                '$pomosEarned pomodoros para metas (~25m c/u)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E40AF),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Dos botones: Volver a 0 y Finalizar
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => ref.read(unboundedSessionProvider.notifier).reset(),
                                icon: const Icon(Icons.refresh_rounded, size: 18),
                                label: const Text(
                                  'Volver a 0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colors.textPrimary,
                                  side: BorderSide(color: colors.border),
                                  backgroundColor: colors.surface,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final res = await ref.read(unboundedSessionProvider.notifier).finishAndSave();
                                  if (context.mounted) {
                                    final m = res.secondsSaved ~/ 60;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('🎉 ¡Sesión guardada! $m min registrados (${res.pomodorosEarned} pomodoros para metas).'),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 4),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.task_alt_rounded, size: 18, color: Color(0xFF16A34A)),
                                label: const Text(
                                  'Finalizar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF16A34A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: colors.border),
                                  backgroundColor: colors.surface,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Botón Principal: Pausar / Reanudar / Iniciar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (unbounded.isRunning) {
                                ref.read(unboundedSessionProvider.notifier).pause();
                              } else if (elapsed > 0) {
                                ref.read(pomodoroProvider.notifier).pause();
                                ref.read(unboundedSessionProvider.notifier).resume();
                              } else {
                                ref.read(pomodoroProvider.notifier).pause();
                                ref.read(unboundedSessionProvider.notifier).start();
                              }
                            },
                            icon: Icon(
                              unbounded.isRunning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 24,
                            ),
                            label: Text(
                              unbounded.isRunning
                                  ? 'Pausar'
                                  : (elapsed > 0 ? 'Reanudar' : 'Iniciar'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 3,
                              shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.35),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Botón texto: Descartar tiempo
                        TextButton.icon(
                          onPressed: () {
                            ref.read(unboundedSessionProvider.notifier).reset();
                          },
                          icon: Icon(Icons.close_rounded, size: 16, color: colors.textSecondary),
                          label: Text(
                            'Descartar tiempo',
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],

              const SizedBox(height: 16),

              // Tarjeta inferior de contexto con Jerarquía Asignatura > Tarea
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nivel 1 (Jerarquía Superior): ASIGNATURA
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (currentSubject?.displayColor(colors.isDark) ?? AppColors.primary)
                                .withValues(alpha: colors.isDark ? 0.25 : 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            currentSubject?.iconData ?? Icons.school_rounded,
                            color: currentSubject?.displayColor(colors.isDark) ?? AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (currentSubject?.code.isNotEmpty ?? false) ...[
                                    AppChip(
                                      label: currentSubject!.code,
                                      variant: AppChipVariant.info,
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      borderRadius: BorderRadius.circular(6),
                                      textStyle: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    'ASIGNATURA',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: colors.textSecondary,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentSubject?.name ?? 'Sesión Libre General',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => showSelectActivitySheet(context, ref),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.swap_vert_rounded, size: 14, color: AppColors.primary),
                                SizedBox(width: 4),
                                Text(
                                  'Cambiar',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // Nivel 2 (Jerarquía Inferior): TAREA O COMPROMISO ESPECÍFICO
                    if (currentEvent != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppChip(
                            label: currentEvent.type.displayName,
                            variant: AppChipVariant.custom,
                            customBackgroundColor: currentEvent.type.displayBackgroundColor(colors.isDark),
                            customForegroundColor: currentEvent.type.displayForegroundColor(colors.isDark),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            borderRadius: BorderRadius.circular(6),
                            textStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Builder(builder: (context) {
                            final eventSessions = sessions.where((s) => s.academicEventId == currentEvent.id);
                            final actualSecs = eventSessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
                            final focusMins = settings.focusMinutes > 0 ? settings.focusMinutes : 25;
                            final targetSecs = currentEvent.targetPomodoros * focusMins * 60;
                            final pct = targetSecs > 0
                                ? ((actualSecs / targetSecs).clamp(0.0, 1.0) * 100).round()
                                : currentEvent.progressPercent;
                            return Row(
                              children: [
                                const Icon(Icons.pie_chart_outline_rounded, size: 14, color: AppColors.teal),
                                const SizedBox(width: 4),
                                Text(
                                  actualSecs > 0
                                      ? '${TimeUtils.formatDurationHoursMinutes(actualSecs)} / ${TimeUtils.formatDurationHoursMinutes(targetSecs)} ($pct%)'
                                      : '${currentEvent.completedPomodoros} / ${currentEvent.targetPomodoros} bloques (${currentEvent.progressPercent}%)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentEvent.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: currentEvent.isCompleted ? colors.textSecondary : colors.textPrimary,
                          decoration: currentEvent.isCompleted ? TextDecoration.lineThrough : null,
                          decorationColor: colors.textSecondary,
                          decorationThickness: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12, color: colors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'Entrega: ${TimeUtils.formatEventDate(currentEvent.dueAt, includeTime: currentEvent.hasDueTime)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (currentEvent.type != EventType.exam) ...[
                        const SizedBox(height: 12),
                        if (!currentEvent.isCompleted)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await ref.read(academicEventsProvider.notifier).toggleComplete(currentEvent.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('¡Actividad "${currentEvent.title}" completada! 🎉'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFF16A34A),
                                      duration: const Duration(seconds: 4),
                                      action: SnackBarAction(
                                        label: 'Deshacer',
                                        textColor: Colors.white,
                                        onPressed: () {
                                          ref.read(academicEventsProvider.notifier).toggleComplete(currentEvent.id);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check_circle_rounded, size: 18),
                              label: const Text(
                                'Completar actividad',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF86EFAC)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF16A34A)),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Actividad completada',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await ref.read(academicEventsProvider.notifier).toggleComplete(currentEvent.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Actividad reabierta.'),
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 4),
                                          action: SnackBarAction(
                                            label: 'Deshacer',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              ref.read(academicEventsProvider.notifier).toggleComplete(currentEvent.id);
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(60, 28),
                                  ),
                                  child: Text(
                                    'Desmarcar',
                                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ] else ...[
                      Row(
                        children: [
                          Icon(Icons.menu_book_rounded, size: 16, color: colors.textSecondary),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Sesión libre de estudio (sin tarea específica vinculada)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Historial de Pomos / Bloques completados
              const SessionHistoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
