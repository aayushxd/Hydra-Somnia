// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'dart:typed_data';

// Future<void> waterNotification(int left) async {
//   try {
//     FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
//     NotificationDetails notificationDetails = getNotificationDetails();
//     await plugin.cancel(1);
//     await plugin.schedule(
//         1,
//         "Hey, it's time to drink water",
//         "$left mL water left to drink today",
//         DateTime.now().add(const Duration(hours: 1, minutes: 30)),
//         notificationDetails);
//   } catch (e) {
//     print(e);
//   }
// }

// Future<void> cancelAllNotifications() async {
//   try {
//     FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
//     await plugin.cancelAll();
//   } catch (e) {
//     print(e);
//   }
// }
