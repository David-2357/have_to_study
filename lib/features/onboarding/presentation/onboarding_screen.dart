import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../core/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingSubjectPreset {
  final String name;
  final String code;
  final String iconKey;
  final int colorValue;

  const _OnboardingSubjectPreset({
    required this.name,
    required this.code,
    required this.iconKey,
    required this.colorValue,
  });
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  AppColorTheme get colors => context.colors;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _customSubjectController = TextEditingController();

  // Sugerencias rápidas con iconos y colores temáticos
  final List<_OnboardingSubjectPreset> _presets = const [
    _OnboardingSubjectPreset(name: 'Matemáticas', code: 'MAT', iconKey: 'math', colorValue: 0xFF5C6BC0),
    _OnboardingSubjectPreset(name: 'Física', code: 'FIS', iconKey: 'rocket', colorValue: 0xFF16A085),
    _OnboardingSubjectPreset(name: 'Programación', code: 'CS', iconKey: 'code', colorValue: 0xFFE26D5C),
    _OnboardingSubjectPreset(name: 'Historia', code: 'HIS', iconKey: 'book', colorValue: 0xFFE67E22),
    _OnboardingSubjectPreset(name: 'Química', code: 'QUI', iconKey: 'science', colorValue: 0xFF27AE60),
    _OnboardingSubjectPreset(name: 'Idiomas', code: 'IDI', iconKey: 'school', colorValue: 0xFF2980B9),
    _OnboardingSubjectPreset(name: 'Economía', code: 'ECO', iconKey: 'school', colorValue: 0xFF8E44AD),
    _OnboardingSubjectPreset(name: 'Derecho', code: 'DER', iconKey: 'book', colorValue: 0xFF34495E),
    _OnboardingSubjectPreset(name: 'Biología', code: 'BIO', iconKey: 'science', colorValue: 0xFF00897B),
    _OnboardingSubjectPreset(name: 'Diseño', code: 'DIS', iconKey: 'pencil', colorValue: 0xFFD81B60),
  ];

  final List<Color> _palette = const [
    Color(0xFF5C6BC0),
    Color(0xFF16A085),
    Color(0xFFE26D5C),
    Color(0xFF8E44AD),
    Color(0xFF2980B9),
    Color(0xFFE67E22),
    Color(0xFF27AE60),
    Color(0xFFD81B60),
  ];

  final List<_OnboardingSubjectPreset> _selectedSubjects = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _degreeController.dispose();
    _customSubjectController.dispose();
    super.dispose();
  }

  void _togglePreset(_OnboardingSubjectPreset preset) {
    setState(() {
      final index = _selectedSubjects.indexWhere((s) => s.name.toLowerCase() == preset.name.toLowerCase());
      if (index >= 0) {
        _selectedSubjects.removeAt(index);
      } else {
        _selectedSubjects.add(preset);
      }
    });
  }

  void _addCustomSubject() {
    final text = _customSubjectController.text.trim();
    if (text.isEmpty) return;

    if (_selectedSubjects.any((s) => s.name.toLowerCase() == text.toLowerCase())) {
      _customSubjectController.clear();
      return;
    }

    final color = _palette[_selectedSubjects.length % _palette.length];
    final words = text.split(' ');
    String code = words.map((w) => w.isNotEmpty ? w[0] : '').take(3).join().toUpperCase();
    if (code.length < 3 && text.length >= 3) {
      code = text.substring(0, 3).toUpperCase();
    }

    setState(() {
      _selectedSubjects.add(
        _OnboardingSubjectPreset(
          name: text,
          code: code,
          iconKey: 'book',
          colorValue: color.toARGB32(),
        ),
      );
    });

    _customSubjectController.clear();
  }

  Future<void> _completeOnboarding() async {
    final name = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Estudiante';
    final degree = _degreeController.text.trim();

    // 1. Guardar perfil
    final currentProfile = ref.read(profileProvider);
    await ref.read(profileProvider.notifier).updateProfile(
          currentProfile.copyWith(
            displayName: name,
            degreeName: degree,
            academicPeriod: '',
          ),
        );

    // 2. Crear asignaturas seleccionadas
    for (final s in _selectedSubjects) {
      await ref.read(subjectsProvider.notifier).createSubject(
            name: s.name,
            code: s.code,
            period: '',
            iconKey: s.iconKey,
            colorValue: s.colorValue,
          );
    }

    // 3. Activar la primera asignatura en el Pomodoro si se creó alguna
    final updatedSubjects = ref.read(subjectsProvider);
    if (updatedSubjects.isNotEmpty) {
      ref.read(pomodoroProvider.notifier).selectSubject(updatedSubjects.first.id);
    }

    // 4. Marcar onboarding como completado
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);

    if (mounted) {
      context.go('/pomodoro');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Barra superior de progreso
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      },
                    )
                  else
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentPage == 0 ? 'PASO 1 DE 2: TU PERFIL' : 'PASO 2 DE 2: ASIGNATURAS',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _currentPage == 0 ? 0.5 : 1.0,
                            backgroundColor: colors.border,
                            color: AppColors.primary,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Omitir',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido deslizable
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildProfilePage(),
                  _buildSubjectsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    final enteredName = _nameController.text.trim();
    String initials = 'HS';
    if (enteredName.isNotEmpty) {
      final parts = enteredName.split(' ');
      if (parts.length >= 2 && parts[1].isNotEmpty) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Avatar interactivo
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '¡Te damos la bienvenida!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Have to study es tu espacio de calma, concentración y organización académica. ¿Cómo te gustaría que te llamemos?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Tarjeta de entrada
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TU NOMBRE O APODO *',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'ej. Alejandro, Lucía, David...',
                    hintStyle: TextStyle(color: colors.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                    filled: true,
                    fillColor: colors.surfaceVariant.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CARRERA O CURSO (OPCIONAL)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: colors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _degreeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'ej. Grado en Informática, Bachillerato...',
                    hintStyle: TextStyle(color: colors.textMuted, fontSize: 14),
                    prefixIcon: Icon(Icons.school_outlined, color: colors.textSecondary, size: 20),
                    filled: true,
                    fillColor: colors.surfaceVariant.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Botón Continuar
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                );
              },
              icon: const Text(
                'Siguiente: Mis Asignaturas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              label: const Icon(Icons.arrow_forward_rounded, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tus Asignaturas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Toca las materias que estés cursando para añadirlas con un toque, o escribe una nueva abajo:',
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Sugerencias rápidas (Chips)
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _presets.map((preset) {
              final isSelected = _selectedSubjects.any((s) => s.name.toLowerCase() == preset.name.toLowerCase());
              return FilterChip(
                selected: isSelected,
                label: Text(preset.name),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.white : colors.textPrimary,
                ),
                backgroundColor: Colors.white,
                selectedColor: Color(preset.colorValue),
                checkmarkColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isSelected ? Color(preset.colorValue) : colors.border,
                  ),
                ),
                onSelected: (_) => _togglePreset(preset),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Campo añadir asignatura propia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customSubjectController,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) => _addCustomSubject(),
                    decoration: InputDecoration(
                      hintText: 'Añadir otra asignatura personalizada...',
                      hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addCustomSubject,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Resumen de seleccionadas
          if (_selectedSubjects.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SELECCIONADAS PARA TU CICLO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_selectedSubjects.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedSubjects.map((s) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 14),
                  ),
                  label: Text(s.name),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  backgroundColor: Color(s.colorValue),
                  deleteIcon: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                  onDeleted: () => _togglePreset(s),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          const SizedBox(height: 16),

          // Botón Finalizar
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _completeOnboarding,
              icon: const Icon(Icons.rocket_launch_rounded, size: 20),
              label: Text(
                _selectedSubjects.isNotEmpty
                    ? '¡Comenzar con ${_selectedSubjects.length} ${_selectedSubjects.length == 1 ? "asignatura" : "asignaturas"}!'
                    : 'Comenzar a estudiar',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Puedo agregar más asignaturas después',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
