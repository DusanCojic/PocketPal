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
    // TODO: implement filterByCategories
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> filterByCategory(Category category) async {
    // TODO: implement filterByCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getThisMonthExpenses() async {
    // TODO: implement getLastMonthExpenses
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getThisWeekExpenses() async {
    // TODO: implement getLastWeekExpenses
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getLastYearExpenses() async {
    // TODO: implement getLastYearExpenses
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getTodayExpenses() async {
    // TODO: implement getTodayExpenses
    throw UnimplementedError();
  }

  @override
  Future<List<Expense>> getYTDExpenses() async {
    // TODO: implement getYTDExpenses
    throw UnimplementedError();
  }
}
