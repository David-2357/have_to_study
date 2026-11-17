import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../core/providers.dart';
import '../../../shared/utils/time_utils.dart';

class CreateSubjectScreen extends ConsumerStatefulWidget {
  final String? subjectId;

  const CreateSubjectScreen({super.key, this.subjectId});

  @override
  ConsumerState<CreateSubjectScreen> createState() => _CreateSubjectScreenState();
}

class _CreateSubjectScreenState extends ConsumerState<CreateSubjectScreen> {
  AppColorTheme get colors => context.colors;
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  String _selectedIcon = 'sigma';
  int _selectedColor = 0xFFB74134;
  int _weeklySessions = 8;
  bool _isAnnual = false; // false: Semestral, true: Anual
  late DateTime _endDate;
  bool _isEditing = false;

  static DateTime _calculateDefaultEndDate({required bool isAnnual}) {
    return TimeUtils.calculateDefaultSubjectEndDate(isAnnual: isAnnual);
  }

  static String _getMonthName(int month) {
    const months = [
      '',
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return month >= 1 && month <= 12 ? months[month] : '';
  }

  final List<Map<String, dynamic>> _icons = [
    {'key': 'sigma', 'icon': Icons.functions},
    {'key': 'book', 'icon': Icons.menu_book_rounded},
    {'key': 'code', 'icon': Icons.code_rounded},
    {'key': 'flask', 'icon': Icons.science_rounded},
    {'key': 'pencil', 'icon': Icons.edit_rounded},
    {'key': 'gear', 'icon': Icons.psychology_rounded},
    {'key': 'school', 'icon': Icons.school_rounded},
    {'key': 'calculate', 'icon': Icons.calculate_rounded},
    {'key': 'palette', 'icon': Icons.palette_rounded},
    {'key': 'music', 'icon': Icons.music_note_rounded},
    {'key': 'translate', 'icon': Icons.translate_rounded},
    {'key': 'balance', 'icon': Icons.account_balance_rounded},
    {'key': 'health', 'icon': Icons.health_and_safety_rounded},
    {'key': 'globe', 'icon': Icons.public_rounded},
    {'key': 'chart', 'icon': Icons.insert_chart_rounded},
    {'key': 'biotech', 'icon': Icons.biotech_rounded},
    {'key': 'desktop', 'icon': Icons.computer_rounded},
    {'key': 'rocket', 'icon': Icons.rocket_launch_rounded},
    {'key': 'architecture', 'icon': Icons.architecture_rounded},
    {'key': 'fitness', 'icon': Icons.fitness_center_rounded},
    {'key': 'history', 'icon': Icons.history_edu_rounded},
    {'key': 'camera', 'icon': Icons.camera_alt_rounded},
  ];

  final List<int> _colors = [
    0xFFB74134, // Terracota
    0xFF4F46E5, // Índigo
    0xFF16A085, // Verde esmeralda
    0xFFE67E22, // Naranja
    0xFF8E44AD, // Morado
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.subjectId != null;
    final subjects = ref.read(subjectsProvider);
    final subject = widget.subjectId != null
        ? subjects.firstWhere((s) => s.id == widget.subjectId, orElse: () => subjects.first)
        : null;

    _nameController = TextEditingController(text: subject?.name ?? '');
    _codeController = TextEditingController(text: subject?.code ?? '');
    if (subject != null) {
      _selectedIcon = subject.iconKey;
      _selectedColor = subject.colorValue;
      _isAnnual = subject.isAnnual;
      _endDate = subject.endDate ?? _calculateDefaultEndDate(isAnnual: subject.isAnnual);
    } else {
      _isAnnual = false;
      _endDate = _calculateDefaultEndDate(isAnnual: false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
          _isEditing ? 'Editar Asignatura' : 'Nueva Asignatura',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de Previsualización Superior
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Color(_selectedColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _icons.firstWhere((i) => i['key'] == _selectedIcon)['icon'] as IconData,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (_codeController.text.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _codeController.text,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _nameController.text.isEmpty ? 'Nombre Asignatura' : _nameController.text,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_weeklySessions pomodoros/semana · ${_isAnnual ? 'Anual' : 'Semestral'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4EA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Borrador',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF137333),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sección: Identidad Académica
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Identidad académica',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'NOMBRE DE LA ASIGNATURA',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(hintText: 'Ej. Física Cuántica'),
                    ),

                    const SizedBox(height: 14),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CÓDIGO (OPCIONAL)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _codeController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(hintText: 'Ej. FIS-201'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'ICONO TEMÁTICO',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF2F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: _icons.map((item) {
                          final isSelected = _selectedIcon == item['key'];
                          return GestureDetector(
                            onTap: () => setState(() => _selectedIcon = item['key'] as String),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: isSelected ? AppColors.primary : colors.textSecondary,
                                size: 22,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'TONO VISUAL DE ENFOQUE',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _colors.map((colorVal) {
                        final isSelected = _selectedColor == colorVal;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = colorVal),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Color(colorVal),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(colorVal).withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sección: Ritmo Pomodoro & Metas
              Container(
                padding: const EdgeInsets.all(18),
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
                            Icon(Icons.timer_outlined, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Ritmo Pomodoro & Metas',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Hábito',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0369A1)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Meta Semanal Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meta semanal',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '~ ${( _weeklySessions * 25 ) ~/ 60}h ${( _weeklySessions * 25 ) % 60}m de concentración',
                                style: TextStyle(fontSize: 12, color: colors.textSecondary),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colors.border),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.remove_rounded, size: 18),
                                  onPressed: () {
                                    if (_weeklySessions > 1) {
                                      setState(() => _weeklySessions--);
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                RichText(
                                  text: TextSpan(
                                    text: '$_weeklySessions',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' ses.',
                                        style: TextStyle(fontSize: 11, color: colors.textSecondary, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.add_rounded, size: 18),
                                  onPressed: () {
                                    setState(() => _weeklySessions++);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // TIPO DE ASIGNATURA: Semestral / Anual
                    Text(
                      'TIPO DE ASIGNATURA',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isAnnual = false;
                                  _endDate = _calculateDefaultEndDate(isAnnual: false);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !_isAnnual ? colors.surface : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: !_isAnnual
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Semestral',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: !_isAnnual ? FontWeight.bold : FontWeight.w500,
                                    color: !_isAnnual ? AppColors.primary : colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isAnnual = true;
                                  _endDate = _calculateDefaultEndDate(isAnnual: true);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isAnnual ? colors.surface : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: _isAnnual
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Anual',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _isAnnual ? FontWeight.bold : FontWeight.w500,
                                    color: _isAnnual ? AppColors.primary : colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // FECHA DE FINALIZACIÓN
                    Text(
                      'FECHA DE FINALIZACIÓN',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2040),
                        );
                        if (picked != null) {
                          setState(() => _endDate = picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_rounded, size: 20, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Text(
                                  '${_endDate.day} de ${_getMonthName(_endDate.month)} de ${_endDate.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Cambiar',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tip Box informativa
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FFFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFB2F5EA)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF0D9488)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Configurar una meta semanal visible activa el efecto Zeigarnik positivo, impulsando hábitos de estudio constantes.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF0F766E), height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botón Guardar y Empezar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingresa el nombre de la asignatura')),
                      );
                      return;
                    }

                    if (_isEditing && widget.subjectId != null) {
                      final subjects = ref.read(subjectsProvider);
                      final existing = subjects.firstWhere((s) => s.id == widget.subjectId);
                      await ref.read(subjectsProvider.notifier).updateSubject(
                            existing.copyWith(
                              name: _nameController.text.trim(),
                              code: _codeController.text.trim(),
                              iconKey: _selectedIcon,
                              colorValue: _selectedColor,
                              isAnnual: _isAnnual,
                              endDate: _endDate,
                            ),
                          );
                    } else {
                      await ref.read(subjectsProvider.notifier).createSubject(
                            name: _nameController.text.trim(),
                            code: _codeController.text.trim(),
                            iconKey: _selectedIcon,
                            colorValue: _selectedColor,
                            isAnnual: _isAnnual,
                            endDate: _endDate,
                          );
                    }

                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: Text(_isEditing ? 'Guardar Cambios' : 'Guardar y Empezar Asignatura'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
