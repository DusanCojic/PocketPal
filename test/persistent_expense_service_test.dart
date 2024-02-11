import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_pal/interface/expense_service.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/service/persistent_expense_service.dart';

class BoxMock extends Mock implements Box {}

void main() {
  group("Expense service tests", () {
    test(
      "Get All Expenses Should return nothing",
      getAllExpensesShouldReturnNothing,
    );

    test(
      "Get All expenses should return 2 expenses",
      getAllExpenses,
    );
  });
}

void getAllExpensesShouldReturnNothing() async {
  late PersistentExpenseService service;
  late Box box;

  setUp(() {
    box = BoxMock();

    when(box.values).thenAnswer((_) => []);

    service = PersistentExpenseService(box: box);
  });

  final expenses = await service.getAllExpenses();
  expect(expenses, []);
  verify(box.values).called(1);
}

void getAllExpenses() async {
  late PersistentExpenseService service;
  late Box box;
  Category category = Category(
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

  setUp(() {
    box = BoxMock();

    when(box.values).thenAnswer((_) => mockExpected);

    service = PersistentExpenseService(box: box);
  });
  final expenses = await service.getAllExpenses();

  expect(expenses.length, 2);
  expect(expenses[0].name, "1");
  verify(box.values).called(1);
}
