import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/core/service/alarm_manager.dart';
import 'package:healthapp/features/alarm/controller/alaram_controller.dart';
import 'package:healthapp/features/alarm/view/alarm_screen.dart';
import 'package:healthapp/features/alarm/view/ring.dart';
import 'package:healthapp/features/alarm/view/shortcut_button.dart';
import 'package:healthapp/features/homescreen/provider/home_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../../../core/styles/app_color.dart';
import '../../../utils/widgets/round_button.dart';
import '../../../utils/widgets/today_sleep_schedule_row.dart';
import 'sleep_add_alarm_view.dart';

class SleepScheduleView extends StatefulWidget {
  const SleepScheduleView({super.key});

  @override
  State<SleepScheduleView> createState() => _SleepScheduleViewState();
}

class _SleepScheduleViewState extends State<SleepScheduleView> {
  // late List<AlarmSettings> alarms;
  List todaySleepArr = [
    {
      "name": "Bedtime",
      "image": "assets/img/bed.png",
      "time": "01/06/2023 09:00 PM",
      "duration": "in 6hours 22minutes"
    },
    {
      "name": "Alarm",
      "image": "assets/img/alaarm.png",
      "time": "02/06/2023 05:10 AM",
      "duration": "in 14hours 30minutes"
    },
  ];

  List<int> showingTooltipOnSpots = [4];

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    HomeController homeController = Get.put(HomeController());
    homeController.getLastNightSleepRecord();
    loadAlarms();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    // subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
  }

  void loadAlarms() {
    AlarmController alarmController = Get.put(AlarmController());
    alarmController.loadAlarms();

    // setState(() {
    //   alarms = Alarm.getAlarms();
    //   alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    // });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    Get.to(() => AlarmRingScreen(alarmSettings: alarmSettings));

    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: SleepAddAlarmView(
            alarmSettings: settings,
          ),
        );
      },
    );

    if (res != null && res == true) loadAlarms();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AlarmController alarmController = Get.put(AlarmController());
    HomeController homeController = Get.put(HomeController());

    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          "Sleep Schedule",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.primaryG),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Last Night Sleep",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Obx(
                            () => Text(
                              homeController.lastNightSleepRecord.value,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/img/SleepGraph.png",
                          width: double.maxFinite,
                        )
                      ]),
                ).pa(16),
                SizedBox(
                  height: media.width * 0.05,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Your Schedule",
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(16),
                //     child: CalendarAgenda(
                //       controller: _calendarAgendaControllerAppBar,
                //       appbar: false,
                //       selectedDayPosition: SelectedDayPosition.center,
                //       // leading: IconButton(
                //       //     onPressed: () {},
                //       //     icon: Image.asset(
                //       //       "assets/img/ArrowLeft.png",
                //       //       width: 15,
                //       //       height: 15,
                //       //     )),
                //       // trailing: IconButton(
                //       //     onPressed: () {},
                //       //     icon: Image.asset(
                //       //       "assets/img/ArrowRight.png",
                //       //       width: 15,
                //       //       height: 15,
                //       //     )),
                //       weekDay: WeekDay.short,

                //       // dayNameFontSize: 12,
                //       // dayNumberFontSize: 16,
                //       // dayBGColor: Colors.grey.withOpacity(0.15),
                //       // titleSpaceBetween: 15,
                //       // calendarBackground: Colors.blue,
                //       // backgroundColor: Colors.yellow,
                //       fullCalendar: false,
                //       fullCalendarScroll: FullCalendarScroll.horizontal,
                //       fullCalendarDay: WeekDay.short,
                //       selectedDateColor: Colors.black54,
                //       dateColor: Colors.green,
                //       locale: 'en',
                //       initialDate: DateTime.now(),
                //       calendarEventColor: AppColors.primaryColor2,
                //       firstDate:
                //           DateTime.now().subtract(const Duration(days: 140)),
                //       lastDate: DateTime.now().add(const Duration(days: 60)),
                //       onDateSelected: (date) {
                //         _selectedDateAppBBar = date;
                //       },
                //       selectedDayLogo:
                //           const AssetImage('${AssetPaths.baseImgPath}bed.png'),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: media.width * 0.03,
                // ),
                Obx(
                  () => ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: alarmController.alarms.length,
                      itemBuilder: (context, index) {
                        return TodaySleepScheduleRow(
                          alarm: alarmController.alarms[index],
                          onDelete: () {
                            Alarm.stop(alarmController.alarms[index].id)
                                .then((_) => loadAlarms());
                          },
                        );
                      }),
                ),

                // Container(
                //     width: double.maxFinite,
                //     margin: const EdgeInsets.symmetric(
                //         vertical: 10, horizontal: 20),
                //     padding: const EdgeInsets.all(20),
                //     decoration: BoxDecoration(
                //         gradient: LinearGradient(colors: [
                //           AppColors.secondaryColor2.withOpacity(0.4),
                //           AppColors.secondaryColor1.withOpacity(0.4)
                //         ]),
                //         borderRadius: BorderRadius.circular(20)),
                //     child: const Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           "You will get 8hours 10minutes\nfor tonight",
                //           style: TextStyle(
                //             color: AppColors.blackColor,
                //             fontSize: 12,
                //           ),
                //         ),
                //         SizedBox(
                //           height: 15,
                //         ),
                //         // Stack(
                //         //   alignment: Alignment.center,
                //         //   children: [
                //         //     SimpleAnimationProgressBar(
                //         //       height: 15,
                //         //       width: media.width - 80,
                //         //       backgroundColor: Colors.grey.shade100,
                //         //       foregrondColor: Colors.purple,
                //         //       ratio: 0.96,
                //         //       direction: Axis.horizontal,
                //         //       curve: Curves.fastLinearToSlowEaseIn,
                //         //       duration: const Duration(seconds: 3),
                //         //       borderRadius: BorderRadius.circular(7.5),
                //         //       gradientColor: LinearGradient(
                //         //           colors: AppColors.secondaryG,
                //         //           begin: Alignment.centerLeft,
                //         //           end: Alignment.centerRight),
                //         //     ),
                //         //     const Text(
                //         //       "96%",
                //         //       style: TextStyle(
                //         //         color: AppColors.blackColor,
                //         //         fontSize: 12,
                //         //       ),
                //         //     ),
                //         //   ],
                //         // ),
                //       ],
                //     )),
              ],
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(20),
                height: media.width * 0.4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.primaryColor2.withOpacity(0.4),
                      AppColors.primaryColor.withOpacity(0.4)
                    ]),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Ideal Hours for Sleep",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            "8hours 30minutes",
                            style: TextStyle(
                                color: AppColors.normalBMIColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 110,
                            height: 35,
                            child: RoundButton(
                                title: "Learn More",
                                fontSize: 12,
                                onPressed: () async {
                                  final Uri url = Uri.parse(
                                      'https://www.sleepfoundation.org/how-sleep-works/how-much-sleep-do-we-really-need#:~:text=How%20Much%20Sleep%20Do%20You%20Need%3F%201%20Most,each%20night%20to%20stay%20happy%2C%20healthy%2C%20and%20sharp.');

                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                }),
                          )
                        ]),
                    Image.asset(
                      "assets/img/sleep_schedule.png",
                      width: media.width * 0.35,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   onPressed: () {
            //     HomeController homeController = Get.find();
            //     homeController.writeSleepData();
            //   },
            //   child: const Text("Write"),
            // ),
            // FloatingActionButton(
            //   onPressed: () {
            //     HomeController homeController = Get.find();
            //     homeController.getSleepData();
            //   },
            //   child: const Text("Get"),
            // ),
            // ExampleAlarmHomeShortcutButton(refreshAlarms: loadAlarms),
            InkResponse(
              onTap: () async {
                navigateToAlarmScreen(null);
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.secondaryG),
                    borderRadius: BorderRadius.circular(27.5),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2))
                    ]),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
