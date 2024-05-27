// ignore_for_file: public_member_api_docs, sort_constructors_first
class WaterModel {
  int? amount;
  DateTime? time;

  WaterModel({required this.amount, required this.time});

  @override
  String toString() => 'WaterModel(amount: $amount, time: $time)';
}
