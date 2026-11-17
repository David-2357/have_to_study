import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/time_utils.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../core/providers.dart';
import '../domain/subject_model.dart';
import '../../academic_events/domain/academic_event_model.dart';
import '../../academic_events/presentation/create_event_sheet.dart';
import '../../academic_events/presentation/widgets/academic_event_card.dart';

class StudiesScreen extends ConsumerStatefulWidget {
  const StudiesScreen({super.key});

  @override
  ConsumerState<StudiesScreen> createState() => _StudiesScreenState();
}

class _StudiesScreenState extends ConsumerState<StudiesScreen> {
  int _selectedTab = 0; // 0: Asignaturas, 1: Pendientes
  String _searchQuery = '';
  int _subjectFilter = 0; // 0: Todas, 1: Con entregas, 2: Archivadas
  int _eventFilter = 0; // 0: Todos, 1: Exámenes, 2: Entregas, 3: Talleres
  bool _isInactiveExpanded = false;
  bool _isCompletedExpanded = false;

  // Map para saber qué tarjetas de pendientes están expandidas
  final Set<String> _expandedEvents = {};

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectsProvider);
    final events = ref.watch(academicEventsProvider);

    final pendingEvents = events.where((e) => !e.isCompleted).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                subtitle: _selectedTab == 0 ? 'Asignaturas' : 'Pendientes',
              ),

              // Cabecera con Título y Botón "+ Nueva"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedTab == 0 ? 'Asignaturas' : 'Pendientes y Entregas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedTab == 0
                              ? '${subjects.where((s) => !s.isArchived && !s.isPassed).length} materias activas'
                              : '${pendingEvents.length} compromisos próximos esta semana',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_selectedTab == 0) {
                          context.push('/create-subject');
                        } else {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const CreateEventSheet(),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(_selectedTab == 0 ? 'Nueva' : 'Nuevo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Toggle Segmentado Superior [ Asignaturas ] [ Pendientes (3) ]
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
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
                              color: _selectedTab == 0 ? AppColors.surface : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _selectedTab == 0
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  size: 16,
                                  color: _selectedTab == 0 ? AppColors.textPrimary : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Asignaturas',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w600,
                                    color: _selectedTab == 0 ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                              ],
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
                              color: _selectedTab == 1 ? AppColors.surface : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _selectedTab == 1
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 16,
                                  color: _selectedTab == 1 ? AppColors.textPrimary : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Pendientes',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w600,
                                    color: _selectedTab == 1 ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 1 ? AppColors.primaryLight : const Color(0xFFDCE2EE),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${pendingEvents.length}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedTab == 1 ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Buscador
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: _selectedTab == 0
                        ? 'Buscar por nombre o código...'
                        : 'Buscar examen, proyecto o taller...',
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                    fillColor: AppColors.surface,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Chips de Filtro Horizontal
              if (_selectedTab == 0)
                _buildSubjectFilterChips(subjects, events)
              else
                _buildEventFilterChips(events),

              const SizedBox(height: 16),

              // Contenido según Tab seleccionado
              if (_selectedTab == 0)
                _buildSubjectsList(context, subjects, events)
              else
                _buildEventsList(context, events, subjects),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectFilterChips(List<SubjectModel> subjects, List<AcademicEventModel> events) {
    final active = subjects.where((s) => !s.isArchived && !s.isPassed).toList();
    final withEvents = active.where((s) => events.any((e) => e.subjectId == s.id && !e.isCompleted)).length;
    final archived = subjects.where((s) => s.isArchived).length;

    final chips = [
      {'label': 'Todas (${active.length})', 'index': 0},
      {'label': 'Con entregas ($withEvents)', 'index': 1},
      {'label': 'Archivadas ($archived)', 'index': 2},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: chips.map((chip) {
          final isSelected = _subjectFilter == chip['index'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(chip['label'] as String),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (_) => setState(() => _subjectFilter = chip['index'] as int),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventFilterChips(List<AcademicEventModel> events) {
    final pending = events.where((e) => !e.isCompleted).toList();
    final exams = pending.where((e) => e.type == EventType.exam).length;
    final assignments = pending.where((e) => e.type == EventType.assignment).length;
    final activities = pending.where((e) => e.type == EventType.academicActivity).length;

    final chips = [
      {'label': 'Todos (${pending.length})', 'index': 0},
      {'label': 'Exámenes ($exams)', 'index': 1},
      {'label': 'Entregas ($assignments)', 'index': 2},
      {'label': 'Talleres ($activities)', 'index': 3},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: chips.map((chip) {
          final isSelected = _eventFilter == chip['index'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(chip['label'] as String),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (_) => setState(() => _eventFilter = chip['index'] as int),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectsList(
    BuildContext context,
    List<SubjectModel> subjects,
    List<AcademicEventModel> events,
  ) {
    var filtered = subjects.where((s) {
      if (_subjectFilter == 2) {
        return s.isArchived;
      }
      if (s.isArchived || s.isPassed) return false;
      if (_subjectFilter == 1) {
        return events.any((e) => e.subjectId == s.id && !e.isCompleted);
      }
      return true;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) {
        final query = _searchQuery.toLowerCase();
        return s.name.toLowerCase().contains(query) ||
            s.code.toLowerCase().contains(query);
      }).toList();
    }

    if (filtered.isEmpty) {
      if (subjects.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  'Aún no tienes asignaturas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Crea tus asignaturas del ciclo para organizar tus compromisos y sesiones de estudio.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.push('/create-subject'),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Crear mi primera asignatura'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Text(
            'No hay asignaturas en este filtro',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filtered.length,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final subject = filtered[index];
            final relatedEvents = events.where((e) => e.subjectId == subject.id && !e.isCompleted).toList();
            final nextExam = relatedEvents.where((e) => e.type == EventType.exam).firstOrNull;
            final pendingDeliveries = relatedEvents.where((e) => e.type != EventType.exam).length;

            return InkWell(
              onTap: () => context.push('/subject-detail?id=${subject.id}'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
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
                        left: BorderSide(color: subject.color, width: 6),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: subject.color.withValues(alpha: 0.12),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (subject.code.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      subject.code,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 12, color: Color(0xFF4F46E5)),
                                  const SizedBox(width: 4),
                                  Text(
                                    TimeUtils.formatDurationHoursMinutes(subject.totalStudySeconds),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.history_rounded, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              subject.lastStudiedAt != null
                                  ? 'Último estudio: ${TimeUtils.formatRelativeDate(subject.lastStudiedAt!)}'
                                  : 'Sin sesiones aún',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (pendingDeliveries > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.warningLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.assignment_outlined, size: 13, color: AppColors.warning),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$pendingDeliveries entregas pendientes',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warning,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (nextExam != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 13, color: Color(0xFF4F46E5)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Examen: ${TimeUtils.formatEventDate(nextExam.dueAt)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (pendingDeliveries == 0 && nextExam == null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_outline_rounded, size: 13, color: AppColors.success),
                                    SizedBox(width: 4),
                                    Text(
                                      'Todo al día',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.success,
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
            );
          },
        ),

        const SizedBox(height: 20),

        // Secciones Plegables Inferiores
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildCollapsibleSection(
                title: 'En pausa / Inactivas',
                count: subjects.where((s) => s.isArchived).length,
                icon: Icons.pause_circle_outline_rounded,
                iconColor: const Color(0xFF4F46E5),
                isExpanded: _isInactiveExpanded,
                onToggle: () => setState(() => _isInactiveExpanded = !_isInactiveExpanded),
                children: [
                  if (subjects.where((s) => s.isArchived).isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No hay asignaturas inactivas',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    )
                  else
                    ...subjects.where((s) => s.isArchived).map((subject) {
                      return Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: subject.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(subject.iconData, color: subject.color, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    subject.code.isNotEmpty ? subject.code : 'Archivada',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                ref.read(subjectsProvider.notifier).toggleArchive(subject.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${subject.name} reactivada'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.unarchive_rounded, size: 14),
                              label: const Text('Reactivar', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
              const SizedBox(height: 10),
              _buildCollapsibleSection(
                title: 'Finalizadas / Aprobadas',
                count: subjects.where((s) => s.isPassed).length,
                icon: Icons.verified_outlined,
                iconColor: AppColors.teal,
                isExpanded: _isCompletedExpanded,
                onToggle: () => setState(() => _isCompletedExpanded = !_isCompletedExpanded),
                children: [
                  if (subjects.where((s) => s.isPassed).isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No hay asignaturas marcadas como aprobadas al terminar el curso',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    )
                  else
                    ...subjects.where((s) => s.isPassed).map((subject) {
                      return InkWell(
                        onTap: () => context.push('/subject-detail?id=${subject.id}'),
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.teal.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subject.name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${subject.completedPomodoros} pomodoros dedicados',
                                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  ref.read(subjectsProvider.notifier).togglePassed(subject.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${subject.name} reactivada en curso activo.'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.replay_rounded, size: 14),
                                label: const Text('Reactivar', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 8),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildEventsList(
    BuildContext context,
    List<AcademicEventModel> events,
    List<SubjectModel> subjects,
  ) {
    var filtered = events.where((e) {
      if (e.isCompleted) return false;
      if (_eventFilter == 1) return e.type == EventType.exam;
      if (_eventFilter == 2) return e.type == EventType.assignment;
      if (_eventFilter == 3) return e.type == EventType.academicActivity;
      return true;
    }).toList();

    filtered.sort((a, b) => a.dueAt.compareTo(b.dueAt));

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((e) {
        final query = _searchQuery.toLowerCase();
        return e.title.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query);
      }).toList();
    }

    if (filtered.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Text(
            'No hay pendientes en esta categoría',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final event = filtered[index];
        final subject = subjects.firstWhere(
          (s) => s.id == event.subjectId,
          orElse: () => SubjectModel(id: '', name: 'General', colorValue: AppColors.primary.toARGB32()),
        );

        final isExpanded = _expandedEvents.contains(event.id);

        return AcademicEventCard(
          event: event,
          subject: subject,
          initialExpanded: isExpanded,
          onToggleExpand: () {
            setState(() {
              if (isExpanded) {
                _expandedEvents.remove(event.id);
              } else {
                _expandedEvents.add(event.id);
              }
            });
          },
        );
      },
    );
  }
}
