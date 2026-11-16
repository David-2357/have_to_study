import 'dart:io';
import 'package:flutter/material.dart';
import '../../features/profile/domain/profile_model.dart';
import '../theme/app_colors.dart';

class AvatarPreset {
  final String key;
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const AvatarPreset({
    required this.key,
    required this.name,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

const List<AvatarPreset> kAvatarPresets = [
  AvatarPreset(
    key: 'avatar_grad',
    name: 'Graduado',
    icon: Icons.school_rounded,
    backgroundColor: Color(0xFF1E3A8A),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    key: 'avatar_code',
    name: 'Desarrollador',
    icon: Icons.terminal_rounded,
    backgroundColor: Color(0xFF0F172A),
    iconColor: Color(0xFF38BDF8),
  ),
  AvatarPreset(
    key: 'avatar_zen',
    name: 'Calma Zen',
    icon: Icons.self_improvement_rounded,
    backgroundColor: Color(0xFF065F46),
    iconColor: Color(0xFF6EE7B7),
  ),
  AvatarPreset(
    key: 'avatar_books',
    name: 'Lector',
    icon: Icons.auto_stories_rounded,
    backgroundColor: Color(0xFF92400E),
    iconColor: Color(0xFFFDE68A),
  ),
  AvatarPreset(
    key: 'avatar_rocket',
    name: 'Productivo',
    icon: Icons.rocket_launch_rounded,
    backgroundColor: Color(0xFFB74134),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    key: 'avatar_science',
    name: 'Ciencia',
    icon: Icons.science_rounded,
    backgroundColor: Color(0xFF5B21B6),
    iconColor: Color(0xFFDDD6FE),
  ),
  AvatarPreset(
    key: 'avatar_coffee',
    name: 'Café de Estudio',
    icon: Icons.local_cafe_rounded,
    backgroundColor: Color(0xFF78350F),
    iconColor: Color(0xFFFDE68A),
  ),
  AvatarPreset(
    key: 'avatar_music',
    name: 'Música Lo-Fi',
    icon: Icons.headphones_rounded,
    backgroundColor: Color(0xFF4C1D95),
    iconColor: Color(0xFFA78BFA),
  ),
  AvatarPreset(
    key: 'avatar_art',
    name: 'Creativo',
    icon: Icons.palette_rounded,
    backgroundColor: Color(0xFF9D174D),
    iconColor: Color(0xFFFBCFE8),
  ),
  AvatarPreset(
    key: 'avatar_fire',
    name: 'Racha Activa',
    icon: Icons.local_fire_department_rounded,
    backgroundColor: Color(0xFFEA580C),
    iconColor: Colors.white,
  ),
  AvatarPreset(
    key: 'avatar_laptop',
    name: 'Estudio Digital',
    icon: Icons.laptop_chromebook_rounded,
    backgroundColor: Color(0xFF1E293B),
    iconColor: Color(0xFF818CF8),
  ),
  AvatarPreset(
    key: 'avatar_star',
    name: 'Sobresaliente',
    icon: Icons.star_rounded,
    backgroundColor: Color(0xFFD97706),
    iconColor: Colors.white,
  ),
];

class StudentAvatar extends StatelessWidget {
  final StudentProfileModel profile;
  final double size;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool showEditBadge;

  const StudentAvatar({
    super.key,
    required this.profile,
    this.size = 40,
    this.borderRadius,
    this.onTap,
    this.showEditBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarKey = profile.avatarPath;
    final radius = borderRadius ?? (size / 2);

    Widget avatarContent;

    if (avatarKey != null && avatarKey.isNotEmpty) {
      // 1. Preset de avatar predefinido
      final preset = kAvatarPresets.where((p) => p.key == avatarKey).firstOrNull;
      if (preset != null) {
        avatarContent = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: preset.backgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: Alignment.center,
          child: Icon(
            preset.icon,
            color: preset.iconColor,
            size: size * 0.55,
          ),
        );
      } else if (avatarKey.startsWith('http://') || avatarKey.startsWith('https://')) {
        // 2. Imagen de red
        avatarContent = ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.network(
            avatarKey,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildInitialsFallback(radius),
          ),
        );
      } else {
        // 3. Archivo local en el dispositivo
        final file = File(avatarKey);
        if (file.existsSync()) {
          avatarContent = ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.file(
              file,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildInitialsFallback(radius),
            ),
          );
        } else {
          avatarContent = _buildInitialsFallback(radius);
        }
      }
    } else {
      // 4. Iniciales por defecto
      avatarContent = _buildInitialsFallback(radius);
    }

    if (!showEditBadge && onTap == null) {
      return avatarContent;
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatarContent,
          if (showEditBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInitialsFallback(double radius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Text(
        profile.initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
