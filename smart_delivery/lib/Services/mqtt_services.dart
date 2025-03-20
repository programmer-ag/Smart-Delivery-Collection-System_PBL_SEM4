// import 'dart:io';
// import 'dart:typed_data';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:typed_data/src/typed_buffer.dart';

// // adding the connection states that can exist into a single variable  'MqttCurrentConnectionState'
// enum MqttCurrentConnectionState {
//   IDLE,
//   CONNECTING,
//   CONNECTED,
//   DISCONNECTED,
//   ERROR_WHEN_CONNECTING
// }

// // adding the subscriptions states that can exist into a single variable  'MqttSubscriptionState'
// enum MqttSubscriptionState {
//   IDLE,
//   SUBSCRIBED
// }

// class MQTTClientWrapper
// {
//   late MqttServerClient client; // creating a client using the installed dependency 'mqtt_client' package

//   // adding the initial connection and subscription states for the particular device
//   MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
//   MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

//     // using async tasks, so the connection won't hinder the code flow
//     // all the four functions are user-defined
//   void prepareMqttClient() async {
//     _setupMqttClient();
//     await _connectClient();
//     _subscribeToTopic('Ultrasonic_data');
//     _publishMessage('Hello');
//   }

//   // waiting for the connection, if an error occurs, print it and disconnect
//   Future<void> _connectClient() async {
//     try {
//       print('client connecting....');
//       connectionState = MqttCurrentConnectionState.CONNECTING;
//       await client.connect('User02', 'User02pwd'); // using inbuilt function to connect the app to the cloud
//     } on Exception catch (e) {
//       print('client exception - $e');
//       connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
//       client.disconnect();
//     }

//     // when connected, print a confirmation, else print an error
//     if (client.connectionStatus!.state == MqttConnectionState.connected) {
//       connectionState = MqttCurrentConnectionState.CONNECTED;
//       print('client connected');
//     } else {
//       print(
//           'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
//       connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
//       client.disconnect();
//     }
//   }

//   void _setupMqttClient() {
//     client = MqttServerClient.withPort('7a2a780b399e4995b894915405365deb.s1.eu.hivemq.cloud', 'User02', 8883);
//     // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
//     client.secure = true;
//     client.securityContext = SecurityContext.defaultContext;
//     client.keepAlivePeriod = 20;
//     client.onDisconnected = _onDisconnected;
//     client.onConnected = _onConnected;
//     client.onSubscribed = _onSubscribed;
//   }

//   void _subscribeToTopic(String topicName) {
//     print('Subscribing to the $topicName topic');
//     client.subscribe(topicName, MqttQos.atMostOnce);

//     // print the message when it is received
//     client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//       final MqttPublishMessage? recMess = c[0].payload as MqttPublishMessage?;
//       var message = MqttPublishPayload.bytesToStringAsString(recMess!.payload.message);

//       print('YOU GOT A NEW MESSAGE:');
//       print(message);
//     });
//   }

//   void _publishMessage(String message) {
//   final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
//   builder.addString(message);

//   print('Publishing message "$message" to topic servo_bool');

//   final Uint8List? payload = builder.payload as Uint8List?;
//   if (payload == null) {
//     print('Error: Payload is null. Message not sent.');
//     return;
//   }

//   client.publishMessage('servo_bool', MqttQos.exactlyOnce, payload as Uint8Buffer);
// }

// void _onSubscribed(String topic) {
//     print('Subscription confirmed for topic $topic');
//     subscriptionState = MqttSubscriptionState.SUBSCRIBED;
//   }

//   void _onDisconnected() {
//     print('OnDisconnected client callback - Client disconnection');
//     connectionState = MqttCurrentConnectionState.DISCONNECTED;
//   }

//   void _onConnected() {
//     connectionState = MqttCurrentConnectionState.CONNECTED;
//     print('OnConnected client callback - Client connection was sucessful');
//   }
// }

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MqttService {
  // late MqttServerClient client;

  // void loadingDotenv () async{
  //   await dotenv.load();
  // }

  // await dotenv.load();

  String URL = dotenv.env['URL']!;
  String User = dotenv.env['USER']!;
  String pass = dotenv.env['PASS']!;
  int port = int.parse(dotenv.env['PORT']!);

  bool isConnected = false;
  static final MqttService _instance = MqttService._internal(); // calling a private named constructor and assigning it to a variable
  // by the above statement the instance of the class is created and assigned to the variable automatically inside the same class itself 
  late MqttServerClient client;

  // this is a factory constructor which will be called from the other files and the same instance would be returned in each and every file
  // therefore only once the connection will take place for every device in the app and we can directly use the functions subscribe and publish
  factory MqttService() {
    return _instance; 
  }

  MqttService._internal(); // defining a private named constructor in dart which is right now doing nothing

  // client.logging(on = true);  // ✅ Enable Debug Logging

//   Future<SecurityContext> loadSecurityContext() async {
//   final securityContext = SecurityContext.defaultContext;

//   try {
//     final caCert = await rootBundle.load('assets/certs/isrgrootx1.pem');
//     securityContext.setTrustedCertificatesBytes(caCert.buffer.asUint8List());
//     print('TLS Certificate Loaded Successfully');
//   } catch (e) {
//     print('Failed to load TLS certificate: $e');
//   }

//   return securityContext;
// }

Future<SecurityContext> loadSecurityContext() async {
  final securityContext = SecurityContext.defaultContext;

  try {
    // Load the certificate from assets
    final ByteData certData = await rootBundle.load('assets/certs/isrgrootx1.pem');

    // Set the certificate for trusted authentication
    securityContext.setTrustedCertificatesBytes(certData.buffer.asUint8List());
    
    print('TLS Certificate Loaded Successfully');
  } catch (e) {
    print('Failed to load TLS certificate: $e');
  }

  return securityContext;
}

  Future<void> connect() async {
    if(isConnected==true) return;
    // client = MqttServerClient.withPort(
    //   '7a2a780b399e4995b894915405365deb.s1.eu.hivemq.cloud', // Your HiveMQ Cloud Broker
    //   'User02', // Unique client ID
    //   8883, // Secure TLS Port
    // );

    client = MqttServerClient.withPort(
      URL, // Your HiveMQ Cloud Broker
      User, // Unique client ID
      port, // Secure TLS Port
    );

    // Enable TLS (Secure Connection)
    client.secure = true;
    client.securityContext =  await loadSecurityContext(); // Load custom TLS

    // Set keep-alive interval
    client.keepAlivePeriod = 20;

    // Set auto-reconnect on disconnect
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    // Set clean session and authentication (if required)
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(User)// .withClientIdentifier('User02')
        .startClean();
        // .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      print('Connecting to HiveMQ...');
      await client.connect(User, pass); // Set your HiveMQ Cloud credentials

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        print('Connected to HiveMQ Cloud!');
        isConnected = true;
        // client.subscribe('Ultrasonic_data', MqttQos.atMostOnce);
      } else {
        print('Failed to connect: ${client.connectionStatus}');
        client.disconnect();
      }
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    // client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
    //   final MqttPublishMessage recMessage = messages[0].payload as MqttPublishMessage;
    //   final String message = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
    //   print('Received message: $message from topic: ${messages[0].topic}');
    // });
    // subscibe("Ultrasonic_data");
    // publishMessage("servo_bool", "Motor Control");
  }

  void _onConnected() {
    print('MQTT Connected');
  }

  void _onDisconnected() {
    print('MQTT Disconnected');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  // void subscibe(String topic) {
  //   if(isConnected)
  //   {
  //     String message="";
  //     client.subscribe('Ultrasonic_data', MqttQos.atMostOnce);
  //     print("subcribed!!!!!");
  //     client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
  //     final MqttPublishMessage recMessage = messages[0].payload as MqttPublishMessage;
  //     message = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
  //     print('Received message: $message from topic: ${messages[0].topic}');
  //     });
  //   }
  //   else
  //   {
  //     print("MQTT not Connected");
  //   }
  // }

  void subscibe(String topic) {
    if(isConnected)
    {
      client.subscribe(topic, MqttQos.atMostOnce);
      print("subcribed!!!!!");
    }
    else
    {
      print("MQTT not Connected");
    }
  }

  void publishMessage(String topic, String message) {
    if(isConnected)
    {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      print('Published message: $message to topic: $topic');
    }
    else
    {
      print("MQTT not connected");
    }
  }

  void disconnectFromMQTT() {
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    client.disconnect();
    print("Disconnected from MQTT broker.");
  } else {
    print("Already disconnected.");
  }
}
}
