import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/weekly_data.dart';
import '../values/months.dart';
import '../values/weekdays.dart';

class WeeklyStatisticsGraph extends StatelessWidget {
  final WeeklyData weeklyData;
  const WeeklyStatisticsGraph(this.weeklyData, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> bars = [];
    int max = 0;
    int maxH = 150;
    Map<String, dynamic> intakes = weeklyData.amounts!;

    for (int i = 1; i <= 7; i++) {
      if (intakes[i.toString()] > max) {
        max = intakes[i.toString()];
      }
    }
    for (int i = 1; i <= 7; i++) {
      num h = max == 0 ? 0 : maxH * (intakes[i.toString()] / max);
      bars.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: h.toDouble(),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 140, 238),
                  borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              weekdays[i]!,
              style: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      );
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 300,
        height: 270,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  alignment: Alignment.bottomCenter,
                  width: 300,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: bars,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 3,
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.blue[300]!,
                                      Colors.red[200]!
                                    ])),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Hydration',
                                style: GoogleFonts.poppins(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${weeklyData.percentThisWeek()} %',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 3,
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.blue[300]!,
                                      Colors.blue[100]!
                                    ])),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Intake',
                                style: GoogleFonts.poppins(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 12),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${(weeklyData.totalThisWeek() / 1000).toStringAsFixed(1)} L',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Week ${weeklyData.week}',
                        style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.5), fontSize: 14),
                      ),
                      Text(
                        '${months[weeklyData.month]}, ${weeklyData.year.toString()}',
                        style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.5), fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
