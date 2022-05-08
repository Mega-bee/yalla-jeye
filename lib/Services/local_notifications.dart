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
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationPlugin.initialize(initializationSettings,
        onSelectNotification: (String payloadRoute) async {
          // Navigator.pushNamed(context, payloadRoute);
          // Navigator.pushNamedAndRemoveUntil(
          //     context, payloadRoute, (route) => false);
          // demo data
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TabBarOrder(0, 333)));
        });
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "easyapproach",
            "easyapproach channel",
            channelDescription: "this is our channel",
            importance: Importance.max,
            priority: Priority.high,
          ));
      await _notificationPlugin.show(id, message.notification.title,
          message.notification.body, notificationDetails,
          payload: 'routePage'
      );
    } on Exception catch (e) {
      print(e);
    }
  }





}


// class fcmId{
//   static Future<void> setFcmId(String fcmId) async {
//     var pref = await SharedPreferences.getInstance();
//     await pref.setString(fcmId, fcmId);
//   }
//
//   static Future<String> getFcmId(String fcmId) async {
//     return (await SharedPreferences.getInstance()).getString(fcmId) ?? null;
//   }
// }