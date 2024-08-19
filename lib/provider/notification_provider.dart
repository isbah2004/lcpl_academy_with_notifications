import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
  }

  static Future<void> getDeviceToken() async {
    String? token = await firebaseMessaging.getToken();
    debugPrint('Token: $token');
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

void setupFirebaseListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Notification received in Foreground');
    if (message.notification != null) {
      PushNotification.showSimpleNotification(
        title: message.notification!.title ?? 'No Title',
        body: message.notification!.body ?? 'No Body',
        payload: jsonEncode(message.data), // Corrected payload handling
      );
    }
  });
}