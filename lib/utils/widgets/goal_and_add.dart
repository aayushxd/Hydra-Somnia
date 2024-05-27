import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthapp/features/homescreen/provider/home_provider.dart';

// widgets
import './daily_amout_dial.dart';
import './daily_goal_amount.dart';
import './water_effect.dart';

class GoalAndAdd extends StatelessWidget {
  const GoalAndAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() {
          return Container(
              constraints: constraints,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const WaterEffect(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DailyGoalAmount(
                              totalGoal: homeController.waterGoal.value,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            DailyAmountDial(
                                percent: homeController.waterDrankPercent.value,
                                leftAmount: homeController.remWaterGoal.value),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
      },
    );
  }
}
