import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthRepository {
  final health = Health();
  bool requested = false;

  getPermissions() async {
    requested = await health.requestAuthorization([
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.WATER,
    ], permissions: [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
    ]);
  }

  Future<void> writeWaterData(double amount) async {
    final permissionStatus = Permission.activityRecognition.request();
    getPermissions();
    if (requested) {
      bool done = await health
          .writeHealthData(
            amount,
            HealthDataType.WATER,
            DateTime.now(),
            DateTime.now().add(const Duration(seconds: 5)),
          )
          .then((value) {
            print("helloooo $value");
            return value;
          })
          .catchError((e) => print("e= $e"))
          .onError((error, stackTrace) {
            print("err= $error");
            return false;
          });
      print("waterrrrrr $done  ");
    }
  }

  Future<List<HealthDataPoint>> getWaterInTakeToday() async {
    final water = await health.getHealthDataFromTypes(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0,
          0, 0, 0),
      DateTime.now(),
      [
        HealthDataType.WATER,
      ],
      includeManualEntry: true,
    );
    print("water data: $water");
    // print(water);
    final waterRemovedDuplicates = health.removeDuplicates(water);
    for (var w in waterRemovedDuplicates) {
      print("water details: date : ${w.dateFrom}, ${w.value}, ${w.unit}");
    }
    return water;
  }

  Future<List<HealthDataPoint>> getWholeWeekWaterInTake() async {
    final water = await health.getHealthDataFromTypes(
      DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - 7, 0, 0, 0, 0),
      DateTime.now(),
      [
        HealthDataType.WATER,
      ],
      includeManualEntry: true,
    );
    print("water data: $water");
    // print(water);
    final waterRemovedDuplicates = health.removeDuplicates(water);
    for (var w in waterRemovedDuplicates) {
      print("water details: date : ${w.dateFrom}, ${w.value}, ${w.unit}");
    }
    return water;
  }

  Future<List<HealthDataPoint>> getSleepRecord() async {
    final sleep = await health.getHealthDataFromTypes(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 10,
      ),
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 1,
      ),
      [
        HealthDataType.SLEEP_SESSION,
      ],
      includeManualEntry: true,
    );
    print("sleep data: $sleep");
    for (var s in sleep) {
      print(
          "sleep details: date : ${s.dateFrom},to : ${s.dateFrom},  ${s.value}, ${s.unit}");
    }
    return sleep;
  }

  Future<List<HealthDataPoint>> getLastNightSleepRecord() async {
    final sleep = await health.getHealthDataFromTypes(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 1,
      ),
      DateTime.now(),
      [
        HealthDataType.SLEEP_SESSION,
      ],
      includeManualEntry: true,
    );
    print("sleep data: $sleep");
    for (var s in sleep) {
      print(
          "lastnight sleep details: date from: ${s.dateFrom},to : ${s.dateFrom}, ${s.value}, ${s.unit}");
    }
    return sleep;
  }

  Future<List<HealthDataPoint>> getWholeWeekSleepData() async {
    final sleep = await health.getHealthDataFromTypes(
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 7,
      ),
      DateTime.now(),
      [
        HealthDataType.SLEEP_SESSION,
      ],
      includeManualEntry: true,
    );
    print("sleep data: $sleep");
    for (var s in sleep) {
      print(
          "lastnight sleep details: date from: ${s.dateFrom},to : ${s.dateFrom}, ${s.value}, ${s.unit}");
    }
    return sleep;
  }

  Future<void> writeSleepRecord() async {
    final sleep = await health.writeHealthData(
      2,
      HealthDataType.SLEEP_ASLEEP,
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0,
          0, 0, 0),
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8,
          0, 0, 0),
    );
    print("sleep: $sleep");
  }

  Future<int> getTotalStepsToday() async {
    final steps = await health.getTotalStepsInInterval(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0,
          0, 0, 0),
      DateTime.now(),
    );
    // print(water);

    print("total steps today: $steps");
    return steps ?? 0;
  }
}
