import 'package:pocket_pal/interface/account_service.dart';
import 'package:pocket_pal/interface/category_service.dart';

import 'expense_service.dart';

abstract class DataService {
  ExpenseService getExpenseService();

  CategoryService getCategoryService();

  AccountService getAccountService();

  Future<void> initialize();
}
