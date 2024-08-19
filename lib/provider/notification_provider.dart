import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');

    await getDeviceToken();
    await localNotiInit();

    // Listen for token refresh events
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      saveTokenToFirestore(newToken);
    });
  }

  static Future<void> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    if (token != null) {
      saveTokenToFirestore(token);
    }
    debugPrint('Token: $token');
  }

  // Store the token in Firestore under the user's document
  static Future<void> saveTokenToFirestore(String token) async {
    // Assume you have a userId representing the current user
    String userId = FirebaseAuth.instance.currentUser!.uid; // Replace with actual userId
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'deviceToken': token});
  }

  static Future localNotiInit() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap,
        onDidReceiveNotificationResponse: onNotificationTap);

    final AndroidFlutterLocalNotificationsPlugin?
        androidPlatformChannelSpecifics =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlatformChannelSpecifics?.requestNotificationsPermission();
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {}

  static Future showSimpleNotification(
      {required String title,
      required String body,
      required String payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails =
        const NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
