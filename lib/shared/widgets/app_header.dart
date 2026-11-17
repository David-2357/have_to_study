import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_color_theme.dart';
import '../../core/providers.dart';
import 'student_avatar.dart';

class AppHeader extends ConsumerWidget {
  final String subtitle;
  final Widget? trailing;

  const AppHeader({
    super.key,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colors.isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : colors.border.withValues(alpha: 0.6),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.isDark
                          ? Colors.black.withValues(alpha: 0.25)
                          : AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Have to study',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    subtitle.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (trailing != null)
            trailing!
          else
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.settings_outlined, color: colors.textPrimary),
                  onPressed: () => context.push('/settings'),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: StudentAvatar(
                      profile: profile,
                      size: 36,
                      borderRadius: 18,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
