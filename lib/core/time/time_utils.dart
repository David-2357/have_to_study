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
}
