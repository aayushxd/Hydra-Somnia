import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/core/asset_path.dart';
import 'package:healthapp/core/db/hydrasnooze.dart';
import 'package:healthapp/core/extensions/app_extensions.dart';
import 'package:healthapp/core/service/alarm_manager.dart';
import 'package:healthapp/core/styles/app_color.dart';
import 'package:healthapp/features/homescreen/view/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

// providers
import '../../../utils/helpers/time_converter.dart';
import '../../../utils/widgets/custom_progress_indicator.dart';

class DataEntryScreen extends StatelessWidget {
  static const routeName = 'data-entry-screen';
  final UserTable userModel;
  const DataEntryScreen({super.key, required this.userModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.arrow_back_ios))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Icon(Icons.date_range),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'About you',
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 270),
                    child: Text(
                      'This information will let us help to calculate your daily recommended water intake amount and remind you to drink water in intervals.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.60),
                          height: 1.4,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(AssetPaths.displayPic),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${userModel.email}",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              DataEntryForm(
                userTable: userModel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key, required this.userTable});
  final UserTable userTable;
  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController waterController;
  @override
  void initState() {
    super.initState();
    waterController = TextEditingController(text: _weight.toString());
  }

  void toggleLoading() {
    setState(() {
      _loading = !_loading;
    });
  }

  // data
  String _gender = 'male';
  DateTime _birthday = DateTime(1997, 4, 1);
  int? _weight = 60;
  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 8, minute: 0);
  int _water = 2153;

  void submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    toggleLoading();
    try {
      ///FOR TESTING ONLY
      ///

      UserTable u = widget.userTable;
      UserTable user = UserTable();
      user.uid = u.uid;
      user.name = u.name;
      user.photoUrl = u.photoUrl;
      user.email = u.email;
      user.wakeUpTime = _wakeUpTime.convertTimeToString();
      user.dob = _birthday.YYYYMMDD();
      user.gender = _gender;
      user.weight = _weight;
      user.waterGoal = _water;

      print(user.toJson());
      BoolResult? done = await user.save();
      if (done.success) {
        cancelWaterReminderNotification();
        createWaterReminderNotification();
        Get.to(() => const HomeScreen());
      } else {
        Get.showSnackbar(const GetSnackBar(
          messageText: Text("Something went wrong. Try again later"),
        ));
      }
      return;
    } catch (e) {
      print(e);
    }
    toggleLoading();
  }

  void setWater({int? weight}) {
    if (_weight != null || weight != null) {
      double calWater = weight != null ? weight * 2.205 : _weight! * 2.205;
      calWater = calWater / 2.2;
      int age = DateTime.now().year - _birthday.year;
      if (age < 30) {
        calWater = calWater * 40;
      } else if (age >= 30 && age <= 55) {
        calWater = calWater * 35;
      } else {
        calWater = calWater * 30;
      }
      calWater = calWater / 28.3;
      calWater = calWater * 29.574;
      setState(() {
        _water = calWater.toInt();
        _weight = weight ?? _weight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  flex: 47,
                  child: DropdownButtonFormField<String>(
                    value: _gender,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: 'male',
                        child: Text(
                          'Male',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text(
                          'Female',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                    decoration: const InputDecoration(
                        border: InputBorder.none, label: Text("Gender")),
                    onChanged: (String? gender) {
                      setState(() {
                        _gender = gender!;
                      });
                    },
                  )),
              const Expanded(
                  flex: 6,
                  child: SizedBox(
                    width: 20,
                  )),
              Expanded(
                  flex: 47,
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1997, 4, 1),
                        firstDate: DateTime(1960),
                        lastDate: DateTime(DateTime.now().year - 12, 12, 31),
                      );
                      if (date != null) {
                        setState(() {
                          _birthday = date;
                        });
                        setWater();
                      }
                    },
                    controller: TextEditingController(
                        text: DateFormat.yMMMd('en_US').format(_birthday)),
                    decoration:
                        const InputDecoration(label: Text("Date of Birth")),
                  )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  flex: 47,
                  child: TextFormField(
                    controller: waterController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '60 kg',
                      suffixText: 'kg',
                      label: const Text("Weight"),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                    ),
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter weight';
                      }
                      if (double.parse(value) < 40) {
                        return 'You are underweight';
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter valid weight";
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      setWater(weight: int.tryParse(value));
                    },
                  )),
              const Expanded(
                flex: 6,
                child: SizedBox(
                  width: 20,
                ),
              ),
              Expanded(
                flex: 47,
                child: GestureDetector(
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                    );
                    if (time != null) {
                      setState(() {
                        _wakeUpTime = time;
                      });
                    }
                  },
                  child: TextFormField(
                    initialValue: timeConverter(_wakeUpTime),
                    decoration: InputDecoration(
                      suffix: const Icon(Icons.arrow_drop_down),
                      label: const Text("Wake Up Time"),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                    ),
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: TextEditingController(text: '$_water'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '2000 ml',
                      suffixText: 'ml',
                      label: const Text("Water Goal"),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 1)),
                    ),
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter water amount';
                      }
                      if (double.parse(value) < 1600) {
                        return 'Less than min water';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      setState(() {
                        _water = int.parse(value!);
                      });
                    },
                  )),
              const Expanded(
                child: SizedBox(
                  width: 0,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                ),
                onPressed: () {
                  toggleLoading();
                  submit();
                },
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CustomProgressIndicatior())
                    : Text(
                        'Let\'t go',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
              )
            ],
          )
        ],
      ),
    );
  }
}
