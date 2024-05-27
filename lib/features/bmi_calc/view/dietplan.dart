import 'package:flutter/material.dart';

import '../widgets/dietplanWidget.dart';

class DietPlan extends StatefulWidget {
  final double bmi;
  const DietPlan({super.key, required this.bmi});

  @override
  State<DietPlan> createState() => _DietPlanState();
}

class _DietPlanState extends State<DietPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: displayDietPlan(widget.bmi),
    );
  }
}
