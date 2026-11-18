import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../core/providers.dart';
import '../../../shared/utils/time_utils.dart';
import '../../../shared/widgets/app_chip.dart';
import '../domain/subject_model.dart';

enum SubjectClosureDecision {
  continues,  // Continúa el próximo ciclo
  passed,     // Aprobada
  archived,   // No continúa / Se archiva
}

class CourseClosureScreen extends ConsumerStatefulWidget {
  final bool onlyExpired;

  const CourseClosureScreen({
    super.key,
    this.onlyExpired = false,
  });

  @override
  ConsumerState<CourseClosureScreen> createState() => _CourseClosureScreenState();
}

class _CourseClosureScreenState extends ConsumerState<CourseClosureScreen> {
  AppColorTheme get colors => context.colors;
  // Decisiones por asignatura: { subjectId: SubjectClosureDecision }
  final Map<String, SubjectClosureDecision> _decisions = {};
  // Fechas de prórroga para las que continúan: { subjectId: DateTime }
  final Map<String, DateTime> _nextStartDates = {};
  final Map<String, DateTime> _nextEndDates = {};
  bool _initialized = false;

  void _initDecisions(List<SubjectModel> targetSubjects) {
    if (_initialized) return;
    for (final s in targetSubjects) {
      // Por defecto para expiradas: sugiere aprobada o continuar
      _decisions[s.id] = SubjectClosureDecision.passed;
      final nextDates = TimeUtils.calculateNextSubjectCycleDates(
        isAnnual: s.isAnnual,
        previousStartDate: s.startDate,
        previousEndDate: s.endDate,
      );
      _nextStartDates[s.id] = nextDates.nextStartDate;
      _nextEndDates[s.id] = nextDates.nextEndDate;
    }
    _initialized = true;
  }

  Future<void> _selectNewDates(BuildContext context, SubjectModel subject) async {
    final currentStart = _nextStartDates[subject.id] ?? DateTime.now();
    final currentEnd = _nextEndDates[subject.id] ?? DateTime.now().add(const Duration(days: 120));

    final initialStart = currentStart.isBefore(DateTime.now()) ? DateTime.now() : currentStart;
    final initialEnd = currentEnd.isAfter(initialStart) ? currentEnd : initialStart.add(const Duration(days: 120));

    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: 'PERIODO DEL PRÓXIMO CURSO',
      confirmText: 'ESTABLECER',
      cancelText: 'CANCELAR',
    );
    if (pickedRange != null) {
      setState(() {
        _nextStartDates[subject.id] = pickedRange.start;
        _nextEndDates[subject.id] = pickedRange.end;
      });
    }
  }

  Future<void> _applyClosure(List<SubjectModel> subjects) async {
    final updatedList = <SubjectModel>[];
    int passedCount = 0;
    int continuesCount = 0;
    int archivedCount = 0;

    for (final s in subjects) {
      final decision = _decisions[s.id];
      if (decision == null) continue;

      switch (decision) {
        case SubjectClosureDecision.continues:
          final nextDates = TimeUtils.calculateNextSubjectCycleDates(
            isAnnual: s.isAnnual,
            previousStartDate: s.startDate,
            previousEndDate: s.endDate,
          );
          final nextStart = _nextStartDates[s.id] ?? nextDates.nextStartDate;
          final nextEnd = _nextEndDates[s.id] ?? nextDates.nextEndDate;
          updatedList.add(s.copyWith(
            startDate: nextStart,
            endDate: nextEnd,
            isPassed: false,
            isArchived: false,
          ));
          continuesCount++;
          break;

        case SubjectClosureDecision.passed:
          updatedList.add(s.copyWith(
            isPassed: true,
            isArchived: false,
          ));
          passedCount++;
          break;

        case SubjectClosureDecision.archived:
          updatedList.add(s.copyWith(
            isPassed: false,
            isArchived: true,
          ));
          archivedCount++;
          break;
      }
    }

    if (updatedList.isNotEmpty) {
      await ref.read(subjectsProvider.notifier).updateSubjects(updatedList);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cierre aplicado: $passedCount aprobadas, $continuesCount continúan, $archivedCount archivadas.',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F766E),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/pomodoro');
    }
  }

  @override
  Widget build(BuildContext context) {
    final allSubjects = ref.watch(subjectsProvider);
    final now = DateTime.now();

    // Filtrar asignaturas objetivo
    final List<SubjectModel> targetSubjects;
    if (widget.onlyExpired) {
      targetSubjects = allSubjects.where((s) {
        if (s.isArchived || s.isPassed) return false;
        if (s.endDate == null) return false;
        return now.isAfter(s.endDate!);
      }).toList();
    } else {
      // Manual desde ajustes: todas las materias activas
      targetSubjects = allSubjects.where((s) => !s.isArchived && !s.isPassed).toList();
    }

    _initDecisions(targetSubjects);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          widget.onlyExpired ? 'Fin de Periodo Académico' : 'Cierre de Fin de Curso',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (widget.onlyExpired)
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/pomodoro');
                }
              },
              child: const Text('Más tarde', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: targetSubjects.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                _buildHeaderBanner(targetSubjects.length),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: targetSubjects.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final subject = targetSubjects[index];
                      return _buildSubjectClosureCard(context, subject, now);
                    },
                  ),
                ),
                _buildBottomActionBar(targetSubjects),
              ],
            ),
    );
  }

  Widget _buildHeaderBanner(int count) {
    final isDark = colors.isDark;

    final Color bannerBg;
    final Color bannerBorder;
    final Color iconColor;
    final Color titleColor;
    final Color subtitleColor;

    if (widget.onlyExpired) {
      bannerBg = isDark ? const Color(0xFF78350F).withValues(alpha: 0.25) : const Color(0xFFFFFBEB);
      bannerBorder = isDark ? const Color(0xFFD97706).withValues(alpha: 0.45) : const Color(0xFFFDE68A);
      iconColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
      titleColor = isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E);
      subtitleColor = isDark ? const Color(0xFFFCD34D).withValues(alpha: 0.85) : const Color(0xFFB45309);
    } else {
      bannerBg = isDark ? AppColors.primary.withValues(alpha: 0.15) : const Color(0xFFEEF2FF);
      bannerBorder = isDark ? AppColors.primary.withValues(alpha: 0.35) : const Color(0xFFC7D2FE);
      iconColor = isDark ? const Color(0xFF818CF8) : AppColors.primary;
      titleColor = isDark ? const Color(0xFFE0E7FF) : const Color(0xFF1E1B4B);
      subtitleColor = isDark ? const Color(0xFFC7D2FE).withValues(alpha: 0.85) : const Color(0xFF4338CA);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bannerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.onlyExpired ? Icons.schedule_rounded : Icons.school_rounded,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.onlyExpired
                      ? '$count asignaturas han finalizado su fecha límite'
                      : 'Clasificación de asignaturas ($count activas)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.onlyExpired
                      ? 'Selecciona cuáles continuarán el próximo ciclo y cuáles has aprobado o finalizado.'
                      : 'Marca las asignaturas que continúas cursando, las que has aprobado y las que finalizan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectClosureCard(BuildContext context, SubjectModel subject, DateTime now) {
    final decision = _decisions[subject.id] ?? SubjectClosureDecision.passed;
    final fallbackDates = TimeUtils.calculateNextSubjectCycleDates(
      isAnnual: subject.isAnnual,
      previousStartDate: subject.startDate,
      previousEndDate: subject.endDate,
    );
    final nextStartDate = _nextStartDates[subject.id] ?? fallbackDates.nextStartDate;
    final nextEndDate = _nextEndDates[subject.id] ?? fallbackDates.nextEndDate;

    final isExpired = subject.endDate != null && now.isAfter(subject.endDate!);
    final isDark = colors.isDark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpired
              ? (isDark ? const Color(0xFFB45309) : const Color(0xFFFCD34D))
              : colors.border,
          width: isExpired ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera: Icono, Nombre, Modalidad, Estado de fecha
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: subject.displayColor(colors.isDark).withValues(alpha: colors.isDark ? 0.25 : 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(subject.iconData, color: subject.displayColor(colors.isDark), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        AppChip(
                          label: subject.isAnnual ? 'Anual' : 'Semestral',
                          variant: AppChipVariant.neutral,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          borderRadius: BorderRadius.circular(6),
                          textStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subject.endDate != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            isExpired ? Icons.warning_amber_rounded : Icons.event_rounded,
                            size: 13,
                            color: isExpired
                                ? (isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706))
                                : colors.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isExpired
                                ? 'Finalizó: ${DateFormat('d MMM yyyy', 'es').format(subject.endDate!)}'
                                : 'Finaliza: ${DateFormat('d MMM yyyy', 'es').format(subject.endDate!)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isExpired ? FontWeight.bold : FontWeight.normal,
                              color: isExpired
                                  ? (isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706))
                                  : colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Selector de Decisión: [ 🎓 Aprobada ] [ 🟢 Sigue ] [ ⚪ Archivar ]
          Row(
            children: [
              _buildDecisionButton(
                title: 'Aprobada',
                icon: Icons.verified_rounded,
                selected: decision == SubjectClosureDecision.passed,
                activeColor: isDark ? const Color(0xFF0D9488) : const Color(0xFF0F766E),
                onTap: () {
                  setState(() => _decisions[subject.id] = SubjectClosureDecision.passed);
                },
              ),
              const SizedBox(width: 8),
              _buildDecisionButton(
                title: 'Sigue',
                icon: Icons.autorenew_rounded,
                selected: decision == SubjectClosureDecision.continues,
                activeColor: AppColors.primary,
                onTap: () {
                  setState(() => _decisions[subject.id] = SubjectClosureDecision.continues);
                },
              ),
              const SizedBox(width: 8),
              _buildDecisionButton(
                title: 'No sigue',
                icon: Icons.archive_outlined,
                selected: decision == SubjectClosureDecision.archived,
                activeColor: isDark ? const Color(0xFF475569) : Colors.grey.shade700,
                onTap: () {
                  setState(() => _decisions[subject.id] = SubjectClosureDecision.archived);
                },
              ),
            ],
          ),

          // Si la decisión es que sigue, mostrar selector del periodo del próximo curso
          if (decision == SubjectClosureDecision.continues) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primary.withValues(alpha: 0.15) : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.primary.withValues(alpha: 0.35) : const Color(0xFFC7D2FE),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4338CA),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Próximo curso: ${DateFormat('d MMM yyyy', 'es').format(nextStartDate)} – ${DateFormat('d MMM yyyy', 'es').format(nextEndDate)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFFE0E7FF) : const Color(0xFF312E81),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _selectNewDates(context, subject),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            'Cambiar',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isDark ? const Color(0xFF818CF8) : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.hourglass_empty_rounded,
                        size: 12,
                        color: isDark ? const Color(0xFFC7D2FE).withValues(alpha: 0.8) : const Color(0xFF4338CA),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Permanecerá inactiva hasta el ${DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(nextStartDate)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFFC7D2FE).withValues(alpha: 0.85) : const Color(0xFF4338CA),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDecisionButton({
    required String title,
    required IconData icon,
    required bool selected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? activeColor : colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? activeColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? Colors.white : colors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(List<SubjectModel> subjects) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _applyClosure(subjects),
            icon: const Icon(Icons.check_circle_rounded, size: 20),
            label: Text(
              'Confirmar Clasificación (${subjects.length})',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.isDark ? const Color(0xFF064E3B).withValues(alpha: 0.35) : const Color(0xFFF0FDF4),
                shape: BoxShape.circle,
                border: Border.all(color: colors.isDark ? const Color(0xFF059669).withValues(alpha: 0.5) : const Color(0xFFBBF7D0)),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF16A34A),
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.onlyExpired
                  ? '¡Todo al día!'
                  : 'Sin asignaturas activas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.onlyExpired
                  ? 'No hay asignaturas cuya fecha límite haya expirado.'
                  : 'No tienes asignaturas activas pendientes de cierre.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/pomodoro');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
