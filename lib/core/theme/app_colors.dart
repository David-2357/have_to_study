import 'package:flutter/material.dart';

class AppColors {
  // Brand & Primary
  static const Color primary = Color(0xFFB74134); // Terracota / Rojo oscuro
  static const Color primaryDark = Color(0xFF8F2D23);
  static const Color primaryLight = Color(0xFFFBEBE8);

  // Background & Surfaces (Dinámicos según tema)
  static Color background = const Color(0xFFF4F7FC); // Azulado muy claro
  static Color surface = Colors.white;
  static Color surfaceVariant = const Color(0xFFEDF2F7);

  // Text (Dinámicos según tema)
  static Color textPrimary = const Color(0xFF1E2638);
  static Color textSecondary = const Color(0xFF6B7280);
  static Color textMuted = const Color(0xFF9CA3AF);

  // Border & Divider (Dinámicos según tema)
  static Color border = const Color(0xFFE2E8F0);

  // Status & Categories
  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFFE8F8F0);
  static const Color warning = Color(0xFFE67E22);
  static const Color warningLight = Color(0xFFFEF5E7);
  static const Color info = Color(0xFF2980B9);
  static const Color infoLight = Color(0xFFEBF5FB);
  static const Color purple = Color(0xFF8E44AD);
  static const Color purpleLight = Color(0xFFF4ECF7);
  static const Color teal = Color(0xFF16A085);
  static const Color tealLight = Color(0xFFE8F8F5);

  // Event Types
  static const Color exam = Color(0xFFC0392B);
  static const Color examLight = Color(0xFFFADBD8);
  static const Color assignment = Color(0xFF27AE60);
  static const Color assignmentLight = Color(0xFFD4EFDF);
  static const Color activity = Color(0xFF2980B9);
  static const Color activityLight = Color(0xFFD4E6F1);

  static bool isDarkMode = false;

  static void updateTheme({required bool isDark}) {
    isDarkMode = isDark;
    if (isDark) {
      background = const Color(0xFF0F172A); // Slate 900
      surface = const Color(0xFF1E293B); // Slate 800
      surfaceVariant = const Color(0xFF334155); // Slate 700
      textPrimary = const Color(0xFFF8FAFC); // Slate 50
      textSecondary = const Color(0xFF94A3B8); // Slate 400
      textMuted = const Color(0xFF64748B); // Slate 500
      border = const Color(0xFF334155); // Slate 700
    } else {
      background = const Color(0xFFF4F7FC);
      surface = Colors.white;
      surfaceVariant = const Color(0xFFEDF2F7);
      textPrimary = const Color(0xFF1E2638);
      textSecondary = const Color(0xFF6B7280);
      textMuted = const Color(0xFF9CA3AF);
      border = const Color(0xFFE2E8F0);
    }
  }
}
