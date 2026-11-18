import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/pomodoro/domain/pomodoro_models.dart';
import '../../features/academic_events/domain/academic_event_model.dart';
import '../../features/subjects/domain/subject_model.dart';
import '../../../shared/utils/time_utils.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int pomodoroNotificationId = 888;
  static const int pomodoroCompletionNotificationId = 889;
  static const String pomodoroChannelId = 'pomodoro_timer_channel';
  static const String pomodoroChannelName = 'Temporizador Pomodoro';
  static const String pomodoroChannelDesc =
      'Notificaciones y alertas al finalizar tus sesiones de concentración y descansos';

  static const String priorityEventsChannelId = 'priority_events_channel';
  static const String priorityEventsChannelName = 'Actividades Prioritarias';
  static const String priorityEventsChannelDesc =
      'Alertas con antelación para actividades prioritarias';

  static const String unattendedSubjectsChannelId = 'unattended_subjects_channel';
  static const String unattendedSubjectsChannelName = 'Asignaturas Desatendidas';
  static const String unattendedSubjectsChannelDesc =
      'Alertas para asignaturas activas que llevan días sin sesiones de estudio';

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Inicializar base de datos de zonas horarias
    try {
      tz.initializeTimeZones();
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
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
      settings: initSettings,
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

      const priorityChannel = AndroidNotificationChannel(
        priorityEventsChannelId,
        priorityEventsChannelName,
        description: priorityEventsChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      const unattendedChannel = AndroidNotificationChannel(
        unattendedSubjectsChannelId,
        unattendedSubjectsChannelName,
        description: unattendedSubjectsChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await androidImplementation?.createNotificationChannel(channel);
      await androidImplementation?.createNotificationChannel(priorityChannel);
      await androidImplementation?.createNotificationChannel(unattendedChannel);
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
        id: pomodoroNotificationId,
        title: title,
        body: body,
        scheduledDate: tzScheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('[NotificationService] Notificación programada para: $tzScheduledTime');
    } catch (e) {
      debugPrint('[NotificationService] Error al programar notificación: $e');
    }
  }

  /// Cancelar la notificación programada de Pomodoro
  Future<void> cancelPomodoroNotification() async {
    try {
      await _notificationsPlugin.cancel(id: pomodoroNotificationId);
    } catch (e) {
      debugPrint('[NotificationService] Error al cancelar notificación: $e');
    }
  }

  /// Cancelar todas las notificaciones de pomodoro (programada y completada)
  Future<void> cancelAllPomodoroNotifications() async {
    try {
      await _notificationsPlugin.cancel(id: pomodoroNotificationId);
      await _notificationsPlugin.cancel(id: pomodoroCompletionNotificationId);
    } catch (e) {
      debugPrint('[NotificationService] Error al cancelar notificaciones: $e');
    }
  }

  /// Mostrar notificación inmediata cuando concluye la fase en segundo plano o fuera de la app
  Future<void> showImmediateCompletionNotification({
    required PomodoroPhase phase,
    String? subjectName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Cancelar la alarma programada para evitar duplicados
    await cancelPomodoroNotification();

    final String title;
    final String body;

    switch (phase) {
      case PomodoroPhase.focus:
        title = '¡Pomodoro completado!';
        body = subjectName != null && subjectName.trim().isNotEmpty
            ? 'Completaste tu sesión de $subjectName. ¡Momento de descansar!'
            : '¡Excelente trabajo! Has completado tu tiempo de estudio. ¡Tómate un descanso!';
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
      await _notificationsPlugin.show(
        id: pomodoroCompletionNotificationId,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
      );
      debugPrint('[NotificationService] Notificación inmediata enviada: $title - $body');
    } catch (e) {
      debugPrint('[NotificationService] Error mostrando notificación inmediata: $e');
    }
  }

  int _eventNotificationId(String eventId) {
    return 1000 + (eventId.hashCode.abs() % 1000000);
  }

  /// Programar recordatorio con días de antelación para una actividad prioritaria
  Future<void> schedulePriorityEventNotification({
    required AcademicEventModel event,
    required String subjectName,
    required int noticeDays,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final notifId = _eventNotificationId(event.id);
    await cancelEventNotification(event.id);

    // Solo programar si es prioritario y no está completado
    if (!event.isPriority || event.isCompleted) {
      return;
    }

    final now = DateTime.now();

    // Calcular fecha y hora de la notificación con los días de antelación configurados
    DateTime scheduledDate;
    if (event.hasDueTime) {
      scheduledDate = event.dueAt.subtract(Duration(days: noticeDays));
    } else {
      // Si el evento no tiene hora fija, notificar a las 09:00 AM de esa fecha de antelación
      final targetDay = event.dueAt.subtract(Duration(days: noticeDays));
      scheduledDate = DateTime(targetDay.year, targetDay.month, targetDay.day, 9, 0);
    }

    // Si la fecha calculada ya pasó:
    // Comprobamos si el evento aún no ha vencido
    if (scheduledDate.isBefore(now)) {
      if (event.dueAt.isAfter(now.add(const Duration(minutes: 30)))) {
        // Vence pronto: notificar en 5 segundos
        scheduledDate = now.add(const Duration(seconds: 5));
      } else {
        // Ya venció o está venciendo ahora mismo, no programar
        return;
      }
    }

    final tzScheduledTime = tz.TZDateTime.from(scheduledDate, tz.local);

    final String dayWord = noticeDays == 1 ? '1 día' : '$noticeDays días';
    final String title = '⚠️ Actividad prioritaria: ${event.title}';
    final String formattedDate = TimeUtils.formatEventDate(event.dueAt, includeTime: event.hasDueTime);
    final String body = 'La actividad de $subjectName vence el $formattedDate ($dayWord de antelación). ¡No la dejes para el final!';

    const androidDetails = AndroidNotificationDetails(
      priorityEventsChannelId,
      priorityEventsChannelName,
      channelDescription: priorityEventsChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
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
        id: notifId,
        title: title,
        body: body,
        scheduledDate: tzScheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('[NotificationService] Notificación de evento prioritario programada: $tzScheduledTime (ID: $notifId)');
    } catch (e) {
      debugPrint('[NotificationService] Error al programar notificación de evento prioritario: $e');
    }
  }

  /// Cancelar recordatorio de un evento
  Future<void> cancelEventNotification(String eventId) async {
    try {
      final notifId = _eventNotificationId(eventId);
      await _notificationsPlugin.cancel(id: notifId);
    } catch (e) {
      debugPrint('[NotificationService] Error al cancelar notificación de evento: $e');
    }
  }

  int _subjectNotificationId(String subjectId) {
    return 2000000 + (subjectId.hashCode.abs() % 1000000);
  }

  /// Programar recordatorio de asignatura desatendida (notificación del dispositivo en segundo plano)
  Future<void> scheduleUnattendedSubjectNotification({
    required SubjectModel subject,
    required int thresholdDays,
  }) async {
    if (subject.isArchived || subject.isPassed) {
      await cancelSubjectNotification(subject.id);
      return;
    }

    final notifId = _subjectNotificationId(subject.id);
    await cancelSubjectNotification(subject.id);

    final now = DateTime.now();
    final DateTime baseDate = subject.lastStudiedAt ?? now;
    final targetDate = baseDate.add(Duration(days: thresholdDays));

    // Programar para las 18:00 (6:00 PM) del día en que se cumple el límite
    DateTime scheduledDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      18,
      0,
    );

    // Si la fecha u hora calculada ya pasó:
    if (scheduledDate.isBefore(now)) {
      final daysSince = now.difference(baseDate).inDays;
      if (daysSince >= thresholdDays) {
        // La asignatura ya lleva los días configurados desatendida.
        // Si aún es horario diurno razonable (< 21:00), avisar en breve (15 segundos).
        // Si ya es tarde, programar para mañana a las 11:00 AM.
        if (now.hour >= 9 && now.hour < 21) {
          scheduledDate = now.add(const Duration(seconds: 15));
        } else {
          final tomorrow = now.add(const Duration(days: 1));
          scheduledDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 11, 0);
        }
      } else {
        return;
      }
    }

    final tzScheduledTime = tz.TZDateTime.from(scheduledDate, tz.local);

    final String dayWord = thresholdDays == 1 ? '1 día' : '$thresholdDays días';
    final String title = '📚 ¡No descuides ${subject.name}!';
    final String body = subject.lastStudiedAt == null
        ? 'Aún no has registrado sesiones en ${subject.name}. ¡Dedícale un pomodoro hoy!'
        : 'Llevas más de $dayWord sin estudiar ${subject.name}. ¡Mantén el ritmo con una sesión!';

    const androidDetails = AndroidNotificationDetails(
      unattendedSubjectsChannelId,
      unattendedSubjectsChannelName,
      channelDescription: unattendedSubjectsChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
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
        id: notifId,
        title: title,
        body: body,
        scheduledDate: tzScheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('[NotificationService] Notificación de asignatura desatendida programada para ${subject.name}: $tzScheduledTime (ID: $notifId)');
    } catch (e) {
      debugPrint('[NotificationService] Error al programar notificación de asignatura desatendida: $e');
    }
  }

  /// Cancelar recordatorio de asignatura desatendida
  Future<void> cancelSubjectNotification(String subjectId) async {
    try {
      final notifId = _subjectNotificationId(subjectId);
      await _notificationsPlugin.cancel(id: notifId);
    } catch (e) {
      debugPrint('[NotificationService] Error al cancelar notificación de asignatura: $e');
    }
  }
}
