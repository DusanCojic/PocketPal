import 'package:hive/hive.dart';

import '../interface/data_service.dart';
import '../interface/expense_service.dart';
import 'persistent_expense_service.dart';

class PersistentDataService implements DataService {
  late final ExpenseService _expenseService;

  PersistentDataService() {
    Hive.openBox("expenses").then(
      (value) => _expenseService = PersistentExpenseService(
        box: value,
      ),
    );
  }

  @override
  ExpenseService getExpenseService() => _expenseService;
}
