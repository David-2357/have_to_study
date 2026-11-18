import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../core/providers.dart';
import '../../../shared/widgets/student_avatar.dart';
import '../../../shared/widgets/app_chip.dart';
import '../domain/profile_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final profile = ref.watch(profileProvider);
    final subjects = ref.watch(subjectsProvider).where((s) => !s.isArchived).toList();
    final sessions = ref.watch(focusSessionsProvider);
    final events = ref.watch(academicEventsProvider);

    final totalSeconds = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final completedEvents = events.where((e) => e.isCompleted).length;
    final totalEvents = events.length;

    // Calcular racha actual y récord histórico de días consecutivos con sesiones
    int currentStreak = 0;
    int maxStreak = 0;
    if (sessions.isNotEmpty) {
      final now = DateTime.now();
      final studyDays = sessions
          .map((s) {
            final local = s.completedAt.toLocal();
            return DateTime(local.year, local.month, local.day);
          })
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));

      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      if (studyDays.contains(today) || studyDays.contains(yesterday)) {
        var checkDay = studyDays.contains(today) ? today : yesterday;
        while (studyDays.contains(checkDay)) {
          currentStreak++;
          checkDay = checkDay.subtract(const Duration(days: 1));
        }
      }

      final sortedAsc = studyDays.toList()..sort((a, b) => a.compareTo(b));
      int tempStreak = 0;
      DateTime? prevDay;
      for (final day in sortedAsc) {
        if (prevDay == null || day.difference(prevDay).inDays == 1) {
          tempStreak++;
        } else if (day.difference(prevDay).inDays > 1) {
          tempStreak = 1;
        }
        if (tempStreak > maxStreak) {
          maxStreak = tempStreak;
        }
        prevDay = day;
      }
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Have to study',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.textPrimary),
            ),
            Text(
              'PERFIL DE ESTUDIANTE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colors.textSecondary, letterSpacing: 0.8),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.textPrimary),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta Superior de Usuario
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    StudentAvatar(
                      profile: profile,
                      size: 68,
                      borderRadius: 22,
                      showEditBadge: true,
                      onTap: () => _showAvatarPicker(context, ref, profile),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showEditProfileDialog(context, ref, profile),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  profile.displayName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF0D9488)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile.degreeName,
                              style: TextStyle(fontSize: 12, color: colors.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                AppChip(
                                  label: profile.semester.toUpperCase(),
                                  variant: AppChipVariant.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  borderRadius: BorderRadius.circular(6),
                                  textStyle: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: colors.textSecondary, size: 20),
                      onPressed: () => _showEditProfileDialog(context, ref, profile),
                      tooltip: 'Editar información',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección: Desempeño Académico
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Desempeño Académico',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'HISTÓRICO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: colors.textSecondary.withValues(alpha: 0.8),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 2x2 Grid de Desempeño
              Row(
                children: [
                  _buildStatCard(
                    colors: colors,
                    title: 'TIEMPO TOTAL',
                    val: '${(totalSeconds ~/ 3600)}h ${(totalSeconds % 3600) ~/ 60}m',
                    sub: '✓ Enfoque concentrado',
                    icon: Icons.access_time_rounded,
                    iconBg: const Color(0xFFFDE8E8),
                    iconColor: AppColors.primary,
                    subColor: AppColors.teal,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    colors: colors,
                    title: 'CICLOS FOCUS',
                    val: '${sessions.length}',
                    sub: 'Sesiones realizadas',
                    icon: Icons.check_circle_outline_rounded,
                    iconBg: const Color(0xFFE6FFFA),
                    iconColor: AppColors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatCard(
                    colors: colors,
                    title: 'EVALUACIONES',
                    val: '$completedEvents / $totalEvents',
                    sub: '${totalEvents > 0 ? ((completedEvents / totalEvents) * 100).round() : 0}% Completado',
                    icon: Icons.checklist_rounded,
                    iconBg: const Color(0xFFEEF2FF),
                    iconColor: const Color(0xFF4F46E5),
                    hasBadge: true,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    colors: colors,
                    title: 'CONSTANCIA',
                    val: '$currentStreak ${currentStreak == 1 ? "día" : "días"}',
                    sub: maxStreak > 0 ? 'Récord: $maxStreak ${maxStreak == 1 ? "día" : "días"}' : 'Sin racha activa',
                    icon: Icons.local_fire_department_rounded,
                    iconBg: const Color(0xFFFFF7ED),
                    iconColor: const Color(0xFFEA580C),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sección: Asignaturas Activas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asignaturas Activas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Distribución del tiempo por materia',
                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ref.read(studiesActiveTabProvider.notifier).state = 0;
                      context.go('/studies');
                    },
                    icon: const Text('Gestionar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    label: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Lista de Asignaturas Activas
              ...subjects.map((sub) {
                final subColor = sub.displayColor(colors.isDark);
                return InkWell(
                  onTap: () => context.push('/subject-detail?id=${sub.id}'),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: subColor.withValues(alpha: colors.isDark ? 0.25 : 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(sub.iconData, color: subColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sub.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${sub.code} · ${(sub.totalStudySeconds ~/ 3600)}h acumuladas',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.isDark
                                ? const Color(0xFF4F46E5).withValues(alpha: 0.22)
                                : const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 12,
                                color: colors.isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${sub.completedPomodoros} ciclos',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colors.isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, StudentProfileModel profile) {
    final nameCtrl = TextEditingController(text: profile.displayName);
    final degreeCtrl = TextEditingController(text: profile.degreeName);
    final semesterCtrl = TextEditingController(text: profile.semester);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Editar Perfil de Estudiante', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _showAvatarPicker(context, ref, profile);
                    },
                    child: Column(
                      children: [
                        StudentAvatar(
                          profile: profile,
                          size: 64,
                          borderRadius: 22,
                          showEditBadge: true,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Cambiar foto de perfil',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre Completo'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: degreeCtrl,
                  decoration: const InputDecoration(labelText: 'Carrera o Titulación'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: semesterCtrl,
                  decoration: const InputDecoration(labelText: 'Semestre (ej. 4° Semestre)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty) {
                  final updated = profile.copyWith(
                    displayName: name,
                    degreeName: degreeCtrl.text.trim(),
                    semester: semesterCtrl.text.trim(),
                    academicPeriod: '',
                  );
                  await ref.read(profileProvider.notifier).updateProfile(updated);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil actualizado correctamente')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showAvatarPicker(BuildContext context, WidgetRef ref, StudentProfileModel profile) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            final customUrlCtrl = TextEditingController(
              text: (profile.avatarPath != null && !profile.avatarPath!.startsWith('avatar_'))
                  ? profile.avatarPath
                  : '',
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ListView(
                controller: scrollController,
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
                            'FOTO DE PERFIL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Elige tu Avatar de Estudiante',
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
                  const SizedBox(height: 16),

                  // Opción: Iniciales del nombre
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: profile.avatarPath == null || profile.avatarPath!.isEmpty
                            ? AppColors.primary
                            : colors.border,
                        width: profile.avatarPath == null || profile.avatarPath!.isEmpty ? 2 : 1,
                      ),
                    ),
                    tileColor: profile.avatarPath == null || profile.avatarPath!.isEmpty
                        ? AppColors.primaryLight.withValues(alpha: 0.4)
                        : colors.surface,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        profile.initials,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    title: const Text('Usar mis iniciales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('Mostrar iniciales "${profile.initials}" con fondo terracota', style: TextStyle(fontSize: 11, color: colors.textSecondary)),
                    trailing: profile.avatarPath == null || profile.avatarPath!.isEmpty
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22)
                        : null,
                    onTap: () async {
                      await ref.read(profileProvider.notifier).updateProfile(profile.copyWith(avatarPath: ''));
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 18),
                  Text(
                    'AVATARES ACADÉMICOS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Grilla de avatares
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: kAvatarPresets.length,
                    itemBuilder: (context, index) {
                      final preset = kAvatarPresets[index];
                      final isSelected = profile.avatarPath == preset.key;

                      return GestureDetector(
                        onTap: () async {
                          await ref.read(profileProvider.notifier).updateProfile(profile.copyWith(avatarPath: preset.key));
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: preset.backgroundColor,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: AppColors.primary, width: 3)
                                    : null,
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(preset.icon, color: preset.iconColor, size: 26),
                                  if (isSelected)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check_rounded, color: Colors.white, size: 10),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              preset.name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.primary : colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'ENLACE O RUTA DE IMAGEN PERSONALIZADA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: customUrlCtrl,
                          decoration: const InputDecoration(
                            hintText: 'https://... o ruta en almacenamiento',
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final text = customUrlCtrl.text.trim();
                          if (text.isNotEmpty) {
                            await ref.read(profileProvider.notifier).updateProfile(profile.copyWith(avatarPath: text));
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Aplicar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard({
    required AppColorTheme colors,
    required String title,
    required String val,
    required String sub,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    Color? subColor,
    bool hasBadge = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              val,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            if (hasBadge)
              AppChip(
                label: sub,
                variant: AppChipVariant.info,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                borderRadius: BorderRadius.circular(6),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                sub,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: subColor ?? colors.textSecondary),
                maxLines: 1,
              ),
          ],
        ),
      ),
    );
  }
}
