import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final String? nextRoute;

  const SplashScreen({super.key, this.nextRoute});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 1800), _navigateToNext);
  }

  Future<void> _navigateToNext() async {
    if (!mounted) return;

    if (widget.nextRoute != null) {
      context.go(widget.nextRoute!);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final hasCompleted = prefs.getBool('has_completed_onboarding') ?? false;

    if (hasCompleted) {
      // Comprobar y realizar copia automática si corresponde
      BackupService.checkAndPerformAutoBackup(ref);

      // Comprobar si hay asignaturas activas cuya fecha de finalización ya expiró
      final subjects = ref.read(subjectsProvider);
      final now = DateTime.now();
      final hasExpiredSubjects = subjects.any((s) =>
          !s.isArchived &&
          !s.isPassed &&
          s.endDate != null &&
          now.isAfter(s.endDate!));

      if (hasExpiredSubjects) {
        if (!mounted) return;
        context.go('/course-closure?onlyExpired=true');
        return;
      }
    }

    if (!mounted) return;
    context.go(hasCompleted ? '/pomodoro' : '/onboarding');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFFBF8F6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Spacer(flex: 3),
                // App Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.black.withValues(alpha: 0.06),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.22),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primary,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.timer_outlined,
                            size: 64,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // App Title
                Text(
                  'Have to Study',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : const Color(0xFF1E2638),
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  'Tu espacio de calma y concentración',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF6B7280),
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(flex: 3),
                // Subtle loading indicator
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
