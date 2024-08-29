import 'package:hive/hive.dart';
import 'package:pocket_pal/extension/expense_list_extension.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/model/observable.dart';
import 'package:pocket_pal/util/time_period.dart';

import '../interface/expense_service.dart';
import '../extension/persistent_expense_service_filter_extension.dart';
import '../extension/persistent_expense_service_total_extension.dart';

class PersistentExpenseService implements ExpenseService {
  final Box box;
  final Observable expensesChangeNotifier = Observable();

  PersistentExpenseService({required this.box});

  @override
  Future<void> deleteExpense(Expense expense) async {
    await box.delete(expense.key);
  }

  @override
  Future<List<Expense>> getAllExpenses(Subscriber? sub) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);
    return box.values.cast<Expense>().toList();
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    await box.add(expense);
    await box.flush();
    expensesChangeNotifier.notifySubscribers();
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await box.put(expense.key, expense);
    await box.flush();
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
  Future<double> getTotalExpense({
    Subscriber? sub,
    TimePeriod period = TimePeriod.today,
    DateTime? from,
    DateTime? to,
  }) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);
    switch (period) {
      case TimePeriod.today:
        return await getTotalTodaysExpense();
      case TimePeriod.thisWeek:
        return await getTotalWeeksExpense();
      case TimePeriod.thisMonth:
        return await getTotalMonthsExpense();
      case TimePeriod.ytd:
        return await getTotalYtdExpense();
      case TimePeriod.lastYear:
        return await getTotalYearExpense();
      case TimePeriod.custom:
        return await getTotalCustomPeriodExpense(from, to);
    }
  }

  @override
  Future<List<Expense>> getExpenses({
    TimePeriod period = TimePeriod.today,
    DateTime? from,
    DateTime? to,
  }) async {
    switch (period) {
      case TimePeriod.today:
        return await getTodayExpenses();
      case TimePeriod.thisWeek:
        return await getThisWeekExpenses();
      case TimePeriod.thisMonth:
        return await getThisMonthExpenses();
      case TimePeriod.ytd:
        return await getYTDExpenses();
      case TimePeriod.lastYear:
        return await getLastYearExpenses();
      case TimePeriod.custom:
        return await getCustomPeriodExpenses(from, to);
    }
  }

  @override
  Future<double> totalExpensesByCategories(List<Category> category) async {
    return (await filterByCategories(category)).sum();
  }

  @override
  Future<double> totalExpensesByCategory(Category category) async {
    return (await filterByCategory(category)).sum();
  }

  @override
  void unsubscribe(Subscriber sub) {
    expensesChangeNotifier.unsubscribe(sub);
  }
}
