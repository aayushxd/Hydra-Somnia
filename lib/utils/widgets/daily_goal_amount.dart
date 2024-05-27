import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// providers

class DailyGoalAmount extends StatelessWidget {
  const DailyGoalAmount({super.key, required this.totalGoal});

  final int totalGoal;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: const Border(left: BorderSide(color: Colors.white, width: 2)),
        ),
        child: Row(
          children: [
            Text(
              'Goal',
              style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 19,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              width: 15,
            ),
            Text("$totalGoal".toString(),
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700))
          ],
        ),
      ),
    );
  }
}
