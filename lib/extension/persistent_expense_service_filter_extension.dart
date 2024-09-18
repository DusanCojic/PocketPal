import '../model/expense.dart';
import '../service/persistent_expense_service.dart';
import '../extension/expense_list_extension.dart';

extension PersistentExpenseFilterExtension on PersistentExpenseService {
  DateTime currentDate() => DateTime.now();

  Future<List<Expense>> getThisMonthExpenses() async {
    DateTime now = currentDate();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfPreviousMonth =
        startOfMonth.subtract(const Duration(days: 1));
    DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

    return getCustomPeriodExpenses(lastDayOfPreviousMonth, startOfNextMonth);
  }

  Future<List<Expense>> getThisWeekExpenses() async {
    DateTime now = currentDate();

    int daysToSubtract = now.weekday - DateTime.monday;
    DateTime startOfWeek = now.subtract(Duration(days: daysToSubtract + 1));

    DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

    return getCustomPeriodExpenses(startOfWeek, endOfWeek);
  }

  Future<List<Expense>> getLastYearExpenses() async {
    DateTime yearAgo = currentDate().subtract(const Duration(days: 365));
    return getExpensesAfter(yearAgo);
  }

  Future<List<Expense>> getTodayExpenses() async {
    return getExpensesForExactDate(currentDate());
  }

  Future<List<Expense>> getYTDExpenses() async {
    return getExpensesForYear(currentDate().year);
  }

  Future<List<Expense>> getAllExpensesList() async {
    return box.values.cast<Expense>().toList();
  }

  Future<List<Expense>> getExpensesAfter(DateTime dateAfter) async {
    return box.values.cast<Expense>().filterAfterDate(dateAfter).toList();
  }

  Future<List<Expense>> getExpensesForYear(int year) async {
    return box.values.cast<Expense>().filterGivenYear(year).toList();
  }

  Future<List<Expense>> getExpensesForExactDate(DateTime date) async {
    return box.values.cast<Expense>().filterForGivenDate(date).toList();
  }

  Future<List<Expense>> getCustomPeriodExpenses(
      DateTime? from, DateTime? to) async {
    if (from == null || to == null) {
      throw "From and To must be non-null values";
    }

    return box.values.cast<Expense>().filterBetweenDates(from, to).toList();
  }
}
