import 'package:flutter/foundation.dart' as foundation;
import 'package:hive/hive.dart';
import 'package:pocket_pal/extension/expense_list_extension.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/model/observable.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/util/time_period.dart';

import '../interface/expense_service.dart';
import '../extension/persistent_expense_service_filter_extension.dart';
import '../extension/persistent_expense_service_total_extension.dart';

class PersistentExpenseService implements ExpenseService {
  final Box box;
  final Observable expensesChangeNotifier = Observable();

  PersistentExpenseService({required this.box});

  @override
  Future<void> replaceCategory(
      Category categoryToReplace, Category category) async {
    List<Expense> expenses = await getAllExpenses(null);
    for (Expense expense in expenses) {
      if (expense.category == categoryToReplace) {
        expense.setCategory(category);
        expense.categoryId = category.key;
        await updateExpense(expense);
      }
    }
  }

  @override
  Future<void> deleteExpense(Expense expense) async {
    await box.delete(expense.key);
    expensesChangeNotifier.notifySubscribers();
  }

  @override
  Future<List<Expense>> getAllExpenses(Subscriber? sub) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);
    var expenses = box.values.cast<Expense>();
    if (foundation.kDebugMode) {
      expenses.forEach((element) async {
        element.category = await ManagerService()
            .service
            .getCategoryService()
            .getCategoryById(element.categoryId);
      });
    }
    return expenses.toList();
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
    expensesChangeNotifier.notifySubscribers();
  }

  Future<void> dispose() async => await box.close();

  @override
  Future<List<Expense>> filterByCategories(
      List<Category> category, Subscriber? sub) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);
    return box.values
        .cast<Expense>()
        .where((element) => category.any((cat) => element.category == cat))
        .toList();
  }

  @override
  Future<List<Expense>> filterByCategory(
      Category category, Subscriber? sub) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);
    return box.values
        .cast<Expense>()
        .where((element) => element.category == category)
        .toList();
  }

  List<Expense> filterExpenseListByCategory(
      List<Expense> expenses, Category category) {
    return expenses.where((e) => e.categoryId == category.key).toList();
  }

  @override
  Future<List<Expense>> filterByPeriodAndCategory(TimePeriod period,
      Category category, Subscriber? sub, DateTime? from, DateTime? to) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);

    switch (period) {
      case TimePeriod.today:
        return filterExpenseListByCategory(await getTodayExpenses(), category);
      case TimePeriod.thisWeek:
        return filterExpenseListByCategory(
            await getThisWeekExpenses(), category);
      case TimePeriod.thisMonth:
        return filterExpenseListByCategory(
            await getThisMonthExpenses(), category);
      case TimePeriod.ytd:
        return filterExpenseListByCategory(await getYTDExpenses(), category);
      case TimePeriod.lastYear:
        return filterExpenseListByCategory(
            await getLastYearExpenses(), category);
      case TimePeriod.all:
        return filterExpenseListByCategory(await getExpenses(), category);
      case TimePeriod.custom:
        return filterExpenseListByCategory(
            await getCustomPeriodExpenses(from, to), category);
    }
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
      case TimePeriod.all:
        return await getTotalAllExpenses();
      case TimePeriod.custom:
        return await getTotalCustomPeriodExpense(from, to);
    }
  }

  @override
  Future<List<Expense>> getExpenses({
    Subscriber? sub,
    TimePeriod period = TimePeriod.today,
    DateTime? from,
    DateTime? to,
  }) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);

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
      case TimePeriod.all:
        return await getAllExpensesList();
      case TimePeriod.custom:
        return await getCustomPeriodExpenses(from, to);
    }
  }

  @override
  Future<double> totalExpensesByCategories(
      List<Category> category, Subscriber? sub) async {
    return (await filterByCategories(category, sub)).sum();
  }

  @override
  Future<double> totalExpensesByCategory(
      Category category, Subscriber? sub) async {
    return (await filterByCategory(category, sub)).sum();
  }

  @override
  Future<double> totalExpensesByPeriodAndCategory(TimePeriod period,
      Category category, Subscriber? sub, DateTime? from, DateTime? to) async {
    if (sub != null) expensesChangeNotifier.subscribe(sub);

    switch (period) {
      case TimePeriod.today:
        return filterExpenseListByCategory(await getTodayExpenses(), category)
            .sum();
      case TimePeriod.thisWeek:
        return filterExpenseListByCategory(
                await getThisWeekExpenses(), category)
            .sum();
      case TimePeriod.thisMonth:
        return filterExpenseListByCategory(
                await getThisMonthExpenses(), category)
            .sum();
      case TimePeriod.ytd:
        return filterExpenseListByCategory(await getYTDExpenses(), category)
            .sum();
      case TimePeriod.lastYear:
        return filterExpenseListByCategory(
                await getLastYearExpenses(), category)
            .sum();
      case TimePeriod.all:
        return filterExpenseListByCategory(await getAllExpensesList(), category)
            .sum();
      case TimePeriod.custom:
        return filterExpenseListByCategory(
                await getCustomPeriodExpenses(from, to), category)
            .sum();
    }
  }

  @override
  void subscribe(Subscriber sub) {
    expensesChangeNotifier.subscribe(sub);
  }

  @override
  void unsubscribe(Subscriber sub) {
    expensesChangeNotifier.unsubscribe(sub);
  }
}
