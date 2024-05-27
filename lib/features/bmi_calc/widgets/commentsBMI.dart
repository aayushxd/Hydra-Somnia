import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_color.dart';

Widget displayCommentsBMI(double bmiResult) {
  Widget displayCommentsBMI = Container(); // Initialize with a default value

  bmiResult <= 0
      ? displayCommentsBMI = Text(
          "Invalid height or weight",
          style: TextStyle(
            color: const Color.fromARGB(255, 209, 0, 80),
            decoration: TextDecoration.none,
            fontSize: ScreenUtil().setSp(24.0),
            fontFamily: 'RubikBold',
          ),
        )
      : bmiResult < 16 && bmiResult > 0
          ? displayCommentsBMI = Text(
              "Severe Thinness",
              style: TextStyle(
                color: AppColors.lowhighBMIColor,
                decoration: TextDecoration.none,
                fontSize: ScreenUtil().setSp(24.0),
                fontFamily: 'RubikBold',
              ),
            )
          : bmiResult >= 16 && bmiResult < 17
              ? displayCommentsBMI = Text(
                  "Moderate Thinness",
                  style: TextStyle(
                    color: AppColors.lowhighBMIColor,
                    decoration: TextDecoration.none,
                    fontSize: ScreenUtil().setSp(24.0),
                    fontFamily: 'RubikBold',
                  ),
                )
              : bmiResult >= 17 && bmiResult < 18.5
                  ? displayCommentsBMI = Text(
                      "Mild Thinness",
                      style: TextStyle(
                        color: AppColors.lowhighBMIColor,
                        decoration: TextDecoration.none,
                        fontSize: ScreenUtil().setSp(24.0),
                        fontFamily: 'RubikBold',
                      ),
                    )
                  : bmiResult >= 18.5 && bmiResult < 25
                      ? displayCommentsBMI = Text(
                          "Normal",
                          style: TextStyle(
                            color: AppColors.normalBMIColor,
                            decoration: TextDecoration.none,
                            fontSize: ScreenUtil().setSp(24.0),
                            fontFamily: 'RubikBold',
                          ),
                        )
                      : bmiResult >= 25 && bmiResult < 30
                          ? displayCommentsBMI = Text(
                              "Over Weight",
                              style: TextStyle(
                                color: AppColors.lowhighBMIColor,
                                decoration: TextDecoration.none,
                                fontSize: ScreenUtil().setSp(24.0),
                                fontFamily: 'RubikBold',
                              ),
                            )
                          : bmiResult >= 30 && bmiResult < 35
                              ? displayCommentsBMI = Text(
                                  "Obese Class 1",
                                  style: TextStyle(
                                    color: AppColors.lowhighBMIColor,
                                    decoration: TextDecoration.none,
                                    fontSize: ScreenUtil().setSp(24.0),
                                    fontFamily: 'RubikBold',
                                  ),
                                )
                              : bmiResult >= 35 && bmiResult < 40
                                  ? displayCommentsBMI = Text(
                                      "Obese Class 2",
                                      style: TextStyle(
                                        color: AppColors.lowhighBMIColor,
                                        decoration: TextDecoration.none,
                                        fontSize: ScreenUtil().setSp(24.0),
                                        fontFamily: 'RubikBold',
                                      ),
                                    )
                                  : displayCommentsBMI = Text(
                                      "Obese Class 3",
                                      style: TextStyle(
                                        color: AppColors.lowhighBMIColor,
                                        decoration: TextDecoration.none,
                                        fontSize: ScreenUtil().setSp(24.0),
                                        fontFamily: 'RubikBold',
                                      ),
                                    );

  return displayCommentsBMI;
}
