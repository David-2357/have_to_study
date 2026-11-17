import 'package:flutter/material.dart';

/// App-specific color tokens registered as a ThemeExtension so they propagate
/// reactively to every widget via `Theme.of(context).extension<AppColorTheme>()`.
///
/// Usage:
///   final colors = Theme.of(context).appColors;
///   Container(color: colors.surface)
class AppColorTheme extends ThemeExtension<AppColorTheme> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final bool isDark;

  const AppColorTheme({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.isDark,
  });

  static const AppColorTheme light = AppColorTheme(
    background: Color(0xFFF4F7FC),
    surface: Colors.white,
    surfaceVariant: Color(0xFFEDF2F7),
    textPrimary: Color(0xFF1E2638),
    textSecondary: Color(0xFF6B7280),
    textMuted: Color(0xFF9CA3AF),
    border: Color(0xFFE2E8F0),
    isDark: false,
  );

  static const AppColorTheme dark = AppColorTheme(
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF334155),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    border: Color(0xFF334155),
    isDark: true,
  );

  @override
  AppColorTheme copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    bool? isDark,
  }) {
    return AppColorTheme(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColorTheme lerp(AppColorTheme? other, double t) {
    if (other == null) return this;
    return AppColorTheme(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      isDark: t < 0.5 ? isDark : (other.isDark),
    );
  }
}

/// Convenience extension on BuildContext so any widget can call:
///   context.colors.surface
extension AppColorsContext on BuildContext {
  AppColorTheme get colors =>
      Theme.of(this).extension<AppColorTheme>() ?? AppColorTheme.light;
}
