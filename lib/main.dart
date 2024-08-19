import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lcpl_academy/provider/notification_provider.dart';

import 'package:provider/provider.dart';
import 'package:lcpl_academy/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lcpl_academy/provider/visibility_provider.dart';
import 'package:lcpl_academy/screens/splashscreen/splash_screen.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    debugPrint('Some notification received in background');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    debugPrint('Notification received in Foreground');
    if (message.notification != null) {
      PushNotification.showSimpleNotification(
          title: message.notification!.title.toString(),
          body: message.notification!.body.toString(),
          payload: payloadData);
    }
  });
  final RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        debugPrint('Launched from terminated state');
        
      }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VisibilityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          title: 'LCPL Academy',
          navigatorKey: navigatorKey,
        ),
      ),
    ),
  );
}
