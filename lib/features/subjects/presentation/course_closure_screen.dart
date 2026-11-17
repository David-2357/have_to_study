import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers.dart';
import '../../../shared/utils/time_utils.dart';
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
  // Decisiones por asignatura: { subjectId: SubjectClosureDecision }
  final Map<String, SubjectClosureDecision> _decisions = {};
  // Fechas de prórroga para las que continúan: { subjectId: DateTime }
  final Map<String, DateTime> _nextEndDates = {};
  bool _initialized = false;

  void _initDecisions(List<SubjectModel> targetSubjects) {
    if (_initialized) return;
    for (final s in targetSubjects) {
      // Por defecto para expiradas: sugiere aprobada o continuar
      _decisions[s.id] = SubjectClosureDecision.passed;
      _nextEndDates[s.id] = TimeUtils.calculateNextSubjectCycleDate(
        isAnnual: s.isAnnual,
        previousEndDate: s.endDate,
      );
    }
    _initialized = true;
  }

  Future<void> _selectNewEndDate(BuildContext context, String subjectId, bool isAnnual) async {
    final current = _nextEndDates[subjectId] ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: 'NUEVA FECHA DE FINALIZACIÓN',
      confirmText: 'ESTABLECER',
      cancelText: 'CANCELAR',
    );
    if (picked != null) {
      setState(() {
        _nextEndDates[subjectId] = picked;
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
          final nextDate = _nextEndDates[s.id] ??
              TimeUtils.calculateNextSubjectCycleDate(
                isAnnual: s.isAnnual,
                previousEndDate: s.endDate,
              );
          updatedList.add(s.copyWith(
            endDate: nextDate,
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
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.onlyExpired ? const Color(0xFFFFFBEB) : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.onlyExpired ? const Color(0xFFFDE68A) : const Color(0xFFC7D2FE),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.onlyExpired ? Icons.schedule_rounded : Icons.school_rounded,
            color: widget.onlyExpired ? const Color(0xFFD97706) : AppColors.primary,
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
                    color: widget.onlyExpired ? const Color(0xFF92400E) : const Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.onlyExpired
                      ? 'Selecciona cuáles continuarán el próximo ciclo y cuáles has aprobado o finalizado.'
                      : 'Marca las asignaturas que continúas cursando, las que has aprobado y las que finalizan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.onlyExpired ? const Color(0xFFB45309) : const Color(0xFF4338CA),
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
    final nextEndDate = _nextEndDates[subject.id] ??
        TimeUtils.calculateNextSubjectCycleDate(
          isAnnual: subject.isAnnual,
          previousEndDate: subject.endDate,
        );

    final isExpired = subject.endDate != null && now.isAfter(subject.endDate!);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpired ? const Color(0xFFFCD34D) : AppColors.border,
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
                  color: subject.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(subject.iconData, color: subject.color, size: 22),
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
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            subject.isAnnual ? 'Anual' : 'Semestral',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (subject.endDate != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            isExpired ? Icons.warning_amber_rounded : Icons.event_rounded,
                            size: 13,
                            color: isExpired ? const Color(0xFFD97706) : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isExpired
                                ? 'Finalizó: ${DateFormat('d MMM yyyy', 'es').format(subject.endDate!)}'
                                : 'Finaliza: ${DateFormat('d MMM yyyy', 'es').format(subject.endDate!)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isExpired ? FontWeight.bold : FontWeight.normal,
                              color: isExpired ? const Color(0xFFD97706) : AppColors.textSecondary,
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
                activeColor: const Color(0xFF0F766E),
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
                activeColor: Colors.grey.shade700,
                onTap: () {
                  setState(() => _decisions[subject.id] = SubjectClosureDecision.archived);
                },
              ),
            ],
          ),

          // Si la decisión es que sigue, mostrar selector de la nueva fecha de finalización
          if (decision == SubjectClosureDecision.continues) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF4338CA)),
                      const SizedBox(width: 6),
                      Text(
                        'Próximo fin: ${DateFormat('d MMMM yyyy', 'es').format(nextEndDate)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF312E81),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _selectNewEndDate(context, subject.id, subject.isAnnual),
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        'Cambiar',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
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
            color: selected ? activeColor : AppColors.surfaceVariant,
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
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.textPrimary,
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
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
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
                color: const Color(0xFFF0FDF4),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBBF7D0)),
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
                color: AppColors.textPrimary,
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
                color: AppColors.textSecondary,
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
