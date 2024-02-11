import 'package:hive/hive.dart';
import 'package:pocket_pal/model/expense.dart';

import '../interface/expense_service.dart';

class PersistentExpenseService implements ExpenseService {
  final Box box;

  PersistentExpenseService({required this.box});

  @override
  Future<void> deleteExpense(Expense expense) async {
    // TODO: implement deleteExpense
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    return box.values.cast<Expense>().toList();
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    // TODO: implement saveExpense
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    // TODO: implement updateExpense
  }
}
