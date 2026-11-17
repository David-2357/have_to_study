import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/pomodoro/domain/pomodoro_models.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int pomodoroNotificationId = 888;
  static const String pomodoroChannelId = 'pomodoro_timer_channel';
  static const String pomodoroChannelName = 'Temporizador Pomodoro';
  static const String pomodoroChannelDesc =
      'Notificaciones y alertas al finalizar tus sesiones de concentración y descansos';

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Inicializar base de datos de zonas horarias
    try {
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('[NotificationService] Error al configurar zona horaria: $e');
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }

    // 2. Configurar inicialización según plataforma
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('[NotificationService] Notificación tocada: ${response.payload}');
      },
    );

    // 3. Crear canal de alta prioridad en Android
    if (Platform.isAndroid) {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      const channel = AndroidNotificationChannel(
        pomodoroChannelId,
        pomodoroChannelName,
        description: pomodoroChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await androidImplementation?.createNotificationChannel(channel);
    }

    _isInitialized = true;
  }

  /// Solicitar permisos de notificación y alarmas exactas en Android 13+ / 12+
  Future<void> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        await androidImplementation?.requestNotificationsPermission();
        await androidImplementation?.requestExactAlarmsPermission();
      } else if (Platform.isIOS) {
        final iosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();

        await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      debugPrint('[NotificationService] Error solicitando permisos: $e');
    }
  }

  /// Programar notificación exacta para cuando venza el temporizador
  Future<void> schedulePomodoroCompletion({
    required DateTime scheduledTime,
    required PomodoroPhase phase,
    String? subjectName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Cancelar cualquier notificación previa de pomodoro
    await cancelPomodoroNotification();

    // Si la fecha ya pasó o es en menos de 1 segundo, no programar
    final now = DateTime.now();
    if (scheduledTime.isBefore(now.add(const Duration(seconds: 1)))) {
      return;
    }

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    final String title;
    final String body;

    switch (phase) {
      case PomodoroPhase.focus:
        title = '¡Pomodoro completado!';
        if (subjectName != null && subjectName.trim().isNotEmpty) {
          body = 'Completaste tu sesión de $subjectName. ¡Momento de descansar!';
        } else {
          body = '¡Excelente trabajo! Has completado tu tiempo de estudio. ¡Tómate un descanso!';
        }
        break;
      case PomodoroPhase.shortBreak:
        title = '¡Descanso terminado!';
        body = 'Tu descanso corto ha concluido. ¿Listo para concentrarte de nuevo?';
        break;
      case PomodoroPhase.longBreak:
        title = '¡Descanso largo finalizado!';
        body = 'Has recargado energías. ¡Hora de iniciar una nueva ronda de concentración!';
        break;
    }

    const androidDetails = AndroidNotificationDetails(
      pomodoroChannelId,
      pomodoroChannelName,
      channelDescription: pomodoroChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        pomodoroNotificationId,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      debugPrint('[NotificationService] Notificación programada para: $tzScheduledTime');
    } catch (e) {
      debugPrint('[NotificationService] Error al programar notificación: $e');
    }
  }

  /// Cancelar la notificación programada de Pomodoro
  Future<void> cancelPomodoroNotification() async {
    try {
      await _notificationsPlugin.cancel(pomodoroNotificationId);
    } catch (e) {
      debugPrint('[NotificationService] Error al cancelar notificación: $e');
    }
  }

  /// Mostrar notificación inmediata
  Future<void> showImmediateCompletionNotification({
    required PomodoroPhase phase,
    String? subjectName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final String title;
    final String body;

    switch (phase) {
      case PomodoroPhase.focus:
        title = '¡Pomodoro completado!';
        body = subjectName != null && subjectName.trim().isNotEmpty
            ? 'Completaste tu sesión de $subjectName.'
            : '¡Excelente trabajo! Has completado tu tiempo de estudio.';
        break;
      case PomodoroPhase.shortBreak:
        title = '¡Descanso finalizado!';
        body = 'Tu descanso ha terminado. ¡Hora de concentrarse!';
        break;
      case PomodoroPhase.longBreak:
        title = '¡Descanso largo terminado!';
        body = 'Descanso concluido. ¡A por la siguiente ronda!';
        break;
    }

    const androidDetails = AndroidNotificationDetails(
      pomodoroChannelId,
      pomodoroChannelName,
      channelDescription: pomodoroChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _notificationsPlugin.show(
        pomodoroNotificationId,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      debugPrint('[NotificationService] Error mostrando notificación inmediata: $e');
    }
  }
}
