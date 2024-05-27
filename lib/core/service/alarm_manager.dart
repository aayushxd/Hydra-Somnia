import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:healthapp/core/const/app_constants.dart';
import 'package:healthapp/core/service/notification_service.dart';

Future<void> setBedTimeAlarm(
    {required int id, required DateTime time, required bool repeat}) async {
  print("alarm time $time");
  if (repeat) {
    await AndroidAlarmManager.periodic(
      const Duration(seconds: 15),
      id,
      bedTimeAlarmCallback,
      exact: true,
      startAt: time,
      
      allowWhileIdle: true,
      wakeup: true,
    );
  } else {
    await AndroidAlarmManager.oneShotAt(
      time,
      AppConstants.bedtimeAlarmId,
      bedTimeAlarmCallback,
      exact: true,
      alarmClock: true,

      allowWhileIdle: true,
      wakeup: true,
    );
  }
}

createWaterReminderNotification() async {
  log("<--------------------------------------->");
  log("Creating water reminder notification ${DateTime.now()}");
  log("<--------------------------------------->");
  await AndroidAlarmManager.periodic(
    const Duration(seconds: 30),
    AppConstants.bedtimeAlarmId,
    waterReminderCallback,
    startAt: DateTime.now().add(const Duration(minutes: 1)),
    exact: true,
    allowWhileIdle: true,
    wakeup: true,
  );
}

//callbacks
waterReminderCallback() {
  NotificationService notificationService = NotificationService();
  notificationService.createWaterReminderNotification();
}

bedTimeAlarmCallback() {
  NotificationService notificationService = NotificationService();
  notificationService.createBedtimeNotification();
}

//cancel section
cancelWaterReminderNotification() async {
  await AndroidAlarmManager.cancel(AppConstants.hydrationReminderId);
}

cancelbedTimeAlarm(int id) async {
  await AndroidAlarmManager.cancel(id);
}
