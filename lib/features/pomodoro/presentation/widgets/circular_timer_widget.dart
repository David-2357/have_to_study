import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_theme.dart';
import '../../domain/pomodoro_models.dart';

class CircularTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final PomodoroPhase phase;
  final String? centerSubtitle;
  final double size;
  final String? customTimeStr;
  final double? customProgress;
  final Color? customColor;

  const CircularTimerWidget({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.phase,
    this.centerSubtitle,
    this.size = 260,
    this.customTimeStr,
    this.customProgress,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final String timeStr;
    if (customTimeStr != null) {
      timeStr = customTimeStr!;
    } else {
      final minutes = remainingSeconds ~/ 60;
      final seconds = remainingSeconds % 60;
      timeStr =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    final progress = customProgress ??
        (totalSeconds > 0
            ? (remainingSeconds / totalSeconds).clamp(0.0, 1.0)
            : 1.0);

    final displayColor = customColor ?? phase.color;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Círculo base y aro
            CustomPaint(
              size: Size(size, size),
              painter: _TimerArcPainter(
                progress: progress,
                strokeColor: displayColor,
                backgroundColor: displayColor.withValues(alpha: 0.1),
              ),
            ),
            // Contenido central
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: timeStr.length > 5 ? 36 : 48,
                    fontWeight: FontWeight.w900,
                    color: context.colors.textPrimary,
                    letterSpacing: -1.5,
                  ),
                ),
                if (centerSubtitle != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 190),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.hourglass_empty_rounded,
                            size: 16,
                            color: context.colors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            centerSubtitle!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerArcPainter extends CustomPainter {
  final double progress;
  final Color strokeColor;
  final Color backgroundColor;

  _TimerArcPainter({
    required this.progress,
    required this.strokeColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 14;

    // Fondo grisáceo / suave
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawCircle(center, radius, bgPaint);

    // Borde decorativo interno punteado
    final innerLinePaint = Paint()
      ..color = strokeColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 16, innerLinePaint);

    // Arco de progreso
    final progressPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle > 0 ? sweepAngle : 0.001,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
