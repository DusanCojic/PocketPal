import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pocket_pal/extension/persistent_expense_service_filter_extension.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/persistent_expense_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'fake_path_provider_platform.dart';
import 'persistent_expense_service_filter_test.dart';

void main() {
  group(
    "Persistent Expense filter service tests",
    persistentExpenseFilterServiceTests,
  );
}

void persistentExpenseFilterServiceTests() {
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

  test(
    "Get todays expenses",
    () async => todaysExpenses(service),
  );

  test(
    "Get this week expenses",
    () async => lastWeeksExpenses(service),
  );

  test(
    "Get this month expenses",
    () async => lastMonthsExpenses(service),
  );

  test(
    "Get ytd expenses",
    () async => ytdExpenses(service),
  );

  test(
    "Get last year expenses",
    () async => lastYearExpenses(service),
  );

  test("Get total for custom period",
      () async => getExpensesForCustomPeriod(service));

  test(
    "Filter expenses based on category",
    () async => filterExpensesBasedOnCategory(service),
  );

  test(
    "Filter expenses based on categories",
    () async => filterExpensesBasedOnCategories(service),
  );
}

void todaysExpenses(PersistentExpenseService service) async {
  List<Expense> todaysExpensesList = await service.getExpensesForExactDate(
    DateTime(2024, 2, 16),
  );

  expect(todaysExpensesList.length, 3);
  expect(todaysExpensesList[0].name, "1");
  expect(todaysExpensesList[1].name, "2");
  expect(todaysExpensesList[2].name, "3");
}

void lastWeeksExpenses(PersistentExpenseService service) async {
  List<Expense> lastWeekExpensesList = await service.getExpensesAfter(
    DateTime(2024, 2, 16).subtract(const Duration(days: 7)),
  );

  expect(lastWeekExpensesList.length, 6);
  expect(lastWeekExpensesList[3].name, "4");
  expect(lastWeekExpensesList[4].name, "5");
  expect(lastWeekExpensesList[5].name, "6");
}

void lastMonthsExpenses(PersistentExpenseService service) async {
  List<Expense> thisMonthExpensesList = await service.getExpensesAfter(
    DateTime(2024, 2, 16).subtract(const Duration(days: 30)),
  );

  expect(thisMonthExpensesList.length, 9);
  expect(thisMonthExpensesList[6].name, "7");
  expect(thisMonthExpensesList[7].name, "8");
  expect(thisMonthExpensesList[8].name, "9");
}

void ytdExpenses(PersistentExpenseService service) async {
  List<Expense> lastWeekExpensesList = await service.getExpensesForYear(2024);

  expect(lastWeekExpensesList.length, 12);
  expect(lastWeekExpensesList[9].name, "10");
  expect(lastWeekExpensesList[10].name, "11");
  expect(lastWeekExpensesList[11].name, "12");
}

void lastYearExpenses(PersistentExpenseService service) async {
  List<Expense> lastWeekExpensesList = await service.getExpensesAfter(
    DateTime(2024, 2, 16).subtract(const Duration(days: 365)),
  );

  expect(lastWeekExpensesList.length, 15);
  expect(lastWeekExpensesList[12].name, "13");
  expect(lastWeekExpensesList[13].name, "14");
  expect(lastWeekExpensesList[14].name, "15");
}

void getExpensesForCustomPeriod(PersistentExpenseService service) async {
  List<Expense> lastWeekExpensesList = await service.getCustomPeriodExpenses(
    DateTime(2024, 2, 14),
    DateTime(2024, 2, 17),
  );

  expect(lastWeekExpensesList.length, 6);
  expect(lastWeekExpensesList[0].name, "1");
  expect(lastWeekExpensesList[1].name, "2");
  expect(lastWeekExpensesList[2].name, "3");
  expect(lastWeekExpensesList[3].name, "4");
  expect(lastWeekExpensesList[4].name, "5");
  expect(lastWeekExpensesList[5].name, "6");
}

void filterExpensesBasedOnCategory(PersistentExpenseService service) async {
  Category category = Category(name: "2", icon: "i", colorValue: 0);
  List<Expense> lastWeekExpensesList = await service.filterByCategory(category);

  expect(lastWeekExpensesList.length, 1);
  expect(lastWeekExpensesList[0].name, "14");
}

void filterExpensesBasedOnCategories(PersistentExpenseService service) async {
  Category category = Category(name: "2", icon: "i", colorValue: 0);
  Category category2 = Category(name: "3", icon: "i", colorValue: 0);

  List<Expense> lastWeekExpensesList = await service.filterByCategories(
    [
      category,
      category2,
    ],
  );

  expect(lastWeekExpensesList.length, 2);
  expect(lastWeekExpensesList[0].name, "10");
  expect(lastWeekExpensesList[1].name, "14");
}
