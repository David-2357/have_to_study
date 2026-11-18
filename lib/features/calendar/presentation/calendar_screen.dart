import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../shared/utils/time_utils.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/student_avatar.dart';
import '../../../shared/widgets/app_chip.dart';
import '../../../core/providers.dart';
import '../../academic_events/domain/academic_event_model.dart';
import '../../subjects/domain/subject_model.dart';
import '../../academic_events/presentation/create_event_sheet.dart';
import '../../../shared/widgets/academic_event_card.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  AppColorTheme get colors => context.colors;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final events = ref.watch(academicEventsProvider);
    final subjects = ref.watch(subjectsProvider);

    // Eventos para el día seleccionado normalizados en fecha local
    final dayEvents = events.where((e) {
      final localDue = e.dueAt.toLocal();
      final localSelected = _selectedDay.toLocal();
      return localDue.year == localSelected.year &&
          localDue.month == localSelected.month &&
          localDue.day == localSelected.day;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(
                subtitle: 'Calendario',
                trailing: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_rounded, size: 20, color: Color(0xFF4F46E5)),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CreateEventSheet(initialDate: _selectedDay),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: StudentAvatar(
                        profile: ref.watch(profileProvider),
                        size: 36,
                        borderRadius: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // Hint pill
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.isDark ? AppColors.primary.withValues(alpha: 0.22) : const Color(0xFFFDE8E8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.touch_app_rounded,
                        color: colors.isDark ? const Color(0xFFF87171) : AppColors.primary,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Toca un día para ver lo que sucede y revisar sus actividades',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Tarjeta del Calendario
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header con Navegación y Botón "Hoy"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('MMMM yyyy', 'es').format(_focusedDay).capitalize(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.chevron_left_rounded, size: 20),
                                  onPressed: () {
                                    final prevMonth = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                                    if (!prevMonth.isBefore(DateTime.utc(2020, 1, 1))) {
                                      setState(() {
                                        _focusedDay = prevMonth;
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _focusedDay = DateTime.now();
                                      _selectedDay = DateTime.now();
                                    });
                                  },
                                  child: Text(
                                    'Hoy: ${DateTime.now().day}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.chevron_right_rounded, size: 20),
                                  onPressed: () {
                                    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                                    if (!nextMonth.isAfter(DateTime.utc(2040, 12, 31))) {
                                      setState(() {
                                        _focusedDay = nextMonth;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Widget TableCalendar
                      TableCalendar<AcademicEventModel>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2040, 12, 31),
                        focusedDay: _focusedDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        headerVisible: false,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                        eventLoader: (day) {
                          final localDay = day.toLocal();
                          return events.where((e) {
                            final localDue = e.dueAt.toLocal();
                            return localDue.year == localDay.year &&
                                localDue.month == localDay.month &&
                                localDue.day == localDay.day;
                          }).toList();
                        },
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: true,
                          outsideTextStyle: TextStyle(color: colors.textMuted, fontSize: 13),
                          defaultTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: colors.textPrimary),
                          weekendTextStyle: const TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 13),
                          todayDecoration: BoxDecoration(
                            color: colors.isDark ? const Color(0xFF28344C) : const Color(0xFFEEF2FF),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(
                            color: Color(0xFF818CF8),
                            fontWeight: FontWeight.bold,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, dayEvents) {
                            // Si solo hay actividades completadas en un día (o no hay ninguna), no debe haber ningún punto
                            final pendingDayEvents = dayEvents.where((e) => !e.isCompleted).toList();
                            if (pendingDayEvents.isEmpty) return const SizedBox.shrink();

                            return Positioned(
                              bottom: 4,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: pendingDayEvents.take(3).map((e) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: e.type == EventType.exam
                                          ? AppColors.primary
                                          : (e.type == EventType.assignment
                                              ? AppColors.teal
                                              : const Color(0xFF4F46E5)),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // Leyenda de Marcadores
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _LegendItem(color: AppColors.primary, label: 'Examen'),
                          _LegendItem(color: AppColors.teal, label: 'Entrega / Repaso'),
                          _LegendItem(color: Color(0xFF4F46E5), label: 'Práctica'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Cabecera DÍA SELECCIONADO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DÍA SELECCIONADO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          TimeUtils.formatFullDate(_selectedDay).capitalize(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    AppChip(
                      label: dayEvents.where((e) => !e.isCompleted).isNotEmpty
                          ? '${dayEvents.where((e) => !e.isCompleted).length} actividades'
                          : '${dayEvents.length} completadas',
                      variant: AppChipVariant.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      borderRadius: BorderRadius.circular(12),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Lista de actividades del día
              if (dayEvents.isEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.event_available_rounded, size: 36, color: AppColors.teal),
                        const SizedBox(height: 8),
                        Text(
                          'Día despejado de actividades',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Aprovecha para adelantar pomodoros libres o descansar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: colors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => CreateEventSheet(initialDate: _selectedDay),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Crear actividad aquí'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: dayEvents.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];
                    final subject = subjects.firstWhere(
                      (s) => s.id == event.subjectId,
                      orElse: () => SubjectModel(id: '', name: 'Materia General', colorValue: AppColors.primary.toARGB32()),
                    );

                    return AcademicEventCard(
                      event: event,
                      subject: subject,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: colors.textSecondary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
