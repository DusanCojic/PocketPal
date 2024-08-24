import 'package:pocket_pal/interface/category_service.dart';

import 'expense_service.dart';

abstract class DataService {
  ExpenseService getExpenseService();

  CategoryService getCategoryService();

  Future<void> initialize();
}
