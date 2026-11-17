import 'package:flutter/material.dart';

class SubjectModel {
  final String id;
  final String name;
  final String code;
  final String period;
  final String iconKey;
  final int colorValue;
  final bool isArchived;
  final bool isPassed;
  final bool isAnnual;
  final DateTime? endDate;
  final int totalStudySeconds;
  final DateTime? lastStudiedAt;
  final int completedPomodoros;

  SubjectModel({
    required this.id,
    required this.name,
    this.code = '',
    this.period = '',
    this.iconKey = 'book',
    required this.colorValue,
    this.isArchived = false,
    this.isPassed = false,
    this.isAnnual = false,
    this.endDate,
    this.totalStudySeconds = 0,
    this.lastStudiedAt,
    this.completedPomodoros = 0,
  });

  Color get color => Color(colorValue);

  /// Devuelve una variante con contraste optimizado cuando el modo oscuro está activo.
  Color displayColor(bool isDark) {
    if (!isDark) return Color(colorValue);
    switch (colorValue) {
      case 0xFF4F46E5: // Índigo / Azul -> Azul índigo luminoso (Indigo 400)
        return const Color(0xFF818CF8);
      case 0xFF16A085: // Verde esmeralda -> Esmeralda 400
        return const Color(0xFF34D399);
      case 0xFF8E44AD: // Morado -> Violeta 400
        return const Color(0xFFA78BFA);
      case 0xFFB74134: // Terracota -> Coral 400
        return const Color(0xFFF87171);
      case 0xFFE67E22: // Naranja -> Naranja 400
        return const Color(0xFFFB923C);
      case 0xFF1E3A8A: // Azul marino -> Azul cielo 400
        return const Color(0xFF60A5FA);
      case 0xFF2980B9: // Azul petróleo -> Celeste 400
        return const Color(0xFF38BDF8);
      default:
        final hsl = HSLColor.fromColor(Color(colorValue));
        if (hsl.lightness < 0.60) {
          return hsl.withLightness((hsl.lightness + 0.28).clamp(0.60, 0.78)).toColor();
        }
        return Color(colorValue);
    }
  }

  IconData get iconData {
    switch (iconKey) {
      case 'sigma':
      case 'math':
        return Icons.functions;
      case 'book':
        return Icons.menu_book_rounded;
      case 'code':
        return Icons.code_rounded;
      case 'science':
      case 'flask':
        return Icons.science_rounded;
      case 'pencil':
        return Icons.edit_rounded;
      case 'gear':
      case 'psychology':
        return Icons.psychology_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'calculate':
        return Icons.calculate_rounded;
      case 'palette':
      case 'art':
        return Icons.palette_rounded;
      case 'music':
        return Icons.music_note_rounded;
      case 'translate':
      case 'language':
        return Icons.translate_rounded;
      case 'balance':
      case 'law':
        return Icons.account_balance_rounded;
      case 'health':
      case 'medicine':
        return Icons.health_and_safety_rounded;
      case 'globe':
      case 'geo':
        return Icons.public_rounded;
      case 'chart':
      case 'economy':
        return Icons.insert_chart_rounded;
      case 'biotech':
      case 'bio':
        return Icons.biotech_rounded;
      case 'desktop':
        return Icons.computer_rounded;
      case 'rocket':
        return Icons.rocket_launch_rounded;
      case 'architecture':
      case 'engineering':
        return Icons.architecture_rounded;
      case 'fitness':
      case 'sports':
        return Icons.fitness_center_rounded;
      case 'history':
        return Icons.history_edu_rounded;
      case 'camera':
        return Icons.camera_alt_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  static String formatPeriodString({
    required bool isAnnual,
    required DateTime? endDate,
    required bool isPassed,
  }) {
    final type = isAnnual ? 'annual' : 'semester';
    final dateStr = endDate?.toIso8601String() ?? '';
    final passedStr = isPassed ? 'PASSED' : '';
    return '$type|$dateStr|$passedStr';
  }

  static ({bool isAnnual, DateTime? endDate, bool isPassed}) parsePeriodString(String raw) {
    if (raw.isEmpty) {
      return (isAnnual: false, endDate: null, isPassed: false);
    }
    final isPassed = raw.contains('PASSED');
    final isAnnual = raw.startsWith('annual');
    final parts = raw.split('|');
    DateTime? endDate;
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      endDate = DateTime.tryParse(parts[1]);
    }
    return (isAnnual: isAnnual, endDate: endDate, isPassed: isPassed);
  }

  SubjectModel copyWith({
    String? id,
    String? name,
    String? code,
    String? period,
    String? iconKey,
    int? colorValue,
    bool? isArchived,
    bool? isPassed,
    bool? isAnnual,
    DateTime? endDate,
    int? totalStudySeconds,
    DateTime? lastStudiedAt,
    int? completedPomodoros,
  }) {
    final nextPassed = isPassed ?? this.isPassed;
    final nextAnnual = isAnnual ?? this.isAnnual;
    final nextEndDate = endDate ?? this.endDate;
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      period: formatPeriodString(
        isAnnual: nextAnnual,
        endDate: nextEndDate,
        isPassed: nextPassed,
      ),
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      isArchived: isArchived ?? this.isArchived,
      isPassed: nextPassed,
      isAnnual: nextAnnual,
      endDate: nextEndDate,
      totalStudySeconds: totalStudySeconds ?? this.totalStudySeconds,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'period': period,
    'iconKey': iconKey,
    'colorValue': colorValue,
    'isArchived': isArchived,
    'isPassed': isPassed,
    'isAnnual': isAnnual,
    'endDate': endDate?.toIso8601String(),
    'totalStudySeconds': totalStudySeconds,
    'lastStudiedAt': lastStudiedAt?.toIso8601String(),
    'completedPomodoros': completedPomodoros,
  };

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    final rawPeriod = json['period'] as String? ?? '';
    final parsed = parsePeriodString(rawPeriod);
    return SubjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      period: rawPeriod,
      iconKey: json['iconKey'] as String? ?? 'book',
      colorValue: json['colorValue'] as int? ?? 0xFFB74134,
      isArchived: json['isArchived'] as bool? ?? false,
      isPassed: json['isPassed'] as bool? ?? parsed.isPassed,
      isAnnual: json['isAnnual'] as bool? ?? parsed.isAnnual,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : parsed.endDate,
      totalStudySeconds: json['totalStudySeconds'] as int? ?? 0,
      lastStudiedAt: json['lastStudiedAt'] != null
          ? DateTime.parse(json['lastStudiedAt'] as String)
          : null,
      completedPomodoros: json['completedPomodoros'] as int? ?? 0,
    );
  }
}
