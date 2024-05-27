// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

extension SizeExtension on num {
  // double get w => ScreenUtil().setWidth(this).toDouble();
  // double get h => ScreenUtil().setHeight(this).toDouble();
  // double get sp => ScreenUtil().setSp(this).toDouble();
  double get fw => this * ScreenUtil().screenWidth / 100;
  double get fh => this * ScreenUtil().screenHeight / 100;
}

extension PaddingExtension on Widget {
  Widget pa(double a) {
    return Padding(
      padding: EdgeInsets.all(a),
      child: this,
    );
  }

  Widget p([double lp = 0, double rp = 0, double tp = 0, double bp = 0]) {
    return Padding(
      padding: EdgeInsets.only(left: lp, right: rp, top: tp, bottom: bp),
      child: this,
    );
  }

  Widget pt([double top = 0]) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: this,
    );
  }

  Widget pb([double bottom = 0]) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: this,
    );
  }

  Widget pl([double left = 0]) {
    return Padding(
      padding: EdgeInsets.only(left: left),
      child: this,
    );
  }

  Widget pr([double right = 0]) {
    return Padding(
      padding: EdgeInsets.only(right: right),
      child: this,
    );
  }

  Widget pv([double vertical = 0]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: this,
    );
  }

  Widget ph([double horizontal = 0]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: this,
    );
  }
}

extension MobileValidation on String {
  ///[isMobileNum] returns true if given string is a valid mobile number.
  /// Mobile number should start with 97 or 98 and its length should be exactly 10.

  bool isMobileNum() {
    if (length != 10) return false;
    if (startsWith('98') || startsWith('97')) return true;
    return false;
  }
}

extension EmailValidation on String {
  ///[isEmail] returns true if given string is a valid email address.
  bool isEmail() {
    RegExp emailReg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    bool isValid = emailReg.hasMatch(this);
    return isValid;
  }
}

extension DateFormatter on DateTime? {
  YYYYMDD() {
    DateTime date2 = this ?? DateTime.now();
    final format = DateFormat.yMMMEd();
    final formattedDate = format.format(date2);
    return formattedDate;
  }

  YYYYMMDD() {
    DateTime date2 = this ?? DateTime.now();
    final format = DateFormat("yyyy-MM-dd");
    final formattedDate = format.format(date2);
    return formattedDate;
  }

  YYYYMMDDHHMMSS() {
    DateTime date2 = this ?? DateTime.now();
    final format = DateFormat("yyyy-MM-dd hh:mm:ss");
    final formattedDate = format.format(date2);
    return formattedDate;
  }

  MDDYYYY() {
    DateTime date2 = this ?? DateTime.now();
    final format = DateFormat("MMM dd, yyyy");
    final formattedDate = format.format(date2);
    return formattedDate;
  }

  DDMMMYYYYAtmmhh() {
    DateTime date2 = this ?? DateTime.now();
    final format = DateFormat("dd MMM yyyy 'at' hh:mm a");
    final formattedDate =
        format.format(date2).replaceFirst('AM', 'am').replaceFirst('PM', 'pm');
    return formattedDate;
  }

  String HHMM() {
    // Create a DateFormat object with the desired format
    DateFormat dateFormat = DateFormat('hh:mm a');

    // Format the DateTime object and return the formatted string
    return dateFormat.format(this!);
  }

  /// return true if input date is same
  bool isSameDate(DateTime inputDate) {
    if (this == null) return false;
    return this?.year == inputDate.year &&
        this?.month == inputDate.month &&
        this?.day == inputDate.day;
  }
}

extension ConvertToDateTime on String {
  DateTime? toDateTime() {
    return DateTime.parse(
        DateFormat("yyyy-MM-dd").format(DateTime.parse(this).toLocal()));
  }
}

extension Casing on String {
  String toTitleCase() {
    List<String> words = split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords.join(' ');
  }
}

extension StringToTime on String {
  TimeOfDay toTimeOfDay() {
    // Split the time string into hours and minutes
    List<String> parts = split(':');

    // Parse hours and minutes from the split parts
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Create and return a TimeOfDay object
    return TimeOfDay(hour: hours, minute: minutes);
  }
}

extension TimeToString on TimeOfDay {
  String convertTimeToString() {
    // Get hour and minute from the TimeOfDay object
    int hour = this.hour;
    int minute = this.minute;

    // Format the hour and minute parts
    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');

    // Concatenate and return the formatted string
    return '$hourString:$minuteString';
  }
}
