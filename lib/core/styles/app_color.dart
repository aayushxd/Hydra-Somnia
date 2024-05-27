import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff10293d);
  // static const primaryColor = Color.fromARGB(255, 0, 60, 192);
  static const Color blueColor = Color(0xff112A40);
  static const Color redColor = Color.fromARGB(255, 181, 31, 31);
  static const Color greenColor = Color.fromARGB(255, 10, 156, 37);
  static const Color blackColor = Colors.black;
  static Color get primaryColor2 => const Color(0xff9DCEFF);
  static Color get white => const Color(0xffFFFFFF);

  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

  static const Color lowhighBMIColor = Color.fromARGB(255, 232, 185, 44);
  static const Color normalBMIColor = Color.fromARGB(255, 10, 156, 37);

  static Color get gray => const Color(0xff786F72);
  static Color get lightGray => const Color(0xffF7F8F8);

  static List<Color> get primaryG => [primaryColor2, primaryColor];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];
}
