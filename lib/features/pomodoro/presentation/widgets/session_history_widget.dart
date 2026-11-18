import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_theme.dart';
import '../../../../core/providers.dart';
import '../../../../shared/utils/time_utils.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../subjects/domain/subject_model.dart';
import '../../../academic_events/domain/academic_event_model.dart';
import '../../domain/pomodoro_models.dart';
import 'edit_session_sheet.dart';

/// Widget de Historial de Pomos / Bloques para la Sesión Activa.
/// Permite visualizar, editar y eliminar bloques de estudio completados.
class SessionHistoryWidget extends ConsumerStatefulWidget {
  const SessionHistoryWidget({super.key});

  @override
  ConsumerState<SessionHistoryWidget> createState() => _SessionHistoryWidgetState();
}

class _SessionHistoryWidgetState extends ConsumerState<SessionHistoryWidget> {
  bool _showOnlyToday = true;

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    FocusSessionModel session,
    SubjectModel? subject,
    AcademicEventModel? event,
  ) async {
    final colors = context.colors;
    final durationStr = TimeUtils.formatDurationHoursMinutes(session.durationSeconds);
    final subjectName = subject?.name ?? 'General';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: colors.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFDC2626),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '¿Eliminar este pomo?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Se eliminará este bloque de estudio de $durationStr ($subjectName).',
              style: TextStyle(
                fontSize: 14,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'El tiempo transcurrido se descontará automáticamente de tus estadísticas y del progreso acumulado en la asignatura.',
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sí, eliminar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(focusSessionsProvider.notifier).deleteSession(session.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pomodoro eliminado de tu historial.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final allSessions = ref.watch(focusSessionsProvider);
    final subjects = ref.watch(subjectsProvider);
    final events = ref.watch(academicEventsProvider);

    final now = DateTime.now();

    // Sesiones de hoy
    final todaySessions = allSessions.where((s) {
      final local = s.completedAt.toLocal();
      return local.year == now.year && local.month == now.month && local.day == now.day;
    }).toList();

    final displayedSessions = _showOnlyToday ? todaySessions : allSessions;
    final totalSeconds = displayedSessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);

    return Container(
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la sección
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HISTORIAL DE POMOS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: colors.textSecondary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _showOnlyToday
                          ? '${todaySessions.length} pomos hoy • ${TimeUtils.formatDurationHoursMinutes(totalSeconds)}'
                          : '${allSessions.length} pomos registrados • ${TimeUtils.formatDurationHoursMinutes(totalSeconds)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Selector de filtro [ Hoy ] [ Todos ]
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterTab(
                      label: 'Hoy',
                      count: todaySessions.length,
                      isSelected: _showOnlyToday,
                      onTap: () => setState(() => _showOnlyToday = true),
                    ),
                    _buildFilterTab(
                      label: 'Todos',
                      count: allSessions.length,
                      isSelected: !_showOnlyToday,
                      onTap: () => setState(() => _showOnlyToday = false),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Lista de pomodoros o estado vacío
          if (displayedSessions.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border.withValues(alpha: 0.6)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 32,
                    color: colors.textSecondary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _showOnlyToday
                        ? 'No hay pomos registrados hoy'
                        : 'Aún no tienes ningún pomo en el historial',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Al completar un bloque de estudio, aparecerá aquí para que puedas gestionarlo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedSessions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final session = displayedSessions[index];
                final subject = session.subjectId != null
                    ? subjects.where((s) => s.id == session.subjectId).firstOrNull
                    : null;
                final event = session.academicEventId != null
                    ? events.where((e) => e.id == session.academicEventId).firstOrNull
                    : null;

                final subjectColor = subject?.displayColor(colors.isDark) ?? AppColors.primary;
                final subjectName = subject?.name ?? 'Sesión Libre General';
                final subjectCode = subject?.code ?? '';

                final startTimeStr = DateFormat('HH:mm').format(session.startedAt.toLocal());
                final endTimeStr = DateFormat('HH:mm').format(session.completedAt.toLocal());

                // Indicador de fecha si no es hoy
                final isToday = session.completedAt.toLocal().year == now.year &&
                    session.completedAt.toLocal().month == now.month &&
                    session.completedAt.toLocal().day == now.day;
                final dateHeaderStr = isToday
                    ? ''
                    : '${DateFormat("d MMM", "es").format(session.completedAt.toLocal())} • ';

                final durationStr = TimeUtils.formatDurationHoursMinutes(session.durationSeconds);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border.withValues(alpha: 0.8)),
                  ),
                  child: Row(
                    children: [
                      // Avatar con icono de la asignatura
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: subjectColor.withValues(alpha: colors.isDark ? 0.25 : 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          subject?.iconData ?? Icons.timer_rounded,
                          color: subjectColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Información de Asignatura, Tarea y Horario
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (subjectCode.isNotEmpty) ...[
                                  AppChip(
                                    label: subjectCode,
                                    variant: AppChipVariant.info,
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    borderRadius: BorderRadius.circular(4),
                                    textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Expanded(
                                  child: Text(
                                    subjectName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),

                            // Actividad vinculada o sesión libre
                            Row(
                              children: [
                                if (event != null) ...[
                                  AppChip(
                                    label: event.type.displayName,
                                    variant: AppChipVariant.custom,
                                    customBackgroundColor: event.type.backgroundColor,
                                    customForegroundColor: event.type.color,
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    borderRadius: BorderRadius.circular(4),
                                    textStyle: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      event.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Icon(Icons.menu_book_outlined, size: 12, color: colors.textSecondary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Sesión libre',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Horario y duración
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded, size: 11, color: colors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  '$dateHeaderStr$startTimeStr - $endTimeStr',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AppChip(
                                  label: durationStr,
                                  variant: AppChipVariant.teal,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  borderRadius: BorderRadius.circular(6),
                                  textStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botones de acción: Editar y Eliminar
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            color: colors.textSecondary,
                            tooltip: 'Editar pomodoro',
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            onPressed: () => EditSessionSheet.show(context, session),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18),
                            color: const Color(0xFFDC2626),
                            tooltip: 'Eliminar pomodoro',
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            onPressed: () => _confirmDelete(
                              context,
                              ref,
                              session,
                              subject,
                              event,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
