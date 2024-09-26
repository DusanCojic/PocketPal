import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';

import '../model/expense.dart';
import '../util/time_period.dart';

abstract class ExpenseService {
  Future<List<Expense>> getAllExpenses(Subscriber? sub);
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(Expense expense);
  Future<void> updateExpense(Expense expense);

  Future<double> getTotalExpense({
    Subscriber? sub,
    TimePeriod period = TimePeriod.today,
    DateTime? from,
    DateTime? to,
  });

  Future<void> replaceCategory(Category categoryToReplace, Category cateogry);

  Future<double> totalExpensesByCategory(Category category, Subscriber? sub);
  Future<double> totalExpensesByCategories(
      List<Category> category, Subscriber? sub);
  Future<double> totalExpensesByPeriodAndCategory(TimePeriod period,
      Category category, Subscriber? sub, DateTime? from, DateTime? to);

  Future<List<Expense>> getExpenses({
    TimePeriod period = TimePeriod.today,
    Subscriber? sub,
    DateTime? from,
    DateTime? to,
  });

  Future<List<Expense>> filterByCategory(Category category, Subscriber? sub);
  Future<List<Expense>> filterByCategories(
      List<Category> category, Subscriber? sub);
  Future<List<Expense>> filterByPeriodAndCategory(TimePeriod period,
      Category category, Subscriber? sub, DateTime? from, DateTime? to);

  Future<Map<Category, double>> totalExpensesForEveryCategory(
      TimePeriod period, Subscriber? sub);
  Future<List<double>> totalMonthlyExpenses(int year, Subscriber? sub);

  void subscribe(Subscriber sub);
  void unsubscribe(Subscriber sub);
}
