import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'mqtt_service.dart';
import 'notification_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final FlutterBackgroundService _service = FlutterBackgroundService();

  Future<void> initService() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onStart,
      ),
    );
    _service.startService();
  }

  static void onStart(ServiceInstance service) async {
    final mqttService = MqttService();
    final notificationService = NotificationService();

    await mqttService.connect();
    await notificationService.initNotifications();

    mqttService.client.updates!.listen((messages) {
      final message = mqttService.extractMessage(messages);
      if (message != null) {
        service.invoke('showNotification', {'message': message});
        notificationService.showNotification(message);
      }
    });
  }
}
