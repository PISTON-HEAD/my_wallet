import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotifyManager
{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings("logo");
  void initializeNotification()async{
    InitializationSettings initializationSettings =  InitializationSettings(
      android: androidInitializationSettings,
    );

   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Future<void> sendNotification(String? title, String body  ) async {
  //   AndroidNotificationDetails details =const AndroidNotificationDetails("channelId", "channelName",importance: Importance.max,priority: Priority.high);
  //   NotificationDetails notificationDetails =  NotificationDetails(android: details);
  //   await flutterLocalNotificationsPlugin.show(1, title, body, notificationDetails);
  // }

  Future<void> scheduleNotification(String? title, String body, DateTime repeatInterval ) async {
    AndroidNotificationDetails details =const AndroidNotificationDetails("channelId", "channelName",importance: Importance.max,priority: Priority.high,playSound: true,color: Colors.lightBlue,colorized: true,enableLights: true,visibility: NotificationVisibility.public);
    NotificationDetails notificationDetails =  NotificationDetails(android: details);
    await flutterLocalNotificationsPlugin.schedule(2, title, body,repeatInterval, notificationDetails);
  }
}
