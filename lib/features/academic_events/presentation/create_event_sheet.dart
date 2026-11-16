import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers.dart';
import '../domain/academic_event_model.dart';

class CreateEventSheet extends ConsumerStatefulWidget {
  final String? preselectedSubjectId;
  final AcademicEventModel? eventToEdit;
  final DateTime? initialDate;

  const CreateEventSheet({
    super.key,
    this.preselectedSubjectId,
    this.eventToEdit,
    this.initialDate,
  });

  @override
  ConsumerState<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends ConsumerState<CreateEventSheet> {
  late EventType _selectedType;
  late String _selectedSubjectId;
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late final TextEditingController _weightController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late bool _includeTime;
  late int _targetPomodoros;
  late bool _isPriority;

  bool get _isEditing => widget.eventToEdit != null;

  @override
  void initState() {
    super.initState();
    final event = widget.eventToEdit;
    final subjects = ref.read(subjectsProvider);

    _selectedType = event?.type ?? EventType.exam;
    _selectedSubjectId = event?.subjectId ??
        widget.preselectedSubjectId ??
        (subjects.isNotEmpty ? subjects.first.id : '');

    _titleController = TextEditingController(
      text: event?.title ?? '',
    );
    _notesController = TextEditingController(
      text: event?.description ?? '',
    );
    _weightController = TextEditingController(
      text: event != null && event.academicWeight > 0 ? event.academicWeight.toString() : '',
    );

    _selectedDate = event?.dueAt ?? widget.initialDate ?? DateTime.now().add(const Duration(days: 3));
    _selectedTime = event != null
        ? TimeOfDay(hour: event.dueAt.hour, minute: event.dueAt.minute)
        : const TimeOfDay(hour: 10, minute: 0);
    _includeTime = event?.hasDueTime ?? true;
    _targetPomodoros = event?.targetPomodoros ?? 8;
    _isPriority = event?.isPriority ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectsProvider).where((s) => !s.isArchived).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tirador central
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditing ? 'EDITAR COMPROMISO' : 'NUEVO COMPROMISO',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isEditing ? 'Editar Pendiente Académico' : 'Crear Pendiente Académico',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tipo de Actividad
            Text(
              'TIPO DE ACTIVIDAD',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTypeCard(EventType.exam, 'Examen\nParcial/Final', Icons.edit_calendar_rounded),
                const SizedBox(width: 8),
                _buildTypeCard(EventType.assignment, 'Entrega\nProyecto', Icons.folder_zip_rounded),
                const SizedBox(width: 8),
                _buildTypeCard(EventType.academicActivity, 'Taller\no Quiz', Icons.checklist_rounded),
              ],
            ),

            const SizedBox(height: 16),

            // Asignatura Vinculada
            Text(
              'ASIGNATURA VINCULADA',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: subjects.map((sub) {
                  final isSelected = _selectedSubjectId == sub.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSubjectId = sub.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : sub.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              sub.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            if (sub.code.isNotEmpty) ...[
                              const SizedBox(width: 4),
                              Text(
                                sub.code,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Título de la Evaluación
            Text(
              'TÍTULO DE LA EVALUACIÓN',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Ej. Parcial de Matemáticas'),
            ),

            const SizedBox(height: 14),

            // Temario o Notas Clave
            Text(
              'TEMARIO O NOTAS CLAVE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Temas, enlaces o materiales permitidos...'),
            ),

            const SizedBox(height: 14),

            // Fecha y Switch de Hora
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FECHA LÍMITE',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF4F46E5)),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('E, d MMM', 'es').format(_selectedDate),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'INCLUIR HORA',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          Switch(
                            value: _includeTime,
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppColors.primary,
                            onChanged: (val) => setState(() => _includeTime = val),
                          ),
                        ],
                      ),
                      if (_includeTime)
                        InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) {
                              setState(() => _selectedTime = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF4F46E5)),
                                const SizedBox(width: 6),
                                Text(
                                  _selectedTime.format(context),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Ponderación en nota final (exacto al diseño Nuevo Pendiente - Modal.png)
            Text(
              'PONDERACIÓN EN NOTA FINAL (OPCIONAL)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.percent_rounded, color: Color(0xFF0D9488), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Peso Académico',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '30',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        suffixText: '%',
                        suffixStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Meta de Pomodoros
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Meta de Pomodoros',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.remove_rounded, size: 18),
                          onPressed: () {
                            if (_targetPomodoros > 1) {
                              setState(() => _targetPomodoros--);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$_targetPomodoros',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          onPressed: () {
                            if (_targetPomodoros < 50) {
                              setState(() => _targetPomodoros++);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Nota de privacidad
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off_rounded, size: 14, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text(
                  'Guardado inmediato en la memoria local del dispositivo',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Botón Guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor escribe un título')),
                    );
                    return;
                  }

                  final dueDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _includeTime ? _selectedTime.hour : 23,
                    _includeTime ? _selectedTime.minute : 59,
                  );

                  if (_isEditing && widget.eventToEdit != null) {
                    final updated = widget.eventToEdit!.copyWith(
                      subjectId: _selectedSubjectId,
                      title: _titleController.text.trim(),
                      type: _selectedType,
                      description: _notesController.text.trim(),
                      dueAt: dueDateTime,
                      hasDueTime: _includeTime,
                      targetPomodoros: _targetPomodoros,
                      academicWeight: int.tryParse(_weightController.text) ?? 0,
                      isPriority: _isPriority,
                    );
                    await ref.read(academicEventsProvider.notifier).updateEvent(updated);
                  } else {
                    await ref.read(academicEventsProvider.notifier).createEvent(
                          subjectId: _selectedSubjectId,
                          title: _titleController.text.trim(),
                          type: _selectedType,
                          description: _notesController.text.trim(),
                          dueAt: dueDateTime,
                          hasDueTime: _includeTime,
                          targetPomodoros: _targetPomodoros,
                          academicWeight: int.tryParse(_weightController.text) ?? 0,
                          isPriority: _isPriority,
                        );
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(_isEditing ? 'Guardar Cambios' : 'Guardar Compromiso'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Descartar y Volver', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(EventType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? type.backgroundColor : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? type.color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? type.color : AppColors.textSecondary, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? type.color : AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
