import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class Income extends HiveObject {
  @HiveField(0)
  String source;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  Income({
    required this.source,
    required this.amount,
    required this.date,
  });
}
