import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pocket_pal/extension/persistent_expense_service_total_extension.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/persistent_expense_service.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'fake_path_provider_platform.dart';

void main() {
  group(
    "Persistent Expense total service tests",
    persistentExpenseTotalServiceTests,
  );
}

void persistentExpenseTotalServiceTests() {
  late PersistentExpenseService service;
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    await Hive.initFlutter();

    Hive.registerAdapter<Category>(CategoryAdapter());
    Hive.registerAdapter<Expense>(ExpenseAdapter());

    final box = await Hive.openBox<Expense>(
      "testExpenseBox",
    );

    final file = await File(
      "test/testing_data/persistent_expense_filter_test_mock_expenses.json",
    ).readAsString();

    await box.clear();
    await box.flush();

    for (var element in (json.decode(file) as List<dynamic>)) {
      await box.add(Expense.fromJson(element));
    }

    service = PersistentExpenseService(box: box);
  });

  tearDownAll(() async {
    await service.box.clear();
    await service.box.flush();
    await service.dispose();

    await Hive.close();
  });

  // test(
  //   "Get todays total expenses",
  //   () async => todaysTotalExpenses(service),
  // );

  test(
    "Get this week total expenses",
    () async => lastWeeksTotalExpenses(service),
  );

  test(
    "Get this month total expenses",
    () async => lastMonthsTotalExpenses(service),
  );

  test(
    "Get ytd total expenses",
    () async => ytdTotalExpenses(service),
  );

  test(
    "Get last year total expenses",
    () async => lastYearTotalExpenses(service),
  );

  test(
    "Get total expenses for custom period",
    () async => getTotalForCustomPeriod(service),
  );

  test(
    "Total expenses based on category",
    () async => totalExpensesBasedOnCategory(service),
  );

  test(
    "Total expenses based on categories",
    () async => totalExpensesBasedOnCategories(service),
  );
}

void todaysTotalExpenses(PersistentExpenseService service) async {
  double todaysExpensesList = await service.getTotalExpensesForExactDate(
    DateTime(2024, 2, 16),
  );

  expect(todaysExpensesList, 6);
}

void lastWeeksTotalExpenses(PersistentExpenseService service) async {
  double todaysExpensesList = await service.getTotalExpensesAfter(
    DateTime(2024, 2, 16).subtract(const Duration(days: 7)),
  );

  expect(todaysExpensesList, 21);
}

void lastMonthsTotalExpenses(PersistentExpenseService service) async {
  double todaysExpensesList = await service.getTotalExpensesAfter(
    DateTime(2024, 2, 16).subtract(const Duration(days: 30)),
  );

  expect(todaysExpensesList, 45);
}

void ytdTotalExpenses(PersistentExpenseService service) async {
  double todaysExpensesList = await service.getTotalExpensesForYear(2024);

  expect(todaysExpensesList, 78);
}

void lastYearTotalExpenses(PersistentExpenseService service) async {
  double todaysExpensesList = await service.getTotalExpensesAfter(
    DateTime(2024, 2, 16).subtract(const Duration(days: 365)),
  );

  expect(todaysExpensesList, 120);
}

void getTotalForCustomPeriod(PersistentExpenseService service) async {
  double totalCustom = await service.getTotalCustomPeriodExpense(
    DateTime(2024, 2, 14),
    DateTime(2024, 2, 17),
  );

  expect(totalCustom, 21);
}

void totalExpensesBasedOnCategory(PersistentExpenseService service) async {
  Category category =
      Category(name: "2", iconCode: Icons.home.codePoint, colorValue: 0);
  double totalExpense = await service.totalExpensesByCategory(category, null);

  expect(totalExpense, 14);
}

void totalExpensesBasedOnCategories(PersistentExpenseService service) async {
  Category category =
      Category(name: "2", iconCode: Icons.home.codePoint, colorValue: 0);
  Category category2 =
      Category(name: "3", iconCode: Icons.home.codePoint, colorValue: 0);

  double totalExpense = await service.totalExpensesByCategories(
    [
      category,
      category2,
    ],
    null,
  );

  expect(totalExpense, 24);
}
