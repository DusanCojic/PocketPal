import 'package:hive/hive.dart';
import 'package:pocket_pal/model/expense.dart';

import '../interface/expense_service.dart';

class PersistentExpenseService implements ExpenseService {
  final Box box;

  PersistentExpenseService({required this.box});

  @override
  Future<void> deleteExpense(Expense expense) async {
    await box.delete(expense.key);
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    return box.values.cast<Expense>().toList();
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    await box.add(expense);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await box.put(expense.key, expense);
  }

  void dispose() async => await box.close();
}
