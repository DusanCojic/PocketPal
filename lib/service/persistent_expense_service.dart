import 'package:hive/hive.dart';
import 'package:pocket_pal/model/category.dart';
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

  Future<void> dispose() async => await box.close();

  @override
  Future<List<Expense>> filterByCategories(List<Category> category) async {
    return box.values
        .cast<Expense>()
        .where((element) => category.any((cat) => element.category == cat))
        .toList();
  }

  @override
  Future<List<Expense>> filterByCategory(Category category) async {
    return box.values
        .cast<Expense>()
        .where((element) => element.category == category)
        .toList();
  }

  @override
  Future<List<Expense>> getThisMonthExpenses() async {
    DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return getExpensesAfter(thirtyDaysAgo);
  }

  @override
  Future<List<Expense>> getThisWeekExpenses() async {
    DateTime weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return getExpensesAfter(weekAgo);
  }

  @override
  Future<List<Expense>> getLastYearExpenses() async {
    DateTime yearAgo = DateTime.now().subtract(const Duration(days: 365));
    return getExpensesAfter(yearAgo);
  }

  @override
  Future<List<Expense>> getTodayExpenses() async {
    DateTime today = DateTime.now();
    return box.values
        .cast<Expense>()
        .where((element) =>
            element.date.day == today.day &&
            element.date.month == today.month &&
            element.date.year == today.year)
        .toList();
  }

  @override
  Future<List<Expense>> getYTDExpenses() async {
    return box.values
        .cast<Expense>()
        .where((element) => element.date.year == DateTime.now().year)
        .toList();
  }

  Future<List<Expense>> getExpensesAfter(DateTime dateAfter) async {
    return box.values
        .cast<Expense>()
        .where((element) => element.date.isAfter(dateAfter))
        .toList();
  }
}
