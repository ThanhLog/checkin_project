import 'dart:io';

import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/provider/auth_provider.dart';
import 'package:app_checkin/router/navigator_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  Future<void> _initFirebaseMessaging() async {
    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.requestPermission();
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground message received: ${message.data}");
      _showNotification(message);
    });

    String? token;
    for (int i = 0; i < 3; i++) {
      token = await FirebaseMessaging.instance.getToken();
      if (token != null) break;
      await Future.delayed(const Duration(seconds: 2));
    }
    setState(() {
      _token = token;
    });

    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      authProvider.setFcmToken(_token);
    }

    print("🔑 FCM Token: $_token");
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          channelDescription: 'Default channel for notifications',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Thông báo',
      message.notification?.body ?? '',
      platformDetails,
      payload: message.data.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.splashScreen,
      onGenerateRoute: NavigatorService.generate,
    );
  }
}
