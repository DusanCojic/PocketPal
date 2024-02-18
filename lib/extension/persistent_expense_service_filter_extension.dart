import '../model/expense.dart';
import '../service/persistent_expense_service.dart';
import '../extension/expense_list_extension.dart';

extension PersistentExpenseFilterExtension on PersistentExpenseService {
  DateTime currentDate() => DateTime.now();

  Future<List<Expense>> getThisMonthExpenses() async {
    DateTime thirtyDaysAgo = currentDate().subtract(const Duration(days: 30));
    return getExpensesAfter(thirtyDaysAgo);
  }

  Future<List<Expense>> getThisWeekExpenses() async {
    DateTime weekAgo = currentDate().subtract(const Duration(days: 7));
    return getExpensesAfter(weekAgo);
  }

  Future<List<Expense>> getLastYearExpenses() async {
    DateTime yearAgo = currentDate().subtract(const Duration(days: 365));
    return getExpensesAfter(yearAgo);
  }

  Future<List<Expense>> getTodayExpenses() async {
    return box.values
        .cast<Expense>()
        .filterForGivenDate(currentDate())
        .toList();
  }

  Future<List<Expense>> getYTDExpenses() async {
    return box.values
        .cast<Expense>()
        .filterGivenYear(currentDate().year)
        .toList();
  }

  Future<List<Expense>> getExpensesAfter(DateTime dateAfter) async {
    return box.values.cast<Expense>().filterAfterDate(dateAfter).toList();
  }

  Future<List<Expense>> getCustomPeriodExpenses(
      DateTime? from, DateTime? to) async {
    if (from == null || to == null) {
      throw "From and To must be non-null values";
    }

    return box.values.cast<Expense>().filterBetweenDates(from, to).toList();
  }
}
