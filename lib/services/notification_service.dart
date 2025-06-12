import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

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
    'pomodoro_channel',
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

Future<void> cancelPomodoroNotification() async {
  await flutterLocalNotificationsPlugin.cancel(1);
}

Future<void> showSessionDoneNotification(String message) async {
  await flutterLocalNotificationsPlugin.show(
    2,
    "Session Complete 🎉",
    message,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'pomodoro_done',
        'Pomodoro Complete',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}
