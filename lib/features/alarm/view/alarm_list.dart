// import 'package:flutter/material.dart';
// import 'package:healthapp/features/alarm/controller/alaram_controller.dart';
// import 'package:healthapp/features/alarm/view/add_alarm.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class AlarmListView extends StatefulWidget {
//   const AlarmListView({super.key});

//   @override
//   State<AlarmListView> createState() => _MyAppState();
// }

// class _MyAppState extends State<AlarmListView> {
//   bool value = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<AlarmController>().getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEEEFF5),
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurpleAccent,
//         actions: const [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(
//               Icons.menu,
//               color: Colors.white,
//             ),
//           )
//         ],
//         title: const Text(
//           'Alarm Clock ',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//                 color: Colors.deepPurpleAccent,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30))),
//             height: MediaQuery.of(context).size.height * 0.1,
//             child: Center(
//                 child: Text(
//               DateFormat.yMEd().add_jms().format(
//                     DateTime.now(),
//                   ),
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Colors.white),
//             )),
//           ),
//           Consumer<AlarmController>(builder: (context, alarm, child) {
//             return SizedBox(
//               height: MediaQuery.of(context).size.height * 0.7,
//               child: ListView.builder(
//                   itemCount: alarm.alarmList.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: MediaQuery.of(context).size.height * 0.15,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           alarm.alarmList[index].alarmTime!,
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                               color: Colors.black),
//                                         ),
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 8.0),
//                                           child: Text(
//                                               "|${alarm.alarmList[index].label}"),
//                                         ),
//                                       ],
//                                     ),
//                                     Switch.adaptive(
//                                         value: (DateTime.parse(alarm
//                                                         .alarmList[index]
//                                                         .alarmTime!)
//                                                     .microsecondsSinceEpoch <
//                                                 DateTime.now()
//                                                     .microsecondsSinceEpoch)
//                                             ? false
//                                             : alarm.alarmList[index].isActive ??
//                                                 false,
//                                         onChanged: (v) {
//                                           alarm.editSwitch(index, v);

//                                           // alarm.CancelNotification(
//                                           //     alarm.alarmList[index].id!);
//                                         }),
//                                   ],
//                                 ),
//                                 alarm.alarmList[index].doRepeat ?? false
//                                     ? const Text("Everyday")
//                                     : const Text("None"),
//                               ],
//                             ),
//                           ),
//                         ));
//                   }),
//             );
//           }),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.1,
//             decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30)),
//                 color: Colors.deepPurpleAccent),
//             child: Center(
//                 child: GestureDetector(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => const AddAlarm()));
//               },
//               child: Container(
//                   decoration: const BoxDecoration(
//                       color: Colors.white, shape: BoxShape.circle),
//                   child: const Padding(
//                     padding: EdgeInsets.all(12.0),
//                     child: Icon(Icons.add),
//                   )),
//             )),
//           ),
//         ],
//       ),
//     );
//   }
// }
