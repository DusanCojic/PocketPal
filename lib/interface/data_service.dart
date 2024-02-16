import 'expense_service.dart';

abstract class DataService {
  ExpenseService getExpenseService();

  Future<void> initialize();
}
