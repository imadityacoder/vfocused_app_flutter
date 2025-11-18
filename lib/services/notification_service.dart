import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Channel IDs
const String pomodoroChannelId = 'pomodoro_channel';
const String pomodoroDoneChannelId = 'pomodoro_done';

Future<void> initializeNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // ✅ Create channels for Android 8+
  const AndroidNotificationChannel pomodoroChannel = AndroidNotificationChannel(
    pomodoroChannelId,
    'Pomodoro Progress',
    description: 'Shows current Pomodoro timer progress',
    importance: Importance.max,
  );

  const AndroidNotificationChannel pomodoroDoneChannel =
      AndroidNotificationChannel(
        pomodoroDoneChannelId,
        'Pomodoro Complete',
        description: 'Notification when Pomodoro session finishes',
        importance: Importance.max,
      );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(pomodoroChannel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(pomodoroDoneChannel);
}

/// Show progress notification
Future<void> showPomodoroProgressNotification({
  required String sessionLabel,
  required Duration remaining,
  required Duration total,
}) async {
  final int progress =
      ((1 - remaining.inSeconds / total.inSeconds) * 100).toInt();

  final String formattedTime =
      "${remaining.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remaining.inSeconds.remainder(60).toString().padLeft(2, '0')}";

  final androidDetails = AndroidNotificationDetails(
    pomodoroChannelId,
    'Pomodoro Progress',
    channelDescription: 'Shows current Pomodoro timer progress',
    importance: Importance.max,
    priority: Priority.high,
    onlyAlertOnce: true,
    showProgress: true,
    maxProgress: 100,
    progress: progress,
    indeterminate: false,
  );

  final details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    1,
    "$sessionLabel Session",
    "⏳ $formattedTime remaining",
    details,
  );
}

/// Cancel progress notification
Future<void> cancelPomodoroNotification() async {
  await flutterLocalNotificationsPlugin.cancel(1);
}

/// Show session complete notification
Future<void> showSessionDoneNotification(String message) async {
  final androidDetails = AndroidNotificationDetails(
    pomodoroDoneChannelId,
    'Pomodoro Complete',
    importance: Importance.max,
    priority: Priority.high,
  );

  final details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    2,
    "Session Complete 🎉",
    message,
    details,
  );
}
