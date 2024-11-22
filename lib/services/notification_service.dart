import 'dart:convert'; // For decoding the JSON
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  late PusherClient pusher;
  late Channel channel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeLocalNotifications();
  }

  // Step 1: Initialize Local Notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Step 2: Initialize Pusher
  void initPusher(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    pusher = PusherClient(
      "8f1f7954cad57de37b4a", // Replace with your Pusher App Key
      PusherOptions(
        cluster: "eu", // Replace with your Pusher Cluster
        auth: PusherAuth(
          "https://preprod.solaris-crfpe.fr/api/authenticateVerify", // Laravel Echo auth endpoint
          headers: {
            "Authorization": "Bearer $token", // Pass user token if required
          },
        ),
      ),
      enableLogging: true,
    );

    channel = pusher.subscribe('private-App.User.$userId');
    channel
        .bind("Illuminate\\Notifications\\Events\\BroadcastNotificationCreated",
            (event) {
      // Null check for event.data
      if (event?.data != null) {
        _handleNotification(
            json.decode(event!.data!)); // Ensure the data is non-null
      }
    });

    pusher.connect();
  }

  // Step 3: Handle Incoming Notifications
  void _handleNotification(Map<String, dynamic> data) {
    final title = data['title'] ?? 'New Notification';
    final content = data['content'] ?? 'No details provided';

    // Display a local notification
    _showLocalNotification(title, content);
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
  }
}
