import 'package:pocket_pal/model/category.dart';

import '../model/expense.dart';

abstract class ExpenseService {
  Future<List<Expense>> getAllExpenses();
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(Expense expense);
  Future<void> updateExpense(Expense expense);

  Future<List<Expense>> getTodayExpenses();
  Future<List<Expense>> getThisWeekExpenses();
  Future<List<Expense>> getThisMonthExpenses();
  Future<List<Expense>> getYTDExpenses();
  Future<List<Expense>> getLastYearExpenses();
  Future<List<Expense>> filterByCategory(Category category);
  Future<List<Expense>> filterByCategories(List<Category> category);
}
