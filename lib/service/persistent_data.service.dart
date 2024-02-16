import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/model/income.dart';
import 'package:pocket_pal/model/saving.dart';
import '../model/category.dart';

import '../interface/data_service.dart';
import '../interface/expense_service.dart';
import 'persistent_expense_service.dart';

class PersistentDataService implements DataService {
  late final ExpenseService _expenseService;

  @override
  ExpenseService getExpenseService() => _expenseService;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(IncomeAdapter());
    Hive.registerAdapter(SavingAdapter());

    Hive.openBox("expenses").then(
      (value) => _expenseService = PersistentExpenseService(
        box: value,
      ),
    );
  }
}
