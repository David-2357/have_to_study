import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_color_theme.dart';

class MainNavigationScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: colors.surface,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(
              top: BorderSide(color: colors.border.withValues(alpha: 0.8), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: colors.textMuted,
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              if (index == navigationShell.currentIndex) {
                // Si ya está en la pestaña y hay un modal, diálogo o subpantalla abierto, cerrarlo hasta volver a la principal
                final rootNav = Navigator.maybeOf(context, rootNavigator: true);
                while (rootNav != null && rootNav.canPop()) {
                  rootNav.pop();
                }
                final localNav = Navigator.maybeOf(context);
                while (localNav != null && localNav.canPop()) {
                  localNav.pop();
                }
              }

              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timer_outlined),
                activeIcon: Icon(Icons.timer_rounded),
                label: 'Pomodoro',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded),
                activeIcon: Icon(Icons.menu_book_rounded),
                label: 'Estudios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today_rounded),
                label: 'Calendario',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                activeIcon: Icon(Icons.bar_chart_rounded),
                label: 'Estadísticas',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
