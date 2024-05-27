import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/core/service/alarm_manager.dart';
import 'package:healthapp/features/alarm/controller/alaram_controller.dart';
import 'package:provider/provider.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlaramState();
}

class _AddAlaramState extends State<AddAlarm> {
  late TextEditingController controller;

  String? dateTime;
  bool repeat = false;

  DateTime? notificationTime;

  String? name = "none";
  int? Milliseconds;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.check),
          )
        ],
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Alarm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CupertinoDatePicker(
              showDayOfWeek: true,
              minimumDate: DateTime.now(),
              dateOrder: DatePickerDateOrder.dmy,
              onDateTimeChanged: (va) {
                print(va);
                dateTime = va.toLocal().YYYYMMDDHHMMSS();

                Milliseconds = va.microsecondsSinceEpoch;

                notificationTime = va;

                print(Milliseconds);
              },
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  decoration: const InputDecoration(labelText: "Add label"),
                  controller: controller,
                )),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(" Repeat daily"),
              ),
              Switch.adaptive(
                value: repeat,
                onChanged: (bool value) {
                  repeat = value;

                  if (repeat == false) {
                    name = "none";
                  } else {
                    name = "Everyday";
                  }

                  setState(() {});
                },
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                // context.read<AlarmController>().setAlarm(
                //       controller.text,
                //       dateTime!,
                //       true,
                //       repeat,
                //       notificationTime!,
                //     );

                Navigator.pop(context);
              },
              child: const Text("Set Alarm")),
        ],
      ),
    );
  }
}
