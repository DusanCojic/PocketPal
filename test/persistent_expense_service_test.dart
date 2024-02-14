import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/persistent_expense_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'fake_path_provider_platform.dart';

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    await Hive.initFlutter();

    Hive.registerAdapter<Category>(CategoryAdapter());
    Hive.registerAdapter<Expense>(ExpenseAdapter());

    final box = await Hive.openBox<Expense>(
      "testExpenseBox",
    );

    await box.clear();
    await box.flush();
    await box.close();
  });
  group("Expense service tests", () {
    test(
      "Get All Expenses Should return nothing",
      () async => getAllExpensesShouldReturnNothing(),
    );

    test(
      "Get All expenses should return 2 expenses",
      () async => getAllExpenses(),
    );

    test(
      "Save 1 expense to box",
      () async => saveExpense(),
    );

    test(
      "Update expenses name",
      () async => updateExpenseEntity(),
    );

    test(
      "Delete expense",
      () async => deleteExpenseEntity(),
    );
  });
}

Future<void> clearAll(PersistentExpenseService expenseService) async {
  await expenseService.box.clear();
  await expenseService.box.flush();
  expenseService.dispose();
}

void getAllExpensesShouldReturnNothing() async {
  late PersistentExpenseService service;
  try {
    service = PersistentExpenseService(
      box: await Hive.openBox<Expense>(
        "testExpenseBox",
      ),
    );

    final expenses = await service.getAllExpenses();
    expect(expenses, []);
  } finally {
    await clearAll(service);
  }
}

void getAllExpenses() async {
  late PersistentExpenseService service;
  try {
    Category category = Category.withColor(
      name: "C1",
      icon: "I1",
      color: Colors.black,
    );

    List<Expense> mockExpected = [
      Expense(
        name: "1",
        amount: 1,
        date: DateTime(2024, 2, 11),
        category: category,
      ),
      Expense(
        name: "2",
        amount: 2,
        date: DateTime(2024, 2, 12),
        category: category,
      ),
    ];

    service = PersistentExpenseService(
      box: await Hive.openBox<Expense>(
        "testExpenseBox",
      ),
    );

    await service.box.add(mockExpected[0]);
    await service.box.add(mockExpected[1]);

    final expenses = await service.getAllExpenses();

    expect(expenses.length, 2);
    expect(expenses[0].name, "1");
  } finally {
    await clearAll(service);
  }
}

void saveExpense() async {
  final service = PersistentExpenseService(
    box: await Hive.openBox<Expense>(
      "testExpenseBox",
    ),
  );
  try {
    final current = DateTime.now();
    final expense = Expense(
      name: "a",
      amount: 1,
      date: current,
      category: Category.withColor(name: "a", icon: "b", color: Colors.white),
    );

    await service.saveExpense(expense);

    final expenses = await service.getAllExpenses();

    expect(expenses.length, 1);
    expect(expenses[0].name, "a");
    expect(expenses[0].amount, 1);
    expect(expenses[0].date, current);
  } finally {
    await clearAll(service);
  }
}

void updateExpenseEntity() async {
  late PersistentExpenseService service;
  try {
    Category category = Category.withColor(
      name: "C1",
      icon: "I1",
      color: Colors.black,
    );

    List<Expense> mockExpected = [
      Expense(
        name: "1",
        amount: 1,
        date: DateTime(2024, 2, 11),
        category: category,
      ),
      Expense(
        name: "2",
        amount: 2,
        date: DateTime(2024, 2, 12),
        category: category,
      ),
    ];

    service = PersistentExpenseService(
      box: await Hive.openBox<Expense>(
        "testExpenseBox",
      ),
    );

    await service.saveExpense(mockExpected[0]);
    await service.saveExpense(mockExpected[1]);

    var expenses = await service.getAllExpenses();
    expect(expenses.length, 2);
    expect(expenses[0].name, "1");
    expect(expenses[1].name, "2");

    expenses[0].name = "1 new name";
    expenses[1].name = "2 new name";

    await service.updateExpense(expenses[0]);
    await service.updateExpense(expenses[1]);

    expenses = await service.getAllExpenses();
    expect(expenses.length, 2);
    expect(expenses[0].name, "1 new name");
    expect(expenses[1].name, "2 new name");
  } finally {
    await clearAll(service);
  }
}

void deleteExpenseEntity() async {
  late PersistentExpenseService service;
  try {
    Category category = Category.withColor(
      name: "C1",
      icon: "I1",
      color: Colors.black,
    );

    List<Expense> mockExpected = [
      Expense(
        name: "1",
        amount: 1,
        date: DateTime(2024, 2, 11),
        category: category,
      ),
      Expense(
        name: "2",
        amount: 2,
        date: DateTime(2024, 2, 12),
        category: category,
      ),
    ];

    service = PersistentExpenseService(
      box: await Hive.openBox<Expense>(
        "testExpenseBox",
      ),
    );

    await service.saveExpense(mockExpected[0]);
    await service.saveExpense(mockExpected[1]);

    var expenses = await service.getAllExpenses();
    expect(expenses.length, 2);
    expect(expenses[0].name, "1");
    expect(expenses[1].name, "2");

    await service.deleteExpense(expenses[0]);

    expenses = await service.getAllExpenses();
    expect(expenses.length, 1);
    expect(expenses[0].name, "2");
  } finally {
    await clearAll(service);
  }
}
