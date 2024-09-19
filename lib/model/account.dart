import 'package:hive/hive.dart';
import 'package:pocket_pal/model/income.dart';

part 'account.g.dart';

@HiveType(typeId: 3)
class Account extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double total = 0;

  @HiveField(2)
  int colorCode;

  @HiveField(2)
  List<Income> incomeList = [];

  Account({
    required this.name,
    required this.colorCode,
  });

  void addIncome(Income income) {
    incomeList.add(income);
    total += income.amount;
  }
}
