import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/core/service/alarm_manager.dart';
import 'package:healthapp/core/styles/app_color.dart';
import 'package:healthapp/features/alarm/controller/alaram_controller.dart';

import '../../../utils/widgets/icon_title_next_row.dart';
import '../../../utils/widgets/round_button.dart';

class SleepAddAlarmView extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const SleepAddAlarmView({super.key, this.alarmSettings});

  @override
  State<SleepAddAlarmView> createState() => _SleepAddAlarmViewState();
}

class _SleepAddAlarmViewState extends State<SleepAddAlarmView> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late String assetAudio;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/ringtone/marimba.mp3';
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'After tomorrow';
      default:
        return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      assetAudioPath: assetAudio,
      androidFullScreenIntent: true,
      notificationTitle: "Hydrasnooze",
      notificationBody: '',
      enableNotificationOnKill: Platform.isAndroid,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) Get.back(result: true);
      setState(() => loading = false);
    });
    AlarmController controller = Get.find();
    controller.loadAlarms();
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res) Get.back(result: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.back(result: false);
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
                    "assets/img/closed_btn.png",
                    width: 15,
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                "Add Alarm",
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          IconTitleNextRow(
              icon: "assets/img/Bed_Add.png",
              title: "Bedtime",
              time: TimeOfDay.fromDateTime(selectedDateTime).format(context),
              color: AppColors.lightGray,
              onPressed: () {
                pickTime();
                // showTimePicker(
                //   context: context,
                //   initialTime: TimeOfDay.now(),
                // ).then((time) {
                //   if (time != null) {
                //     DateTime dateTime = DateTime(
                //         DateTime.now().year,
                //         DateTime.now().month,
                //         DateTime.now().day,
                //         time.hour,
                //         time.minute);
                //     if (dateTime.isBefore(DateTime.now())) {
                //       notificationTime = DateTime(
                //           DateTime.now().year,
                //           DateTime.now().month,
                //           DateTime.now().day + 1,
                //           time.hour,
                //           time.minute);
                //     } else {
                //       notificationTime = dateTime;
                //     }
                //     alarmTime = notificationTime!.toLocal().YYYYMMDDHHMMSS();
                //   }
                //   setState(() {});
                // });
              }),
          const SizedBox(
            height: 10,
          ),
          // IconTitleNextRow(
          //     icon: "assets/img/HoursTime.png",
          //     title: "Hours of sleep",
          //     time: "8hours 30minutes",
          //     color: AppColors.lightGray,
          //     onPressed: () {}),
          // const SizedBox(
          //   height: 10,
          // ),
          vibrateTile(),
          const SizedBox(
            height: 10,
          ),
          soundTile(context),
          const SizedBox(
            height: 10,
          ),

          customVolTile(context),
          const SizedBox(
            height: 10,
          ),

          vol(),
          const SizedBox(
            height: 10,
          ),

          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
          const Spacer(),
          RoundButton(
              title: "Add",
              onPressed: () async {
                saveAlarm();
                // print(
                //     "notification time $notificationTime, repeat: $repeat, vibrate: $positive");
                // AlarmController alarmController = Get.find<AlarmController>();
                // alarmController.setAlarm(
                //   controller.text,
                //   alarmTime!,
                //   true,
                //   repeat,
                //   notificationTime!,
                // );

                Get.back();
              }),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  SizedBox vol() {
    return SizedBox(
      height: 30,
      child: volume != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  volume! > 0.7
                      ? Icons.volume_up_rounded
                      : volume! > 0.1
                          ? Icons.volume_down_rounded
                          : Icons.volume_mute_rounded,
                ),
                Expanded(
                  child: Slider(
                    value: volume!,
                    onChanged: (value) {
                      setState(() => volume = value);
                    },
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Container customVolTile(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 15,
          ),
          const Icon(
            Icons.volume_up_outlined,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Custom volume',
            style: TextStyle(fontSize: 12, color: AppColors.gray),
          ),
          const Spacer(),
          // Switch(
          //   value: volume != null,
          //   onChanged: (value) => setState(() => volume = value ? 0.5 : null),
          // ),
          SizedBox(
            height: 30,
            child: Transform.scale(
              scale: 0.7,
              child: CustomAnimatedToggleSwitch<bool>(
                current: volume != null,
                values: const [false, true],
                // dif: 0.0,
                indicatorSize: const Size.square(30.0),
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.linear,
                onChanged: (value) =>
                    setState(() => volume = value ? 0.5 : null),
                iconBuilder: (context, local, global) {
                  return const SizedBox();
                },
                // defaultCursor: SystemMouseCursors.click,
                onTap: (value) =>
                    setState(() => volume = value.tapped!.value ? 0.5 : null),
                iconsTappable: false,
                wrapperBuilder: (context, global, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          left: 10.0,
                          right: 10.0,
                          height: 30.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: volume != null
                                  ? LinearGradient(colors: AppColors.secondaryG)
                                  : LinearGradient(colors: [
                                      AppColors.primaryColor,
                                      AppColors.gray,
                                    ]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                            ),
                          )),
                      child,
                    ],
                  );
                },
                foregroundIndicatorBuilder: (context, global) {
                  return SizedBox.fromSize(
                    size: const Size(10, 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 0.05,
                              blurRadius: 1.1,
                              offset: Offset(0.0, 0.8))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container soundTile(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 15,
          ),
          Icon(
            Icons.music_note_outlined,
            color: AppColors.gray,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Sound',
            style: TextStyle(color: AppColors.gray, fontSize: 12),
          ),
          const Spacer(),
          DropdownButton(
            value: assetAudio,
            style: TextStyle(fontSize: 12, color: AppColors.gray),
            items: const [
              DropdownMenuItem<String>(
                value: 'assets/ringtone/marimba.mp3',
                child: Text('Marimba'),
              ),
              DropdownMenuItem<String>(
                value: 'assets/ringtone/nokia.mp3',
                child: Text('Nokia'),
              ),
              DropdownMenuItem<String>(
                value: 'assets/ringtone/mozart.mp3',
                child: Text('Mozart'),
              ),
              DropdownMenuItem<String>(
                value: 'assets/ringtone/star_wars.mp3',
                child: Text('Star Wars'),
              ),
              DropdownMenuItem<String>(
                value: 'assets/ringtone/one_piece.mp3',
                child: Text('One Piece'),
              ),
            ],
            onChanged: (value) => setState(() => assetAudio = value!),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  Container vibrateTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 15,
          ),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/img/Vibrate.png",
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Vibrate When Alarm Sound",
            style: TextStyle(color: AppColors.gray, fontSize: 12),
          ),
          const Spacer(),
          SizedBox(
            height: 30,
            child: Transform.scale(
              scale: 0.7,
              child: CustomAnimatedToggleSwitch<bool>(
                current: vibrate,
                values: const [false, true],
                // dif: 0.0,
                indicatorSize: const Size.square(30.0),
                animationDuration: const Duration(milliseconds: 200),
                animationCurve: Curves.linear,
                onChanged: (value) => setState(() => vibrate = value),
                iconBuilder: (context, local, global) {
                  return const SizedBox();
                },
                // defaultCursor: SystemMouseCursors.click,
                onTap: (value) => setState(() => vibrate = value.tapped!.value),
                iconsTappable: false,
                wrapperBuilder: (context, global, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          left: 10.0,
                          right: 10.0,
                          height: 30.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: vibrate
                                  ? LinearGradient(colors: AppColors.secondaryG)
                                  : LinearGradient(colors: [
                                      AppColors.primaryColor,
                                      AppColors.gray,
                                    ]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                            ),
                          )),
                      child,
                    ],
                  );
                },
                foregroundIndicatorBuilder: (context, global) {
                  return SizedBox.fromSize(
                    size: const Size(10, 10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 0.05,
                              blurRadius: 1.1,
                              offset: Offset(0.0, 0.8))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container repeatTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 15,
          ),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/img/Repeat.png",
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Repeat",
              style: TextStyle(color: AppColors.gray, fontSize: 12),
            ),
          ),
          //       SizedBox(
          //         height: 30,
          //         child: Transform.scale(
          //           scale: 0.7,
          //           child: CustomAnimatedToggleSwitch<bool>(
          //             current: repeat,
          //             values: const [false, true],
          //             // dif: 0.0,
          //             indicatorSize: const Size.square(30.0),
          //             animationDuration: const Duration(milliseconds: 200),
          //             animationCurve: Curves.linear,
          //             onChanged: (b) => setState(() => repeat = b),
          //             iconBuilder: (context, local, global) {
          //               return const SizedBox();
          //             },
          //             // defaultCursor: SystemMouseCursors.click,
          //             onTap: (s) => setState(() => repeat = s.tapped!.value),
          //             iconsTappable: false,
          //             wrapperBuilder: (context, global, child) {
          //               return Stack(
          //                 alignment: Alignment.center,
          //                 children: [
          //                   Positioned(
          //                       left: 10.0,
          //                       right: 10.0,
          //                       height: 30.0,
          //                       child: DecoratedBox(
          //                         decoration: BoxDecoration(
          //                           gradient: repeat
          //                               ? LinearGradient(
          //                                   colors: AppColors.secondaryG)
          //                               : LinearGradient(
          //                                   colors: [
          //                                     AppColors.primaryColor,
          //                                     AppColors.gray
          //                                   ],
          //                                 ),
          //                           borderRadius: const BorderRadius.all(
          //                               Radius.circular(50.0)),
          //                         ),
          //                       )),
          //                   child,
          //                 ],
          //               );
          //             },
          //             foregroundIndicatorBuilder: (context, global) {
          //               return SizedBox.fromSize(
          //                 size: const Size(10, 10),
          //                 child: DecoratedBox(
          //                   decoration: BoxDecoration(
          //                     color: AppColors.white,
          //                     borderRadius:
          //                         const BorderRadius.all(Radius.circular(50.0)),
          //                     boxShadow: const [
          //                       BoxShadow(
          //                           color: Colors.black38,
          //                           spreadRadius: 0.05,
          //                           blurRadius: 1.1,
          //                           offset: Offset(0.0, 0.8))
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
