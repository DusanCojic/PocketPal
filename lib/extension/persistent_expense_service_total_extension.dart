import 'expense_list_extension.dart';
import 'persistent_expense_service_filter_extension.dart';

import '../service/persistent_expense_service.dart';

extension PersistentExpenseTotalExtension on PersistentExpenseService {
  Future<double> getTotalTodaysExpense() async {
    return (await getTodayExpenses()).sum();
  }

  Future<double> getTotalWeeksExpense() async {
    return (await getThisWeekExpenses()).sum();
  }

  Future<double> getTotalMonthsExpense() async {
    return (await getThisMonthExpenses()).sum();
  }

  Future<double> getTotalYtdExpense() async {
    return (await getYTDExpenses()).sum();
  }

  Future<double> getTotalYearExpense() async {
    return (await getLastYearExpenses()).sum();
  }

  Future<double> getTotalExpensesAfter(DateTime dateAfter) async {
    return (await getExpensesAfter(dateAfter)).sum();
  }

  Future<double> getTotalExpensesForYear(int year) async {
    return (await getExpensesForYear(year)).sum();
  }

  Future<double> getTotalExpensesForExactDate(DateTime date) async {
    return (await getExpensesForExactDate(date)).sum();
  }

  Future<double> getTotalCustomPeriodExpense(
    DateTime? from,
    DateTime? to,
  ) async {
    return (await getCustomPeriodExpenses(from, to)).sum();
  }
}
