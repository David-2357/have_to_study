import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../shared/utils/time_utils.dart';
import '../../../shared/widgets/app_chip.dart';
import '../../../core/providers.dart';
import '../../academic_events/domain/academic_event_model.dart';
import '../../academic_events/presentation/create_event_sheet.dart';

class SubjectDetailScreen extends ConsumerStatefulWidget {
  final String subjectId;

  const SubjectDetailScreen({super.key, required this.subjectId});

  @override
  ConsumerState<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends ConsumerState<SubjectDetailScreen> {
  AppColorTheme get colors => context.colors;
  int _selectedTab = 0; // 0: Compromisos, 1: Historial

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subjects = ref.watch(subjectsProvider);
    final events = ref.watch(academicEventsProvider);
    final sessions = ref.watch(focusSessionsProvider);

    final subject = subjects.firstWhere(
      (s) => s.id == widget.subjectId,
      orElse: () => subjects.isNotEmpty ? subjects.first : throw Exception('Subject not found'),
    );

    final subjectEvents = events.where((e) => e.subjectId == subject.id).toList();
    final pendingEvents = subjectEvents.where((e) => !e.isCompleted).toList();
    final completedEvents = subjectEvents.where((e) => e.isCompleted).toList();
    final subjectSessions = sessions.where((s) => s.subjectId == subject.id).toList();

    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final weekSubjectSessions = subjectSessions.where((s) => !s.completedAt.toLocal().isBefore(startOfWeek));
    final weekStudySeconds = weekSubjectSessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);

    final nextExam = pendingEvents.where((e) => e.type == EventType.exam).firstOrNull;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.primary),
          label: const Text('Estudios', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        leadingWidth: 110,
        title: Text(
          subject.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: colors.textPrimary),
            tooltip: 'Editar asignatura',
            onPressed: () {
              context.push('/create-subject?id=${subject.id}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
            tooltip: 'Agregar compromiso',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                builder: (context) => CreateEventSheet(preselectedSubjectId: subject.id),
              );
            },
          ),
          IconButton(
            icon: Icon(
              subject.isPassed ? Icons.verified_rounded : Icons.verified_outlined,
              color: subject.isPassed ? AppColors.teal : colors.textSecondary,
            ),
            tooltip: subject.isPassed ? 'Desmarcar de aprobada' : 'Marcar como aprobada al terminar curso',
            onPressed: () async {
              await ref.read(subjectsProvider.notifier).togglePassed(subject.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(subject.isPassed
                        ? '${subject.name} marcada en curso activo.'
                        : '🎉 ¡Enhorabuena! Has marcado ${subject.name} como aprobada.'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              subject.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
              color: colors.textSecondary,
            ),
            tooltip: subject.isArchived ? 'Desarchivar' : 'Archivar',
            onPressed: () async {
              await ref.read(subjectsProvider.notifier).toggleArchive(subject.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(subject.isArchived ? 'Asignatura desarchivada' : 'Asignatura archivada')),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de Identidad Superior
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
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
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: subject.displayColor(colors.isDark).withValues(alpha: colors.isDark ? 0.25 : 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(subject.iconData, color: subject.displayColor(colors.isDark), size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (subject.code.isNotEmpty)
                                    Row(
                                      children: [
                                        if (subject.code.isNotEmpty) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEEF2FF),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              subject.code,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF4F46E5),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            subject.isAnnual ? 'Anual' : 'Semestral',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: colors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subject.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subject.endDate != null
                                  ? 'Finaliza: ${TimeUtils.formatEventDate(subject.endDate!)}'
                                  : (subject.lastStudiedAt != null
                                      ? 'Último: ${TimeUtils.formatRelativeDate(subject.lastStudiedAt!)}'
                                      : 'Sin sesiones aún'),
                              style: TextStyle(fontSize: 12, color: colors.textSecondary),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: subject.isPassed
                                    ? const Color(0xFFDCFCE7)
                                    : (subject.isArchived ? colors.surfaceVariant : const Color(0xFFE6F4EA)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    subject.isPassed
                                        ? Icons.verified_rounded
                                        : (subject.isArchived ? Icons.archive_outlined : Icons.check_circle_outline_rounded),
                                    size: 12,
                                    color: subject.isPassed
                                        ? const Color(0xFF15803D)
                                        : (subject.isArchived ? colors.textSecondary : const Color(0xFF137333)),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    subject.isPassed
                                        ? 'Aprobada'
                                        : (subject.isArchived ? 'Archivada' : 'En curso activo'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: subject.isPassed
                                          ? const Color(0xFF15803D)
                                          : (subject.isArchived ? colors.textSecondary : const Color(0xFF137333)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Fila de 3 Tarjetas de Métricas
              Row(
                children: [
                  _buildStatCard(
                    title: 'DEDICADO',
                    val: TimeUtils.formatDurationHoursMinutes(subject.totalStudySeconds),
                    sub: weekStudySeconds > 0
                        ? '+${TimeUtils.formatDurationHoursMinutes(weekStudySeconds)} esta sem.'
                        : '0m esta semana',
                    icon: Icons.access_time_rounded,
                    iconColor: AppColors.info,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    title: 'POMODOROS',
                    val: '${subject.completedPomodoros} pomos',
                    sub: 'Progreso constante',
                    icon: Icons.hourglass_empty_rounded,
                    iconColor: AppColors.primary,
                    showProgress: true,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    title: 'ENTREGAS',
                    val: '${pendingEvents.length}',
                    sub: 'por entregar',
                    icon: Icons.inbox_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Botón Destacado: Iniciar Pomodoro de [Subject]
              InkWell(
                onTap: () {
                  final relatedEvent = pendingEvents.isNotEmpty ? pendingEvents.first.id : null;
                  ref.read(pomodoroProvider.notifier).selectSubjectAndEvent(subject.id, relatedEvent);
                  ref.read(pomodoroProvider.notifier).startFocus();
                  context.push('/session');
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Iniciar Pomodoro de ${subject.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Sesión de 25 min · Enfoque intensivo',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Próximo Hito Clave (si existe)
              if (nextExam != null) ...[
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
                          Row(
                            children: [
                              const AppChip(
                                label: 'PRÓXIMO HITO CLAVE',
                                icon: Icons.flag_rounded,
                                variant: AppChipVariant.primary,
                                iconSize: 12,
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                              ),
                              const SizedBox(width: 6),
                              if (nextExam.academicWeight > 0)
                                Text(
                                  'Valor ${nextExam.academicWeight}%',
                                  style: TextStyle(fontSize: 11, color: colors.textSecondary, fontWeight: FontWeight.w600),
                                ),
                            ],
                          ),
                          AppChip(
                            label: TimeUtils.formatRelativeDate(nextExam.dueAt),
                            variant: AppChipVariant.primary,
                            customBackgroundColor: AppColors.primary,
                            customForegroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        nextExam.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: colors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            TimeUtils.formatEventDate(nextExam.dueAt, includeTime: nextExam.hasDueTime),
                            style: TextStyle(fontSize: 12, color: colors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Preparación del examen', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                          Text('${nextExam.progressPercent}% preparado', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: nextExam.progress,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Toggle Compromisos | Historial
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EDF5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Compromisos (${pendingEvents.length})',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w600,
                              color: _selectedTab == 0 ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Historial (${subjectSessions.length})',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w600,
                              color: _selectedTab == 1 ? colors.textPrimary : colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Lista según tab
              if (_selectedTab == 0)
                _buildCommitmentsList(context, pendingEvents, completedEvents, subject)
              else
                _buildHistoryList(subjectSessions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String val,
    required String sub,
    required IconData icon,
    required Color iconColor,
    bool showProgress = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: colors.textSecondary)),
                Icon(icon, size: 14, color: iconColor),
              ],
            ),
            const SizedBox(height: 6),
            Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: colors.textPrimary)),
            if (showProgress) ...[
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(sub, style: TextStyle(fontSize: 9, color: colors.textSecondary), maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentsList(
    BuildContext context,
    List<AcademicEventModel> pending,
    List<AcademicEventModel> completed,
    dynamic subject,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => CreateEventSheet(preselectedSubjectId: subject.id),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Nuevo pendiente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        if (pending.isEmpty && completed.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No hay pendientes asociados a esta asignatura.',
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
          )
        else ...[
          ...pending.map((e) => _buildCommitmentCard(context, e, false)),
          if (completed.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Completados', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colors.textSecondary)),
            const SizedBox(height: 8),
            ...completed.map((e) => _buildCommitmentCard(context, e, true)),
          ],
        ],
      ],
    );
  }

  Widget _buildCommitmentCard(BuildContext context, AcademicEventModel event, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: event.type.color, width: 5),
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppChip(
                        label: event.type.shortTag,
                        variant: AppChipVariant.custom,
                        customBackgroundColor: event.type.backgroundColor,
                        customForegroundColor: event.type.color,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      if (event.isPriority) ...[
                        const SizedBox(width: 6),
                        AppChip(
                          label: 'PRIORITARIO',
                          icon: Icons.star_rounded,
                          variant: AppChipVariant.warning,
                          iconSize: 11,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          borderRadius: BorderRadius.circular(6),
                          textStyle: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      AppChip(
                        label: TimeUtils.formatRelativeDate(event.dueAt),
                        variant: AppChipVariant.warning,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.edit_outlined, size: 16, color: colors.textSecondary),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CreateEventSheet(eventToEdit: event),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          size: 18,
                          color: isDone ? AppColors.success : colors.textSecondary,
                        ),
                        onPressed: () async {
                          final wasCompleted = event.isCompleted;
                          await ref.read(academicEventsProvider.notifier).toggleComplete(event.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(wasCompleted ? 'Pendiente reabierto' : '¡"${event.title}" completado! 🎉'),
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
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: colors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        TimeUtils.formatEventDate(event.dueAt, includeTime: event.hasDueTime),
                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 11, color: colors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${event.completedPomodoros} / ${event.targetPomodoros} Pomos',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<dynamic> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No hay historial de sesiones para esta asignatura.', style: TextStyle(color: colors.textSecondary)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final s = sessions[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sesión de concentración completada', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(TimeUtils.formatEventDate(s.completedAt, includeTime: true), style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                    ],
                  ),
                ],
              ),
              Text(
                TimeUtils.formatDurationHoursMinutes(s.durationSeconds),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}
