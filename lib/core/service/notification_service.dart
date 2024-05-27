import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/const/app_constants.dart';

class NotificationService {
  init() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          enableVibration: true,
          playSound: true,
          channelShowBadge: true,
          channelDescription: 'This is a basic notification',
        ),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          defaultColor: Colors.teal,
          locked: true,
          enableVibration: true,
          playSound: true,
          importance: NotificationImportance.High,
          channelDescription: 'This is a basic notification',
        ),
      ],
    );

    AwesomeNotifications().requestPermissionToSendNotifications().then((value) {
      if (!value) {
        Get.showSnackbar(
            const GetSnackBar(titleText: Text("Permissioned Denied")));
      }
    });
  }

  Future<void> createStayHydratedNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: '${Emojis.wheater_droplet} Drink Water!!!',
        body: 'Stay hydrated throughout your busy day.',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  Future<void> createHydrationGoalReachedNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: '${Emojis.smile_partying_face} Congratulations!!!',
        body: "You've successfully reached your goal. Keep it up! ",
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  Future<void> createWaterReminderNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: '${Emojis.wheater_droplet} Drink Water!!!',
        body: 'Drink water and keep yourself hydrated.',
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done',
        ),
      ],
    );
  }

  Future<void> createWakeUpNotification(DateTime time, bool repeat) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: AppConstants.wakeUpAlarmId,
        channelKey: 'basic_channel',
        title: '${Emojis.time_alarm_clock} Wake Uppp!!!',
        body: "It's time to get upppp!!",
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done',
        ),
      ],
      // schedule: NotificationCalendar(
      //   hour: time.hour,
      //   minute: time.minute,
      //   second: 0,
      //   millisecond: 0,
      //   repeats: repeat,
      //   year: time.year,
      //   month: time.month,
      //   day: time.day,
      //   allowWhileIdle: true,
      //   preciseAlarm: true,
      // ),
    );
  }

  Future<void> createBedtimeNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: AppConstants.bedtimeAlarmId,
        channelKey: 'basic_channel',
        title: '${Emojis.household_bed} Bedtime!!!',
        body: "It's time to sleep!!",
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done',
        ),
      ],
      // schedule: NotificationCalendar(
      //   hour: time.hour,
      //   minute: time.minute,
      //   second: 0,
      //   millisecond: 0,
      //   repeats: repeat,
      //   year: time.year,
      //   month: time.month,
      //   day: time.day,
      //   allowWhileIdle: true,
      //   preciseAlarm: true,
      // ),
    );
  }

  Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  Future<void> cancelBedTimeNotification() async {
    await AwesomeNotifications().cancel(AppConstants.bedtimeAlarmId);
  }

  Future<void> cancelWakeUpNotification() async {
    await AwesomeNotifications().cancel(AppConstants.wakeUpAlarmId);
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
