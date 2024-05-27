import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';

class AlarmController extends GetxController {
  RxList<AlarmSettings> alarms = <AlarmSettings>[].obs;

  void loadAlarms() {
    alarms.assignAll(Alarm.getAlarms());
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    update();
  }
  // List<String> listOfString = [];

  // late BuildContext context;
  // String? uid;
  // getUserId() async {
  //   AuthController authController = Get.find();
  //   User? user = await authController.getCurrentUser();
  //   if (user == null) Get.offAll(() => const LoginScreen());
  //   uid = user?.uid;
  //   update();
  // }

  // setAlarm(String label, String dateTime, bool isActive, bool repeat,
  //     DateTime notificationTime) async {
  //   AlarmModel alarmModel = AlarmModel(
  //     uid: uid!,
  //     label: label,
  //     alarmTime: dateTime,
  //     isActive: isActive,
  //     doRepeat: repeat,
  //   );
  //   int? aid = await alarmModel.save();
  //   if (aid != null) {
  //     await setBedTimeAlarm(id: aid, time: notificationTime, repeat: repeat);
  //     alarmList.add(alarmModel);
  //   }
  //   for (var e in alarmList) {
  //     print("e; ${e.toJson()}");
  //   }
  //   // await setBedTimeAlarm(id:  time:  notificationTime!, repeat:  repeat);

  //   update();
  // }

  // editSwitch(int index, bool check) {
  //   alarmList[index].isActive = check;
  //   update();
  // }

  // getData() async {
  //   List<AlarmModel> alist =
  //       await AlarmModel().select().uid.equals(uid).toList();
  //   alarmList.assignAll(alist);
  //   for (var a in alarmList) {
  //     print(a.toJson());
  //   }
  //   update();
  // }

  // // setData() async {
  // //   for (var alarm in alarmList) {
  // //     print("Set: ${alarm.toJson()}");
  // //     await alarm.save();
  // //   }
  // //   update();
  // // }

  // deleteAlarm(int id) async {
  //   BoolResult deleted = await AlarmModel().select().id.equals(id).delete();

  //   if (deleted.success) {
  //     cancelbedTimeAlarm(id);
  //     print(deleted);
  //     getData();
  //   }
  //   update();
  // }
}
