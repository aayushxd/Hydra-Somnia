// utils

import '../utils/helpers/get_week.dart';

class WeeklyData {
  String? id;
  int? year;
  int? month;
  int? week;
  Map<String, dynamic>? amounts;
  int? dailyTarget;

  WeeklyData(
      {this.id,
      this.year,
      this.month,
      this.week,
      this.amounts,
      this.dailyTarget});

  factory WeeklyData.fromDoc(Map<String, dynamic> doc) {
    Map<String, dynamic> rawAmounts =
        doc.containsKey('amounts') ? doc['amounts'] : {};
    for (int i = 1; i <= 7; i++) {
      if (!rawAmounts.containsKey(i.toString())) {
        rawAmounts[i.toString()] = 0;
      }
    }
    return WeeklyData(
        id: doc['id'],
        year: doc['year'],
        month: doc['month'],
        week: doc['week'],
        amounts: rawAmounts,
        dailyTarget: doc['daily_target']);
  }

  Map<String, dynamic> createNewWeek(
      String id, int year, int month, int week, int target) {
    return {
      'id': id,
      'year': year,
      'month': month,
      'week': week,
      'daily_target': target
    };
  }

  double totalThisWeek() {
    double total = 0;
    amounts?.forEach((key, value) {
      total += value;
    });
    return total;
  }

  int percentThisWeek() {
    DateTime today = DateTime.now();
    int thisWeek = getWeek(today);
    double max;
    if (thisWeek == week && today.year == year) {
      max = dailyTarget != null
          ? (dailyTarget! * DateTime.now().weekday).toDouble()
          : 0;
    } else {
      max = dailyTarget != null ? (dailyTarget! * 7).toDouble() : 0;
    }
    double total = totalThisWeek();
    if (max == 0) return 0;
    return ((total / max) * 100).toInt();
  }
}
