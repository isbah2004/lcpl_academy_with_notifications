import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Map payload = {};

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
    }
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Message',
          style: GoogleFonts.ubuntu(),
        ),
      ),
      body: Center(child: Text(payload.toString(),),),
    );
  }
}
