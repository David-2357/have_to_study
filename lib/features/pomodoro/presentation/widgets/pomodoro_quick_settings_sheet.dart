import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_color_theme.dart';
import '../../../../core/providers.dart';

void showPomodoroQuickSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const PomodoroQuickSettingsSheet(),
  );
}

class PomodoroQuickSettingsSheet extends ConsumerWidget {
  const PomodoroQuickSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top) *
            0.82,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tirador central
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.isDark
                            ? AppColors.primary.withValues(alpha: 0.22)
                            : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajustes de Pomodoro',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          'Duración de fases y ciclos',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Cerrar',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Contenedor principal de duraciones y ciclos
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.isDark
                    ? colors.surfaceVariant.withValues(alpha: 0.45)
                    : colors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  _buildStepperRow(
                    context: context,
                    icon: Icons.timer_rounded,
                    iconColor: AppColors.primary,
                    title: 'Sesión de estudio',
                    subtitle: 'Tiempo de concentración',
                    value: '${settings.focusMinutes} min',
                    onDecrement: () {
                      if (settings.focusMinutes > 5) {
                        notifier.updateSettings(
                          settings.copyWith(focusMinutes: settings.focusMinutes - 5),
                        );
                      }
                    },
                    onIncrement: () {
                      if (settings.focusMinutes < 120) {
                        notifier.updateSettings(
                          settings.copyWith(focusMinutes: settings.focusMinutes + 5),
                        );
                      }
                    },
                  ),
                  Divider(height: 24, color: colors.border),
                  _buildStepperRow(
                    context: context,
                    icon: Icons.coffee_rounded,
                    iconColor: AppColors.teal,
                    title: 'Descanso corto',
                    subtitle: 'Pausa para hidratación',
                    value: '${settings.shortBreakMinutes} min',
                    onDecrement: () {
                      if (settings.shortBreakMinutes > 1) {
                        notifier.updateSettings(
                          settings.copyWith(shortBreakMinutes: settings.shortBreakMinutes - 1),
                        );
                      }
                    },
                    onIncrement: () {
                      if (settings.shortBreakMinutes < 30) {
                        notifier.updateSettings(
                          settings.copyWith(shortBreakMinutes: settings.shortBreakMinutes + 1),
                        );
                      }
                    },
                  ),
                  Divider(height: 24, color: colors.border),
                  _buildStepperRow(
                    context: context,
                    icon: Icons.weekend_rounded,
                    iconColor: AppColors.info,
                    title: 'Descanso largo',
                    subtitle: 'Recuperación profunda',
                    value: '${settings.longBreakMinutes} min',
                    onDecrement: () {
                      if (settings.longBreakMinutes > 5) {
                        notifier.updateSettings(
                          settings.copyWith(longBreakMinutes: settings.longBreakMinutes - 5),
                        );
                      }
                    },
                    onIncrement: () {
                      if (settings.longBreakMinutes < 90) {
                        notifier.updateSettings(
                          settings.copyWith(longBreakMinutes: settings.longBreakMinutes + 5),
                        );
                      }
                    },
                  ),
                  Divider(height: 24, color: colors.border),
                  _buildStepperRow(
                    context: context,
                    icon: Icons.repeat_rounded,
                    iconColor: AppColors.purple,
                    title: 'Ciclos por ronda',
                    subtitle: 'Ciclos antes del descanso largo',
                    value: '${settings.cyclesBeforeLongBreak}',
                    onDecrement: () {
                      if (settings.cyclesBeforeLongBreak > 1) {
                        notifier.updateSettings(
                          settings.copyWith(
                            cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak - 1,
                          ),
                        );
                      }
                    },
                    onIncrement: () {
                      if (settings.cyclesBeforeLongBreak < 16) {
                        notifier.updateSettings(
                          settings.copyWith(
                            cyclesBeforeLongBreak: settings.cyclesBeforeLongBreak + 1,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contenedor de automatizaciones y pantalla
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.isDark
                    ? colors.surfaceVariant.withValues(alpha: 0.45)
                    : colors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    context: context,
                    title: 'Iniciar descansos automáticamente',
                    subtitle: 'Pasa a descanso sin pulsar la pantalla',
                    value: settings.autoStartBreaks,
                    onChanged: (val) {
                      notifier.updateSettings(settings.copyWith(autoStartBreaks: val));
                    },
                  ),
                  Divider(height: 20, color: colors.border),
                  _buildSwitchRow(
                    context: context,
                    title: 'Iniciar estudio automáticamente',
                    subtitle: 'Comienza el siguiente ciclo tras el descanso',
                    value: settings.autoStartFocus,
                    onChanged: (val) {
                      notifier.updateSettings(settings.copyWith(autoStartFocus: val));
                    },
                  ),
                  Divider(height: 20, color: colors.border),
                  _buildSwitchRow(
                    context: context,
                    title: 'Prevenir bloqueo de pantalla',
                    subtitle: 'Mantiene la pantalla activa durante la sesión',
                    value: settings.preventScreenLock,
                    onChanged: (val) {
                      notifier.updateSettings(settings.copyWith(preventScreenLock: val));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botón de Listo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Listo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.isDark
                ? iconColor.withValues(alpha: 0.18)
                : iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_rounded, size: 18),
                color: colors.textPrimary,
                onPressed: onDecrement,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 54),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded, size: 18),
                color: colors.textPrimary,
                onPressed: onIncrement,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeThumbColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
