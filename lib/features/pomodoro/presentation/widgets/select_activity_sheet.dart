import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_theme.dart';
import '../../../../shared/utils/time_utils.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../core/providers.dart';
import '../../domain/pomodoro_models.dart';

void showSelectActivitySheet(BuildContext context, WidgetRef ref) {
  final colors = context.colors;
  final subjects = ref.read(subjectsProvider);
  final events = ref.read(academicEventsProvider);
  final pomodoro = ref.read(pomodoroProvider);
  final activeSubjectId = pomodoro.activeSubjectId;
  final activeEventId = pomodoro.activeEventId;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ENFOQUE DE ESTUDIO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Seleccionar Tarea o Asignatura',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: colors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  pomodoro.phase == PomodoroPhase.focus && !pomodoro.isIdle
                      ? 'Si cambias de actividad ahora, el tiempo acumulado se registrará en la tarea anterior y la nueva continuará con los minutos restantes.'
                      : 'Elige una tarea específica para registrar pomodoros en su progreso, o una sesión libre por materia.',
                  style: TextStyle(
                    fontSize: 12,
                    color: pomodoro.phase == PomodoroPhase.focus && !pomodoro.isIdle
                        ? AppColors.primary
                        : colors.textSecondary,
                    fontWeight: pomodoro.phase == PomodoroPhase.focus && !pomodoro.isIdle
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                if (subjects.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_outlined, size: 48, color: colors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'No tienes asignaturas creadas',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textPrimary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              context.push('/create-subject');
                            },
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Crear Asignatura'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: subjects.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        final subColor = subject.displayColor(colors.isDark);
                        final relatedEvents = events.where((e) => e.subjectId == subject.id && !e.isCompleted).toList();
                        final isSubjectActive = activeSubjectId == subject.id;

                        return Container(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSubjectActive ? subColor : colors.border,
                              width: isSubjectActive ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              initiallyExpanded: isSubjectActive,
                              tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: subColor.withValues(alpha: colors.isDark ? 0.25 : 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(subject.iconData, color: subColor, size: 22),
                              ),
                              title: Text(
                                subject.name,
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: colors.textPrimary),
                              ),
                              subtitle: Text(
                                relatedEvents.isNotEmpty
                                    ? '${relatedEvents.length} actividades pendientes'
                                    : 'Sin actividades pendientes',
                                style: TextStyle(fontSize: 12, color: colors.textSecondary),
                              ),
                              children: [
                                const Divider(height: 1, indent: 16, endIndent: 16),
                                // Opción 1: Sesión libre de la asignatura
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                  leading: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: isSubjectActive && activeEventId == null
                                          ? subColor.withValues(alpha: 0.2)
                                          : colors.surfaceVariant,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.menu_book_rounded,
                                      size: 16,
                                      color: isSubjectActive && activeEventId == null ? subColor : colors.textSecondary,
                                    ),
                                  ),
                                  title: Text(
                                    'Sesión libre de ${subject.name}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSubjectActive && activeEventId == null ? FontWeight.bold : FontWeight.w600,
                                      color: isSubjectActive && activeEventId == null ? subColor : colors.textPrimary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Estudio general sin vincular a una tarea',
                                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                                  ),
                                  trailing: isSubjectActive && activeEventId == null
                                      ? Icon(Icons.check_circle_rounded, color: subColor, size: 20)
                                      : null,
                                  onTap: () async {
                                    final wasFocusMidSession = pomodoro.phase == PomodoroPhase.focus && !pomodoro.isIdle;
                                    await ref.read(pomodoroProvider.notifier).selectSubjectAndEvent(subject.id, null);
                                    ref.read(unboundedSessionProvider.notifier).selectSubjectAndEvent(subject.id, null);
                                    if (ctx.mounted) Navigator.pop(ctx);
                                    if (wasFocusMidSession && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Tiempo acumulado registrado. Continuando en: ${subject.name}'),
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),

                                // Opción 2: Cada compromiso / tarea pendiente de la asignatura
                                if (relatedEvents.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'TAREAS Y EVALUACIONES DE ESTA MATERIA:',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: colors.textSecondary,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...relatedEvents.map((event) {
                                    final isThisEventActive = activeEventId == event.id;
                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                      leading: AppChip(
                                        label: event.type.displayName,
                                        variant: AppChipVariant.custom,
                                        customBackgroundColor: event.type.backgroundColor,
                                        customForegroundColor: event.type.color,
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        borderRadius: BorderRadius.circular(8),
                                        textStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      title: Text(
                                        event.title,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isThisEventActive ? FontWeight.bold : FontWeight.w600,
                                          color: isThisEventActive ? AppColors.primary : colors.textPrimary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Avance: ${event.completedPomodoros}/${event.targetPomodoros} bloques · ${TimeUtils.formatEventDate(event.dueAt)}',
                                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                                      ),
                                      trailing: isThisEventActive
                                          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                                          : null,
                                      onTap: () async {
                                        final wasFocusMidSession = pomodoro.phase == PomodoroPhase.focus && !pomodoro.isIdle;
                                        await ref.read(pomodoroProvider.notifier).selectSubjectAndEvent(subject.id, event.id);
                                        ref.read(unboundedSessionProvider.notifier).selectSubjectAndEvent(subject.id, event.id);
                                        if (ctx.mounted) Navigator.pop(ctx);
                                        if (wasFocusMidSession && context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Tiempo acumulado registrado. Continuando en: ${event.title}'),
                                              behavior: SnackBarBehavior.floating,
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }),
                                ],
                                const SizedBox(height: 6),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      );
    },
  );
}
