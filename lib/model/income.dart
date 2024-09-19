import 'package:hive/hive.dart';

part 'income.g.dart';

@HiveType(typeId: 2)
class Income extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  DateTime date;

  Income({
    required this.amount,
    required this.date,
  });
}
