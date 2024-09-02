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

  Future<double> totalExpensesByCategory(Category category);
  Future<double> totalExpensesByCategories(List<Category> category);

  Future<List<Expense>> getExpenses({
    TimePeriod period = TimePeriod.today,
    DateTime? from,
    DateTime? to,
  });

  Future<List<Expense>> filterByCategory(Category category);
  Future<List<Expense>> filterByCategories(List<Category> category);

  void subscribe(Subscriber sub);
  void unsubscribe(Subscriber sub);
}
