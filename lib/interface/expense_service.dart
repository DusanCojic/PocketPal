import '../model/expense.dart';

abstract class ExpenseService {
  Future<List<Expense>> getAllExpenses();
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
}
