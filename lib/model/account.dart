import 'package:hive/hive.dart';
import 'package:pocket_pal/model/income.dart';

part 'account.g.dart';

@HiveType(typeId: 3)
class Account extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double initialBalance;

  @HiveField(2)
  double total;

  @HiveField(3)
  int colorCode;

  @HiveField(4)
  List<Income> incomeList = [];

  Account({
    required this.name,
    required this.colorCode,
    this.initialBalance = 0,
    this.total = 0,
  });

  void addIncome(Income income) {
    incomeList.add(income);
    total += income.amount;
  }

  void removeIncome(Income income) {
    incomeList.remove(income);
    total -= income.amount;
  }
}
