import 'package:intl/intl.dart';

class TimeUtils {
  static String formatSecondsToMinutesSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatDurationHoursMinutes(int totalSeconds) {
    if (totalSeconds <= 0) return '0m';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    final difference = targetDate.difference(today).inDays;

    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Mañana';
    if (difference == -1) return 'Ayer';
    if (difference > 1 && difference <= 7) return 'En $difference días';
    if (difference < -1 && difference >= -7) return 'Hace ${-difference} días';

    final formatter = DateFormat('d MMM', 'es');
    return formatter.format(date);
  }

  static String formatEventDate(DateTime date, {bool includeTime = false}) {
    final dayFormat = DateFormat('d MMM', 'es');
    if (!includeTime) {
      return dayFormat.format(date);
    }
    final timeFormat = DateFormat('HH:mm');
    return '${dayFormat.format(date)}, ${timeFormat.format(date)}';
  }

  static String formatFullDate(DateTime date) {
    final formatter = DateFormat("EEEE, d 'de' MMMM", 'es');
    return formatter.format(date);
  }

  static DateTime calculateDefaultSubjectStartDate({
    required bool isAnnual,
    DateTime? fromDate,
  }) {
    final base = fromDate ?? DateTime.now();
    if (isAnnual) {
      final startYear = (base.month >= 7) ? base.year : base.year - 1;
      return DateTime(startYear, 9, 1);
    } else {
      if (base.month >= 9 || base.month == 1) {
        final startYear = (base.month == 1) ? base.year - 1 : base.year;
        return DateTime(startYear, 9, 1);
      } else {
        return DateTime(base.year, 2, 1);
      }
    }
  }

  static DateTime calculateDefaultSubjectEndDate({
    required bool isAnnual,
    DateTime? fromDate,
  }) {
    final base = fromDate ?? DateTime.now();
    if (isAnnual) {
      final targetYear = (base.month >= 7) ? base.year + 1 : base.year;
      return DateTime(targetYear, 6, 30);
    } else {
      if (base.month >= 9) {
        return DateTime(base.year + 1, 1, 31);
      } else if (base.month == 1) {
        return DateTime(base.year, 1, 31);
      } else if (base.month >= 2 && base.month <= 6) {
        return DateTime(base.year, 6, 30);
      } else {
        return DateTime(base.year + 1, 1, 31);
      }
    }
  }

  static ({DateTime nextStartDate, DateTime nextEndDate}) calculateNextSubjectCycleDates({
    required bool isAnnual,
    DateTime? previousStartDate,
    DateTime? previousEndDate,
  }) {
    if (previousStartDate != null && previousEndDate != null) {
      final nextStart = DateTime(previousStartDate.year + 1, previousStartDate.month, previousStartDate.day);
      final nextEnd = DateTime(previousEndDate.year + 1, previousEndDate.month, previousEndDate.day);
      return (nextStartDate: nextStart, nextEndDate: nextEnd);
    }

    final base = (previousEndDate != null && previousEndDate.isAfter(DateTime.now()))
        ? previousEndDate
        : DateTime.now();
    if (isAnnual) {
      return (
        nextStartDate: DateTime(base.year, 9, 1),
        nextEndDate: DateTime(base.year + 1, 6, 30),
      );
    } else {
      if (base.month <= 3) {
        return (
          nextStartDate: DateTime(base.year, 9, 1),
          nextEndDate: DateTime(base.year + 1, 1, 31),
        );
      } else {
        return (
          nextStartDate: DateTime(base.year + 1, 2, 1),
          nextEndDate: DateTime(base.year + 1, 6, 30),
        );
      }
    }
  }

  static DateTime calculateNextSubjectCycleDate({
    required bool isAnnual,
    DateTime? previousEndDate,
  }) {
    return calculateNextSubjectCycleDates(
      isAnnual: isAnnual,
      previousEndDate: previousEndDate,
    ).nextEndDate;
  }
}
