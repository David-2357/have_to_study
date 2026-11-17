import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_theme.dart';
import '../utils/time_utils.dart';
import '../../core/providers.dart';
import '../../features/academic_events/domain/academic_event_model.dart';
import '../../features/subjects/domain/subject_model.dart';
import '../../features/academic_events/presentation/create_event_sheet.dart';

class AcademicEventCard extends ConsumerStatefulWidget {
  final AcademicEventModel event;
  final SubjectModel subject;
  final bool initialExpanded;
  final VoidCallback? onToggleExpand;

  const AcademicEventCard({
    super.key,
    required this.event,
    required this.subject,
    this.initialExpanded = false,
    this.onToggleExpand,
  });

  @override
  ConsumerState<AcademicEventCard> createState() => _AcademicEventCardState();
}

class _AcademicEventCardState extends ConsumerState<AcademicEventCard> {
  AppColorTheme get colors => context.colors;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  @override
  void didUpdateWidget(covariant AcademicEventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialExpanded != widget.initialExpanded) {
      _isExpanded = widget.initialExpanded;
    }
  }

  void _handleToggleComplete() {
    final wasCompleted = widget.event.isCompleted;
    ref.read(academicEventsProvider.notifier).toggleComplete(widget.event.id);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(wasCompleted ? 'Pendiente reabierto' : '¡Compromiso completado! 🎉'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            ref.read(academicEventsProvider.notifier).toggleComplete(widget.event.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final event = widget.event;
    final subject = widget.subject;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: subject.displayColor(colors.isDark), width: 6),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera: Checkbox + Badge Tipo + Tiempo restante + Icono expandir
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _handleToggleComplete,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Icon(
                            event.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            color: event.isCompleted ? AppColors.success : colors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: event.type.backgroundColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.type.shortTag,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: event.type.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.isDark
                              ? const Color(0xFFD97706).withValues(alpha: 0.22)
                              : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_filled_rounded,
                              size: 11,
                              color: colors.isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              TimeUtils.formatRelativeDate(event.dueAt),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colors.isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: colors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      widget.onToggleExpand?.call();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Título
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: event.isCompleted ? colors.textSecondary : colors.textPrimary,
                  decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                  decorationColor: colors.textSecondary,
                  decorationThickness: 2,
                ),
              ),

              const SizedBox(height: 6),

              // Asignatura
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: subject.displayColor(colors.isDark),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    subject.code.isNotEmpty ? '${subject.name} · ${subject.code}' : subject.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Fecha y Pomodoros
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: colors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        TimeUtils.formatEventDate(event.dueAt, includeTime: event.hasDueTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 12, color: colors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${event.completedPomodoros} / ${event.targetPomodoros} Pomos',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Sección Expandida con Estadísticas y Botón Iniciar Pomodoro
              if (_isExpanded) ...[
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso de preparación',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      '${event.progressPercent}% completado',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: event.progress,
                    backgroundColor: colors.isDark ? colors.surfaceVariant : const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildMetricPill(
                      title: 'Dedicado',
                      val: '${(event.completedPomodoros * 25) ~/ 60}h ${(event.completedPomodoros * 25) % 60}m',
                      sub: '${event.completedPomodoros} pomos',
                    ),
                    const SizedBox(width: 8),
                    _buildMetricPill(
                      title: 'Restante',
                      val: '${((event.targetPomodoros - event.completedPomodoros).clamp(0, 99) * 25)}m',
                      sub: '${(event.targetPomodoros - event.completedPomodoros).clamp(0, 99)} pomos',
                    ),
                    const SizedBox(width: 8),
                    _buildMetricPill(
                      title: 'Meta',
                      val: '${event.targetPomodoros} pomos',
                      sub: '${event.targetPomodoros * 25} min total',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CreateEventSheet(eventToEdit: event),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Editar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(pomodoroProvider.notifier).selectSubjectAndEvent(subject.id, event.id);
                          ref.read(pomodoroProvider.notifier).startFocus();
                          context.push('/session');
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Iniciar Pomodoro'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricPill({required String title, required String val, required String sub}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              val,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            Text(
              sub,
              style: TextStyle(
                fontSize: 9,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
