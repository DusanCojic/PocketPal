import 'package:hive/hive.dart';

import 'category.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  int categoryId;

  Category? category;

  Expense({
    required this.description,
    required this.amount,
    required this.date,
    required this.categoryId,
  });

  factory Expense.fromJson(dynamic json) => Expense(
        description: json["description"],
        amount: (json["amount"] as num).toDouble(),
        date: DateTime.parse(json["date"]),
        categoryId: (json["categoryId"] as num).toInt(),
      );

  void setCategory(Category cat) => category = cat;
}
