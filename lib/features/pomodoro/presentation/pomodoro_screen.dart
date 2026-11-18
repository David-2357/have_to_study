import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../shared/utils/time_utils.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_chip.dart';
import '../../../core/providers.dart';
import '../domain/pomodoro_models.dart';
import '../../subjects/domain/subject_model.dart';
import '../../academic_events/domain/academic_event_model.dart';
import '../../academic_events/presentation/create_event_sheet.dart';
import 'widgets/select_activity_sheet.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {
  AppColorTheme get colors => context.colors;
  int _visibleEventsCount = 3;

  @override
  Widget build(BuildContext context) {
    final pomodoro = ref.watch(pomodoroProvider);
    final subjects = ref.watch(subjectsProvider);
    final events = ref.watch(academicEventsProvider);
    final sessions = ref.watch(focusSessionsProvider);
    final settings = ref.watch(settingsProvider);

    // Asignatura y evento activos en Pomodoro
    SubjectModel? currentSubject;
    if (pomodoro.activeSubjectId != null) {
      currentSubject = subjects.where((s) => s.id == pomodoro.activeSubjectId).firstOrNull;
    }
    currentSubject ??= subjects.isNotEmpty ? subjects.first : null;

    AcademicEventModel? currentEvent;
    if (pomodoro.activeEventId != null) {
      currentEvent = events.where((e) => e.id == pomodoro.activeEventId).firstOrNull;
    }

    // Calcular estadísticas de hoy
    final now = DateTime.now();
    final todaySessions = sessions.where((s) {
      return s.completedAt.year == now.year &&
          s.completedAt.month == now.month &&
          s.completedAt.day == now.day;
    }).toList();

    final todayBlocks = todaySessions.length;
    final todaySeconds = todaySessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final targetBlocks = (settings.dailyGoalHours * 60) ~/ settings.focusMinutes;
    final goalPercent = targetBlocks > 0
        ? ((todayBlocks / targetBlocks) * 100).clamp(0, 100).round()
        : 100;

    // Pendientes ordenados por cercanía
    final pendingEvents = events.where((e) => !e.isCompleted).toList()
      ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(subtitle: 'Panel Principal'),
              const SizedBox(height: 12),

              // 1. CARD DE POMODORO CON CONTADOR EN MINIATURA
              _buildPomodoroMiniCard(
                context: context,
                ref: ref,
                pomodoro: pomodoro,
                currentSubject: currentSubject,
                currentEvent: currentEvent,
                subjects: subjects,
                events: events,
              ),

              const SizedBox(height: 24),

              // 2. SECCIÓN DE PRÓXIMOS PENDIENTES (3 más cercanos + opción de cargar más)
              _buildUpcomingTasksSection(
                context: context,
                ref: ref,
                pendingEvents: pendingEvents,
                subjects: subjects,
              ),

              const SizedBox(height: 24),

              // 3. RESUMEN DE ACTIVIDAD DIARIA
              _buildDailyStatsSection(
                todayBlocks: todayBlocks,
                todaySeconds: todaySeconds,
                goalPercent: goalPercent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // CARD COMPACTA DE POMODORO CON MINI-TIMER
  // ==========================================
  Widget _buildPomodoroMiniCard({
    required BuildContext context,
    required WidgetRef ref,
    required PomodoroStateModel pomodoro,
    required SubjectModel? currentSubject,
    required AcademicEventModel? currentEvent,
    required List<SubjectModel> subjects,
    required List<AcademicEventModel> events,
  }) {
    final subjectColor = currentSubject?.displayColor(colors.isDark) ?? AppColors.primary;
    final progress = pomodoro.totalSeconds > 0
        ? (pomodoro.remainingSeconds / pomodoro.totalSeconds).clamp(0.0, 1.0)
        : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/session'),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: subjectColor,
                      width: 6,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: Estado de Fase y Botón de cambiar actividad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: pomodoro.phase.displayBackgroundColor(colors.isDark),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: pomodoro.phase.displayForegroundColor(colors.isDark),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                pomodoro.isRunning
                                    ? pomodoro.phase.label.toUpperCase()
                                    : (pomodoro.isPaused ? 'EN PAUSA' : 'LISTO PARA INICIAR'),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: pomodoro.phase.displayForegroundColor(colors.isDark),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pomodoro.phase == PomodoroPhase.longBreak
                                    ? '• Descanso largo'
                                    : '• Ciclo ${pomodoro.currentCycle}/${pomodoro.cyclesBeforeLongBreak}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: pomodoro.phase.displayForegroundColor(colors.isDark).withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botón para cambiar asignatura o tarea
                        InkWell(
                          onTap: () => showSelectActivitySheet(context, ref),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.swap_vert_rounded, size: 14, color: colors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'Cambiar',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Fila intermedia: Información de la actividad
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: subjectColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            currentSubject?.iconData ?? Icons.school_rounded,
                            color: subjectColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (currentSubject?.code.isNotEmpty ?? false)
                                    AppChip(
                                      label: currentSubject!.code,
                                      variant: AppChipVariant.info,
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      borderRadius: BorderRadius.circular(6),
                                      textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  if (currentEvent != null) ...[
                                    const SizedBox(width: 6),
                                    AppChip(
                                      label: currentEvent.type.shortTag,
                                      variant: AppChipVariant.custom,
                                      customBackgroundColor: currentEvent.type.displayBackgroundColor(colors.isDark),
                                      customForegroundColor: currentEvent.type.displayForegroundColor(colors.isDark),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      borderRadius: BorderRadius.circular(6),
                                      textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentEvent?.title ?? currentSubject?.name ?? 'Sesión Libre de Estudio',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (currentEvent != null && currentSubject != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  currentSubject.name,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Barra Inferior: Contador en Miniatura y Botón de Apertura de Sesión
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          // Mini aro de progreso circular invertido
                          SizedBox(
                            width: 38,
                            height: 38,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 4,
                                  backgroundColor: pomodoro.phase.color.withValues(alpha: 0.15),
                                  valueColor: AlwaysStoppedAnimation<Color>(pomodoro.phase.color),
                                  strokeCap: StrokeCap.round,
                                ),
                                Icon(
                                  pomodoro.isRunning
                                      ? (pomodoro.phase == PomodoroPhase.focus
                                          ? Icons.local_fire_department_rounded
                                          : Icons.self_improvement_rounded)
                                      : (pomodoro.isPaused ? Icons.pause_rounded : Icons.timer_outlined),
                                  size: 16,
                                  color: pomodoro.phase.color,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Tiempo restante grande en miniatura
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                TimeUtils.formatSecondsToMinutesSeconds(pomodoro.remainingSeconds),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: colors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                pomodoro.isRunning
                                    ? (pomodoro.phase == PomodoroPhase.focus ? 'En concentración • Toca para abrir' : 'En descanso • Toca para abrir')
                                    : (pomodoro.isPaused ? 'Pausado • Toca para abrir' : 'Listo • Toca para abrir'),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: pomodoro.isRunning ? pomodoro.phase.color : colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Píldora interactiva que indica abrir sesión con el color de la fase
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: pomodoro.phase.color,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: pomodoro.phase.color.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sesión',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SECCIÓN: PRÓXIMOS PENDIENTES
  // ==========================================
  Widget _buildUpcomingTasksSection({
    required BuildContext context,
    required WidgetRef ref,
    required List<AcademicEventModel> pendingEvents,
    required List<SubjectModel> subjects,
  }) {
    final visibleEvents = pendingEvents.take(_visibleEventsCount).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección con contador y botón para añadir
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Próximas Actividades',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (pendingEvents.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    AppChip(
                      label: '${pendingEvents.length}',
                      variant: AppChipVariant.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      borderRadius: BorderRadius.circular(10),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ],
              ),
              InkWell(
                onTap: () => _openCreateEventSheet(context),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Text(
                        'Añadir',
                        style: TextStyle(
                          fontSize: 12,
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

          const SizedBox(height: 12),

          // Estado vacío si no hay compromisos pendientes
          if (pendingEvents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: AppColors.teal,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '¡Estás al día!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No tienes actividades pendientes.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _openCreateEventSheet(context),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Crear actividad'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            // Lista de pendientes cercanos
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleEvents.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final event = visibleEvents[index];
                final subject = subjects.where((s) => s.id == event.subjectId).firstOrNull;
                return _buildTaskCard(
                  context: context,
                  ref: ref,
                  event: event,
                  subject: subject,
                );
              },
            ),

            const SizedBox(height: 12),

            // Botón "Cargar más"
            if (pendingEvents.length > _visibleEventsCount)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _visibleEventsCount += 3;
                    });
                  },
                  icon: const Icon(Icons.expand_more_rounded, size: 20),
                  label: Text(
                    'Cargar más actividades (${pendingEvents.length - _visibleEventsCount} restantes)',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              )
            else if (_visibleEventsCount > 3 && pendingEvents.length > 3)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _visibleEventsCount = 3;
                    });
                  },
                  icon: const Icon(Icons.expand_less_rounded, size: 20),
                  label: const Text(
                    'Mostrar menos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.textSecondary,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // TARJETA INDIVIDUAL DE PENDIENTE
  // ==========================================
  Widget _buildTaskCard({
    required BuildContext context,
    required WidgetRef ref,
    required AcademicEventModel event,
    required SubjectModel? subject,
  }) {
    final now = DateTime.now();
    final isDueSoon = event.dueAt.difference(now).inDays <= 2 && event.dueAt.isAfter(now);
    final isOverdue = event.dueAt.isBefore(now);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox circular para marcar como completado
          InkWell(
            onTap: () async {
              final wasCompleted = event.isCompleted;
              await ref.read(academicEventsProvider.notifier).toggleComplete(event.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(wasCompleted ? 'Actividad reabierta' : '¡"${event.title}" completada con éxito! 🎉'),
                    duration: const Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Deshacer',
                      textColor: Colors.white,
                      onPressed: () {
                        ref.read(academicEventsProvider.notifier).toggleComplete(event.id);
                      },
                    ),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.border,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.transparent,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Información central del pendiente
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila de Badges: Tipo y Asignatura
                Row(
                  children: [
                    AppChip(
                      label: event.type.shortTag,
                      variant: AppChipVariant.custom,
                      customBackgroundColor: event.type.displayBackgroundColor(colors.isDark),
                      customForegroundColor: event.type.displayForegroundColor(colors.isDark),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      borderRadius: BorderRadius.circular(6),
                      textStyle: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subject != null) ...[
                      const SizedBox(width: 6),
                      AppChip(
                        label: subject.name,
                        variant: AppChipVariant.custom,
                        customBackgroundColor: subject.displayColor(colors.isDark).withValues(alpha: colors.isDark ? 0.22 : 0.12),
                        customForegroundColor: subject.displayColor(colors.isDark),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        borderRadius: BorderRadius.circular(6),
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // Título del pendiente
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Fecha límite y Pomodoros (con Wrap para evitar overflow)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: isOverdue
                              ? AppColors.primary
                              : (isDueSoon ? AppColors.warning : colors.textSecondary),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          TimeUtils.formatRelativeDate(event.dueAt),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isDueSoon || isOverdue ? FontWeight.bold : FontWeight.w500,
                            color: isOverdue
                                ? AppColors.primary
                                : (isDueSoon ? AppColors.warning : colors.textSecondary),
                          ),
                        ),
                        if (event.hasDueTime) ...[
                          const SizedBox(width: 4),
                          Text(
                            '• ${TimeUtils.formatEventDate(event.dueAt, includeTime: true).split(', ').last}',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '• ${event.completedPomodoros}/${event.targetPomodoros} bloques',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Botón rápido para vincular al Pomodoro y estudiar
          IconButton(
            tooltip: 'Estudiar esta tarea con Pomodoro',
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            onPressed: () {
              ref.read(pomodoroProvider.notifier).selectSubjectAndEvent(event.subjectId, event.id);
              context.push('/session');
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECCIÓN: RESUMEN DE ACTIVIDAD DIARIA
  // ==========================================
  Widget _buildDailyStatsSection({
    required int todayBlocks,
    required int todaySeconds,
    required int goalPercent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividad de Hoy',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Tarjeta Racha de hoy
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RACHA DE HOY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: colors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colors.isDark ? AppColors.primary.withValues(alpha: 0.22) : AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.local_fire_department_rounded,
                              color: colors.isDark ? const Color(0xFFF87171) : AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: '$todayBlocks ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: colors.textPrimary,
                          ),
                          children: [
                            TextSpan(
                              text: 'bloques',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Objetivo diario en $goalPercent%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Tarjeta Tiempo Acumulado
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TIEMPO TOTAL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: colors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colors.isDark ? AppColors.info.withValues(alpha: 0.22) : const Color(0xFFEBF5FB),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: colors.isDark ? const Color(0xFF60A5FA) : AppColors.info,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        TimeUtils.formatDurationHoursMinutes(todaySeconds),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Dedicados hoy',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODAL PARA AÑADIR PENDIENTE
  // ==========================================
  void _openCreateEventSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateEventSheet(),
    );
  }
}
