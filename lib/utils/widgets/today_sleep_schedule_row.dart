import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/features/alarm/controller/alaram_controller.dart';

import '../../core/styles/app_color.dart';

class TodaySleepScheduleRow extends StatefulWidget {
  final AlarmSettings alarm;
  final Function() onDelete;
  const TodaySleepScheduleRow(
      {super.key, required this.alarm, required this.onDelete});

  @override
  State<TodaySleepScheduleRow> createState() => _TodaySleepScheduleRowState();
}

class _TodaySleepScheduleRowState extends State<TodaySleepScheduleRow> {
  bool positive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                widget.alarm.notificationTitle == "Bedtime"
                    ? "assets/img/bed.png"
                    : "assets/img/alaarm.png",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.alarm.notificationTitle ?? "",
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.alarm.dateTime.HHMM(),
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 14,
                    ),
                  ),
                  // Text(
                  //   "widget.sObj[" "].toString()",
                  //   style: TextStyle(
                  //       color: AppColors.gray,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500),
                  // ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PopupMenuButton(
                  child: SizedBox(
                    height: 14,
                    child: Image.asset(
                      "assets/img/More_V.png",
                      width: 20,
                      height: 20,
                    ),
                  ).p(0, 6, 0, 6),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          onTap: () {
                            widget.onDelete();
                            // AlarmController alarmController =
                            //     Get.put(AlarmController());
                            // alarmController.deleteAlarm(widget.alarm.id);
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: AppColors.redColor),
                          ))
                    ];
                  },
                ),
                // SizedBox(
                //   height: 30,
                //   child: Transform.scale(
                //     scale: 0.7,
                //     child: CustomAnimatedToggleSwitch<bool>(
                //       current:   true,
                //       values: const [false, true],
                //       // dif: 0.0,
                //       indicatorSize: const Size.square(30.0),
                //       animationDuration: const Duration(milliseconds: 200),
                //       animationCurve: Curves.linear,
                //       onChanged: (b) => setState(() => positive = b),
                //       iconBuilder: (context, local, global) {
                //         return const SizedBox();
                //       },
                //       // defaultCursor: SystemMouseCursors.click,
                //       onTap: (s) => setState(() => widget.alarm.isActive =
                //           !(widget.alarm.isActive ?? false)),
                //       iconsTappable: false,
                //       wrapperBuilder: (context, global, child) {
                //         return Stack(
                //           alignment: Alignment.center,
                //           children: [
                //             Positioned(
                //                 left: 10.0,
                //                 right: 10.0,
                //                 height: 30.0,
                //                 child: DecoratedBox(
                //                   decoration: BoxDecoration(
                //                     gradient: LinearGradient(
                //                         colors: AppColors.secondaryG),
                //                     borderRadius: const BorderRadius.all(
                //                         Radius.circular(50.0)),
                //                   ),
                //                 )),
                //             child,
                //           ],
                //         );
                //       },
                //       foregroundIndicatorBuilder: (context, global) {
                //         return SizedBox.fromSize(
                //           size: const Size(10, 10),
                //           child: DecoratedBox(
                //             decoration: BoxDecoration(
                //               color: AppColors.white,
                //               borderRadius:
                //                   const BorderRadius.all(Radius.circular(50.0)),
                //               boxShadow: const [
                //                 BoxShadow(
                //                     color: Colors.black38,
                //                     spreadRadius: 0.05,
                //                     blurRadius: 1.1,
                //                     offset: Offset(0.0, 0.8))
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ));
  }
}
