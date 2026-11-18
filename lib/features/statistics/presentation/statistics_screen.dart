import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_color_theme.dart';
import '../../../shared/utils/time_utils.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/app_chip.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../core/providers.dart';
import '../../subjects/domain/subject_model.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  AppColorTheme get colors => context.colors;
  int _selectedPeriod = 0; // 0: Esta Semana, 1: Este Mes, 2: Global

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sessions = ref.watch(focusSessionsProvider);
    final subjects = ref.watch(subjectsProvider);
    final settings = ref.watch(settingsProvider);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekday = now.weekday; // 1: Lun .. 7: Dom
    final thisMonday = today.subtract(Duration(days: currentWeekday - 1));
    final nextMonday = thisMonday.add(const Duration(days: 7));
    final lastMonday = thisMonday.subtract(const Duration(days: 7));

    final currentMonthStart = DateTime(now.year, now.month, 1);
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    final previousMonthStart = DateTime(now.year, now.month - 1, 1);

    // Filtrar sesiones según periodo
    final filteredSessions = sessions.where((s) {
      final completed = s.completedAt.toLocal();
      if (_selectedPeriod == 0) {
        // Esta semana (lunes a domingo de la semana en curso)
        return !completed.isBefore(thisMonday) && completed.isBefore(nextMonday);
      } else if (_selectedPeriod == 1) {
        // Este mes (día 1 al final del mes)
        return !completed.isBefore(currentMonthStart) && completed.isBefore(nextMonthStart);
      }
      return true; // Global
    }).toList();

    final totalSeconds = filteredSessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final totalCycles = filteredSessions.length;

    // Comparación con el periodo anterior
    int previousPeriodSeconds = 0;
    if (_selectedPeriod == 0) {
      previousPeriodSeconds = sessions.where((s) {
        final completed = s.completedAt.toLocal();
        return !completed.isBefore(lastMonday) && completed.isBefore(thisMonday);
      }).fold<int>(0, (sum, s) => sum + s.durationSeconds);
    } else if (_selectedPeriod == 1) {
      previousPeriodSeconds = sessions.where((s) {
        final completed = s.completedAt.toLocal();
        return !completed.isBefore(previousMonthStart) && completed.isBefore(currentMonthStart);
      }).fold<int>(0, (sum, s) => sum + s.durationSeconds);
    }

    final diffSeconds = totalSeconds - previousPeriodSeconds;
    String timeSubText;
    IconData? timeSubIcon;
    Color timeSubColor;

    if (_selectedPeriod == 0) {
      if (totalSeconds == 0 && previousPeriodSeconds == 0) {
        timeSubText = 'Sin tiempo registrado';
        timeSubIcon = null;
        timeSubColor = colors.textSecondary;
      } else if (previousPeriodSeconds == 0) {
        timeSubText = '+${TimeUtils.formatDurationHoursMinutes(totalSeconds)} vs sem. ant.';
        timeSubIcon = Icons.trending_up_rounded;
        timeSubColor = AppColors.teal;
      } else if (diffSeconds > 0) {
        timeSubText = '+${TimeUtils.formatDurationHoursMinutes(diffSeconds)} vs sem. ant.';
        timeSubIcon = Icons.trending_up_rounded;
        timeSubColor = AppColors.teal;
      } else if (diffSeconds < 0) {
        timeSubText = '-${TimeUtils.formatDurationHoursMinutes(-diffSeconds)} vs sem. ant.';
        timeSubIcon = Icons.trending_down_rounded;
        timeSubColor = colors.isDark ? const Color(0xFFF87171) : AppColors.primary;
      } else {
        timeSubText = '= Igual que sem. anterior';
        timeSubIcon = Icons.trending_flat_rounded;
        timeSubColor = colors.textSecondary;
      }
    } else if (_selectedPeriod == 1) {
      if (totalSeconds == 0 && previousPeriodSeconds == 0) {
        timeSubText = 'Sin tiempo registrado';
        timeSubIcon = null;
        timeSubColor = colors.textSecondary;
      } else if (previousPeriodSeconds == 0) {
        timeSubText = '+${TimeUtils.formatDurationHoursMinutes(totalSeconds)} vs mes ant.';
        timeSubIcon = Icons.trending_up_rounded;
        timeSubColor = AppColors.teal;
      } else if (diffSeconds > 0) {
        timeSubText = '+${TimeUtils.formatDurationHoursMinutes(diffSeconds)} vs mes ant.';
        timeSubIcon = Icons.trending_up_rounded;
        timeSubColor = AppColors.teal;
      } else if (diffSeconds < 0) {
        timeSubText = '-${TimeUtils.formatDurationHoursMinutes(-diffSeconds)} vs mes ant.';
        timeSubIcon = Icons.trending_down_rounded;
        timeSubColor = colors.isDark ? const Color(0xFFF87171) : AppColors.primary;
      } else {
        timeSubText = '= Igual que mes anterior';
        timeSubIcon = Icons.trending_flat_rounded;
        timeSubColor = colors.textSecondary;
      }
    } else {
      timeSubText = '$totalCycles sesiones acumuladas';
      timeSubIcon = Icons.all_inclusive_rounded;
      timeSubColor = colors.textSecondary;
    }

    // Días transcurridos en el periodo para promedio diario exacto
    final int daysElapsedInPeriod = _selectedPeriod == 0
        ? currentWeekday.clamp(1, 7)
        : (_selectedPeriod == 1
            ? now.day.clamp(1, 31)
            : (sessions.isNotEmpty
                ? (now.difference(sessions.map((s) => s.completedAt).reduce((a, b) => a.isBefore(b) ? a : b)).inDays + 1)
                : 1).clamp(1, 99999));
    final dailyAvgSeconds = daysElapsedInPeriod > 0 ? (totalSeconds ~/ daysElapsedInPeriod) : 0;

    // Subtítulo de ciclos según periodo
    final focusMins = settings.focusMinutes > 0 ? settings.focusMinutes : 25;
    String cyclesSubText;
    if (_selectedPeriod == 0) {
      final weeklyGoalCycles = (settings.dailyGoalHours * 7 * 60) ~/ focusMins;
      cyclesSubText = 'Meta semanal: $weeklyGoalCycles ciclos';
    } else if (_selectedPeriod == 1) {
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      final monthlyGoalCycles = (settings.dailyGoalHours * daysInMonth * 60) ~/ focusMins;
      cyclesSubText = 'Meta mensual: $monthlyGoalCycles ciclos';
    } else {
      cyclesSubText = totalCycles > 0
          ? 'Promedio: ${((totalSeconds / 60) / totalCycles).round()} min / ciclo'
          : 'Sin ciclos completados';
    }

    // Cálculo dinámico de 7 días (Lunes a Domingo) para el gráfico de barras
    final monday = thisMonday;
    final dailyHours = List<double>.filled(7, 0.0);
    int completedDaysCount = 0;
    final dailyGoal = settings.dailyGoalHours.toDouble();

    for (int i = 0; i < 7; i++) {
      final targetDay = monday.add(Duration(days: i));
      final nextDay = targetDay.add(const Duration(days: 1));
      final daySessions = sessions.where((s) {
        final local = s.completedAt.toLocal();
        return !local.isBefore(targetDay) && local.isBefore(nextDay);
      });
      final daySecs = daySessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
      final hours = daySecs / 3600.0;
      dailyHours[i] = double.parse(hours.toStringAsFixed(1));
      if (hours >= dailyGoal && dailyGoal > 0) {
        completedDaysCount++;
      }
    }

    final maxDailyHour = dailyHours.fold<double>(0.0, (max, h) => h > max ? h : max);
    final chartMaxY = (maxDailyHour > dailyGoal ? maxDailyHour + 1.0 : (dailyGoal > 0 ? dailyGoal + 1.5 : 4.0)).clamp(4.0, 24.0);

    // Cálculo dinámico de Eficiencia
    final daysElapsed = currentWeekday.clamp(1, 7);
    final efficiencyPercent = totalCycles > 0
        ? ((completedDaysCount / daysElapsed) * 100).clamp(0, 100).round()
        : 0;

    // Cálculo dinámico de Zona de Oro (Productividad por franja horaria)
    int morningSecs = 0;
    int afternoonSecs = 0;
    int eveningSecs = 0;
    for (final s in filteredSessions) {
      final h = s.startedAt.toLocal().hour;
      if (h >= 6 && h < 12) {
        morningSecs += s.durationSeconds;
      } else if (h >= 12 && h < 18) {
        afternoonSecs += s.durationSeconds;
      } else {
        eveningSecs += s.durationSeconds;
      }
    }

    String goldenZoneLabel = 'Mañana';
    String goldenZoneHours = '09:00 – 12:00';
    int goldenZonePercent = 0;
    if (totalSeconds > 0) {
      if (afternoonSecs >= morningSecs && afternoonSecs >= eveningSecs) {
        goldenZoneLabel = 'Tarde';
        goldenZoneHours = '14:00 – 18:00';
        goldenZonePercent = ((afternoonSecs / totalSeconds) * 100).round();
      } else if (eveningSecs >= morningSecs && eveningSecs >= afternoonSecs) {
        goldenZoneLabel = 'Noche';
        goldenZoneHours = '19:00 – 23:00';
        goldenZonePercent = ((eveningSecs / totalSeconds) * 100).round();
      } else {
        goldenZoneLabel = 'Mañana';
        goldenZoneHours = '08:00 – 12:00';
        goldenZonePercent = ((morningSecs / totalSeconds) * 100).round();
      }
    }

    // Calcular distribución por asignaturas
    final Map<String, int> subjectSecondsMap = {};
    for (final s in filteredSessions) {
      final key = s.subjectId ?? 'unassigned';
      subjectSecondsMap[key] = (subjectSecondsMap[key] ?? 0) + s.durationSeconds;
    }

    final List<Map<String, dynamic>> subjectDistribution = [];
    subjectSecondsMap.forEach((subId, sec) {
      if (subId == 'unassigned') {
        subjectDistribution.add({
          'name': 'Sin asignatura asignada',
          'color': const Color(0xFF8D6E63),
          'seconds': sec,
          'percent': totalSeconds > 0 ? ((sec / totalSeconds) * 100).round() : 0,
        });
      } else {
        final sub = subjects.firstWhere(
          (s) => s.id == subId,
          orElse: () => SubjectModel(id: '', name: 'Desconocida', colorValue: 0xFF9E9E9E),
        );
        subjectDistribution.add({
          'name': sub.name,
          'color': sub.color,
          'seconds': sec,
          'percent': totalSeconds > 0 ? ((sec / totalSeconds) * 100).round() : 0,
        });
      }
    });

    subjectDistribution.sort((a, b) => (b['seconds'] as int).compareTo(a['seconds'] as int));

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(subtitle: 'Estadísticas'),

              // Segmented Control: [ Esta Semana ] [ Este Mes ] [ Global ]
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildPeriodButton('Esta Semana', 0),
                      _buildPeriodButton('Este Mes', 1),
                      _buildPeriodButton('Global', 2),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2x2 Grid de Métricas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        StatCard(
                          isExpanded: true,
                          title: 'TIEMPO TOTAL',
                          value: TimeUtils.formatDurationHoursMinutes(totalSeconds),
                          subtitle: timeSubText,
                          icon: Icons.access_time_rounded,
                          iconColor: AppColors.primary,
                          subtitleIcon: timeSubIcon,
                          subtitleColor: timeSubColor,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          isExpanded: true,
                          title: 'CICLOS COMPLETOS',
                          value: '$totalCycles',
                          subtitle: cyclesSubText,
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: AppColors.teal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        StatCard(
                          isExpanded: true,
                          title: 'PROMEDIO DIARIO',
                          value: TimeUtils.formatDurationHoursMinutes(dailyAvgSeconds),
                          subtitle: 'Meta: ${settings.dailyGoalHours}h 00m diaria',
                          icon: Icons.nightlight_round,
                          iconColor: const Color(0xFF4F46E5),
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          isExpanded: true,
                          title: 'EFICIENCIA',
                          value: '$efficiencyPercent%',
                          subtitle: totalCycles > 0
                              ? '$completedDaysCount de $daysElapsedInPeriod días en meta'
                              : 'Sin sesiones aún',
                          icon: Icons.bolt_rounded,
                          iconColor: const Color(0xFF9333EA),
                          subtitleColor: efficiencyPercent > 0 ? AppColors.teal : colors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Ritmo de los Últimos 7 Días
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ritmo de los Últimos 7 Días',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Meta diaria fijada en ${settings.dailyGoalHours} horas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          AppChip(
                            label: 'Cumplido $completedDaysCount/7',
                            variant: AppChipVariant.teal,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            borderRadius: BorderRadius.circular(10),
                            textStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Gráfico de Barras de 7 Días Dinámico
                      SizedBox(
                        height: 180,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: chartMaxY,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                                    final index = value.toInt();
                                    if (index >= 0 && index < days.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          days[index],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: dailyGoal > 0 ? dailyGoal : 3,
                              getDrawingHorizontalLine: (value) {
                                if (dailyGoal > 0 && (value - dailyGoal).abs() < 0.05) {
                                  return const FlLine(
                                    color: Color(0xFFE2E8F0),
                                    strokeWidth: 1.5,
                                    dashArray: [5, 5],
                                  );
                                }
                                return const FlLine(color: Colors.transparent);
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(7, (i) {
                              final hours = dailyHours[i];
                              final isMet = dailyGoal > 0 && hours >= dailyGoal;
                              return _makeBarGroup(i, hours, isMet);
                            }),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'META ${settings.dailyGoalHours}H',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Distribución por Asignatura
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Distribución por\nAsignatura',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: colors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Inversión total de tiempo académico',
                                style: TextStyle(fontSize: 11, color: colors.textSecondary),
                              ),
                            ],
                          ),
                          if (totalSeconds > 0)
                            TextButton.icon(
                              onPressed: () {
                                context.go('/studies');
                              },
                              icon: const Text('Ver todas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              label: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (totalSeconds == 0 || subjectDistribution.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colors.surfaceVariant,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.pie_chart_outline_rounded, size: 28, color: colors.textSecondary),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Sin tiempo de estudio registrado',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Completa sesiones de pomodoro para ver cómo distribuyes tu tiempo entre asignaturas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...subjectDistribution.take(5).map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: item['color'] as Color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item['name'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    TimeUtils.formatDurationHoursMinutes(item['seconds'] as int),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${item['percent']}%',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (item['percent'] as int) / 100,
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  valueColor: AlwaysStoppedAnimation<Color>(item['color'] as Color),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              if (totalSeconds > 0) ...[
                const SizedBox(height: 24),

                // Tarjeta Zona de Oro
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.isDark ? const Color(0xFF132F23) : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colors.isDark ? const Color(0xFF166534) : const Color(0xFFDCFCE7),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Zona de Oro',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AppChip(
                                    label: goldenZoneLabel,
                                    variant: AppChipVariant.success,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    textStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  text: 'Mayor productividad: ',
                                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                                  children: [
                                    TextSpan(
                                      text: '$goldenZoneHours\n',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: colors.textPrimary),
                                    ),
                                    TextSpan(
                                      text:
                                          'Durante esta franja registraste el $goldenZonePercent% de tu tiempo de concentración en este periodo.',
                                      style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label, int index) {
    final isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? colors.textPrimary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }



  BarChartGroupData _makeBarGroup(int x, double y, bool isHighlighted) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isHighlighted ? AppColors.primary : const Color(0xFFFBCFE8),
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ],
    );
  }
}
