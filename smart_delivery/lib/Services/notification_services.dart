import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

//INITIALISE
  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings(
            '@drawable/boxIcon'); // Use your custom icon

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await _notificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification Clicked: ${response.payload}");
    });

    // ✅ Request permission for Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    androidImplementation?.requestNotificationsPermission();
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body}) async {
    return _notificationsPlugin.show(id, title, body, notificationDetails());
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'myNotifID', 'You have received 1 new notification!',
            channelDescription: 'Daily NOTIFS',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            ticker: 'ticker'),
        iOS: DarwinNotificationDetails());
  }
}
