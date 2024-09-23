import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_pal/interface/account_service.dart';
import 'package:pocket_pal/interface/category_service.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/model/income.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/service/persistent_account_service.dart';
import 'package:pocket_pal/service/persistent_category_service.dart';
import '../model/category.dart';

import '../interface/data_service.dart';
import '../interface/expense_service.dart';
import 'persistent_expense_service.dart';

class PersistentDataService implements DataService {
  late final ExpenseService _expenseService;
  late final CategoryService _categoryService;
  late final AccountService _accountService;

  @override
  ExpenseService getExpenseService() => _expenseService;

  @override
  CategoryService getCategoryService() => _categoryService;

  @override
  AccountService getAccountService() => _accountService;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(IncomeAdapter());

    _expenseService = PersistentExpenseService(
      box: await Hive.openBox("expenses"),
    );

    _categoryService = PersistentCategoryService(
      box: await Hive.openBox("categories"),
    );

    _accountService = PersistentAccountService(
      box: await Hive.openBox("accounts"),
    );
  }
}
