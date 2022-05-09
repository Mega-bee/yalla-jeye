import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:yallajeye/screens/order/tabbar_order.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(requestSoundPermission: true);
    final InitializationSettings initializationSettingss =
        InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    _notificationPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      print("Payload:${payload}");
      if (payload != null) {
        var message = jsonDecode(payload);
        print("decode 1");
        print(message);
        int id = int.parse(message["orderId"].toString());
        print("id is: ${id.toString()}");
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TabBarOrder(numTab: 0, id: id)));
      }
    });
  }

  static Future<void> display(RemoteMessage message) async {
    // print("RemoteMssg: ${json.encode(message)}");
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "easyapproach",
        "easyapproach channel",
        channelDescription: "this is our channel",
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        playSound: true,
        channelShowBadge: true,
        enableLights: true,
        enableVibration: true,
        onlyAlertOnce: false,
      ));
      await _notificationPlugin.show(id, message.notification.title,
          message.notification.body, notificationDetails,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      print(e);
    }
  }
}
