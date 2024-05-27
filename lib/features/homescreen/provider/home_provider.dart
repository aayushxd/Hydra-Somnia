import 'dart:collection';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:health/health.dart';
import 'package:healthapp/core/const/app_constants.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/core/service/notification_service.dart';
import 'package:healthapp/features/auth/provider/auth_provider.dart';
import 'package:healthapp/models/water_model.dart';

import '../../../repo/health_repo.dart';

class HomeController extends GetxController {
  final repository = HealthRepository();
  late NotificationService notificationService;

  RxInt waterGoal = 0.obs;
  RxInt remWaterGoal = 0.obs;
  RxDouble waterDrankPercent = 0.0.obs;
  RxInt totalWaterDrank = 0.obs;
  RxString lastNightSleepRecord = "".obs;

  RxList<WaterModel> waterInTakeToday = <WaterModel>[].obs;
  RxList<WaterModel> waterInTakeWholeWeek = <WaterModel>[].obs;

  bool goalReachedNotificationShown = false;

  initController() {
    getWaterGoal();

    getWaterData();
  }

  hitHydrationReminder() {
    notificationService = NotificationService();
    notificationService.createStayHydratedNotification();
  }

  getWaterGoal() async {
    AuthController authController = Get.find();
    User? gUser = await authController.getCurrentUser();
    print("gUser is $gUser");
    UserTable? user =
        await UserTable().select().uid.equals(gUser?.uid).toSingle();
    waterGoal.value = user?.waterGoal ?? 0;
    update();
  }

  Future<void> getWaterData() async {
    List<HealthDataPoint> waterData = await repository.getWaterInTakeToday();
    waterInTakeToday.clear();
    totalWaterDrank.value = 0;

    for (var s in waterData) {
      int amount =
          ((s.value.toJson()["numeric_value"] as double).toPrecision(3) * 1000)
              .toInt();
      final w = WaterModel(amount: amount, time: s.dateTo);
      totalWaterDrank.value += amount;
      waterInTakeToday.add(w);
    }
    remWaterGoal.value = waterGoal.value - totalWaterDrank.value;
    waterDrankPercent.value = totalWaterDrank.value / waterGoal.value;
    if (!goalReachedNotificationShown) {
      if (totalWaterDrank.value >= waterGoal.value) {
        NotificationService notificationService = NotificationService();
        await notificationService.createHydrationGoalReachedNotification();
        goalReachedNotificationShown = true;
      }
    }
    update();
  }

  Future<void> getWholeWeekWaterInTake() async {
    List<HealthDataPoint> waterData =
        await repository.getWholeWeekWaterInTake();

    Map<String, int> dailyTotal = HashMap();

    for (var s in waterData) {
      int amount =
          ((s.value.toJson()["numeric_value"] as double).toPrecision(3) * 1000)
              .toInt();
      DateTime date = s.dateTo;
      final w1 = WaterModel(amount: amount, time: s.dateTo);

      if (dailyTotal.containsKey(date.YYYYMMDD())) {
        print("${date.YYYYMMDD()} water $amount");
        dailyTotal[date.YYYYMMDD()] = dailyTotal[date.YYYYMMDD()]! + amount;
      }
      dailyTotal[date.YYYYMMDD()] = amount;
    }

    dailyTotal.forEach((day, amount) {
      print("$day: $amount liters");
    });

    update();
  }

  // void sumTotalWaterDrank() {
  //   totalWaterDrank.value = 0;
  //   for (var wd in waterInTakeToday) {
  //     totalWaterDrank.value += wd.amount ?? 0;
  //   }
  //   remWaterGoal.value = waterGoal.value - totalWaterDrank.value;
  //   update();
  // }

  Future<void> writeWaterData(int waterAmount) async {
    double amount = waterAmount / 1000;
    await repository.writeWaterData(amount).then((value) => getWaterData());
  }

  Future<void> getSleepData() async {
    await repository.getSleepRecord();
  }

  Future<void> writeSleepData() async {
    await repository.writeSleepRecord();
  }

  Future<void> getTotalStepsToday() async {
    await repository.getTotalStepsToday();
  }

  Future<void> getLastNightSleepRecord() async {
    List<HealthDataPoint> sleepData =
        await repository.getLastNightSleepRecord();
    for (var sd in sleepData) {
      Duration d = sd.dateTo.difference(sd.dateFrom);
      int dInMins = d.inMinutes;
      int h = dInMins ~/ 60;
      int m = dInMins % 60;
      String time = "${h}h ${m}m";
      lastNightSleepRecord.value = time;
    }
  }

//  Future<void> getWholeWeekSleepData() async {
//     List<HealthDataPoint> sleepData =
//         await repository.getLastNightSleepRecord();
//     for (var sd in sleepData) {
//       Duration d = sd.dateTo.difference(sd.dateFrom);
//       int dInMins = d.inMinutes;
//       int h = dInMins ~/ 60;
//       int m = dInMins % 60;
//       String time = "${h}h ${m}m";
//       String date= "${sd.}"
//     }
//   }
}
