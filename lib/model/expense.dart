import 'package:hive/hive.dart';

import 'category.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  Category category;

  Expense({
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
  });
}
