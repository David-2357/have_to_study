import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_theme.dart';
import '../../../../core/providers.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../subjects/domain/subject_model.dart';
import '../../../academic_events/domain/academic_event_model.dart';
import '../../domain/pomodoro_models.dart';

/// Bottom sheet para editar los detalles de un bloque o pomodoro registrado.
class EditSessionSheet extends ConsumerStatefulWidget {
  final FocusSessionModel session;

  const EditSessionSheet({
    super.key,
    required this.session,
  });

  static Future<void> show(BuildContext context, FocusSessionModel session) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EditSessionSheet(session: session),
    );
  }

  @override
  ConsumerState<EditSessionSheet> createState() => _EditSessionSheetState();
}

class _EditSessionSheetState extends ConsumerState<EditSessionSheet> {
  late TextEditingController _durationMinutesController;
  String? _selectedSubjectId;
  String? _selectedEventId;
  late DateTime _completedAt;

  static const List<int> _quickMinutes = [15, 20, 25, 30, 45, 50, 60];

  @override
  void initState() {
    super.initState();
    final initialMinutes = (widget.session.durationSeconds / 60).round().clamp(1, 999);
    _durationMinutesController = TextEditingController(text: initialMinutes.toString());
    _selectedSubjectId = widget.session.subjectId;
    _selectedEventId = widget.session.academicEventId;
    _completedAt = widget.session.completedAt;
  }

  @override
  void dispose() {
    _durationMinutesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _completedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_completedAt),
    );

    if (pickedTime == null || !mounted) return;

    setState(() {
      _completedAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _saveChanges() async {
    final parsedMinutes = int.tryParse(_durationMinutesController.text.trim());
    if (parsedMinutes == null || parsedMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor introduce una duración válida en minutos.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newDurationSeconds = parsedMinutes * 60;
    final newStartedAt = _completedAt.subtract(Duration(seconds: newDurationSeconds));

    final updated = widget.session.copyWith(
      durationSeconds: newDurationSeconds,
      startedAt: newStartedAt,
      completedAt: _completedAt,
      subjectId: _selectedSubjectId,
      academicEventId: _selectedEventId,
      clearSubject: _selectedSubjectId == null,
      clearEvent: _selectedEventId == null,
    );

    await ref.read(focusSessionsProvider.notifier).updateSession(updated);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pomodoro actualizado correctamente.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF16A34A),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subjects = ref.watch(subjectsProvider);
    final events = ref.watch(academicEventsProvider);

    // Actividades de la asignatura elegida
    final availableEvents = _selectedSubjectId != null
        ? events.where((e) => e.subjectId == _selectedSubjectId).toList()
        : <AcademicEventModel>[];

    final int currentDurationMins = int.tryParse(_durationMinutesController.text.trim()) ?? 0;
    final formattedDate = DateFormat("d 'de' MMMM, yyyy • HH:mm", 'es').format(_completedAt);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: colors.border),
          left: BorderSide(color: colors.border),
          right: BorderSide(color: colors.border),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de arrastre superior
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Título y botón cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Editar Pomodoro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: colors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 1. DURACIÓN
              Text(
                'DURACIÓN DEL BLOQUE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: colors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _durationMinutesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: '25',
                        suffixText: 'minutos',
                        suffixStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: colors.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Chips de duración rápida
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _quickMinutes.map((mins) {
                  final isSelected = currentDurationMins == mins;
                  return InkWell(
                    onTap: () {
                      _durationMinutesController.text = mins.toString();
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : colors.surfaceVariant.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : colors.border,
                        ),
                      ),
                      child: Text(
                        '$mins min',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? Colors.white : colors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // 2. ASIGNATURA
              Text(
                'ASIGNATURA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: colors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selectedSubjectId,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down_rounded, color: colors.textSecondary),
                    dropdownColor: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colors.textSecondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'General / Sin asignatura',
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...subjects.map((sub) {
                        final color = sub.displayColor(colors.isDark);
                        return DropdownMenuItem<String?>(
                          value: sub.id,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  sub.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (sub.code.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                AppChip(
                                  label: sub.code,
                                  variant: AppChipVariant.info,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  borderRadius: BorderRadius.circular(6),
                                  textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ],
                    onChanged: (newSubjectId) {
                      setState(() {
                        _selectedSubjectId = newSubjectId;
                        // Si la actividad ya no pertenece a la asignatura, reiniciar
                        if (_selectedEventId != null) {
                          final match = events.where((e) => e.id == _selectedEventId).firstOrNull;
                          if (match == null || match.subjectId != newSubjectId) {
                            _selectedEventId = null;
                          }
                        }
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. ACTIVIDAD (SI HAY ASIGNATURA SELECCIONADA)
              if (_selectedSubjectId != null) ...[
                Text(
                  'ACTIVIDAD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: colors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _selectedEventId,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down_rounded, color: colors.textSecondary),
                      dropdownColor: colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            'Sesión libre (sin actividad específica)',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...availableEvents.map((event) {
                          return DropdownMenuItem<String?>(
                            value: event.id,
                            child: Row(
                              children: [
                                AppChip(
                                  label: event.type.displayName,
                                  variant: AppChipVariant.custom,
                                  customBackgroundColor: event.type.displayBackgroundColor(colors.isDark),
                                  customForegroundColor: event.type.displayForegroundColor(colors.isDark),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  borderRadius: BorderRadius.circular(4),
                                  textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    event.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      decoration: event.isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      onChanged: (newEventId) {
                        setState(() => _selectedEventId = newEventId);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 4. FECHA Y HORA
              Text(
                'FECHA Y HORA DE FINALIZACIÓN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: colors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(Icons.edit_calendar_rounded, size: 18, color: colors.textSecondary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Botones de acción inferior
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: colors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Guardar cambios',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
}
