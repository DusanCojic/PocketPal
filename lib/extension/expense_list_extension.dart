import 'package:pocket_pal/model/expense.dart';

extension ExpenseListExtension on Iterable<Expense> {
  Iterable<Expense> filterAfterDate(DateTime date) {
    return where((element) => element.date.isAfter(date));
  }

  Iterable<Expense> filterBetweenDates(DateTime from, DateTime to) {
    return where(
      (element) => element.date.isAfter(from) && element.date.isBefore(to),
    );
  }

  Iterable<Expense> filterGivenYear(int year) {
    return where((element) => element.date.year == year);
  }

  Iterable<Expense> filterForGivenDate(DateTime date) {
    return where((element) =>
        element.date.day == date.day &&
        element.date.month == date.month &&
        element.date.year == date.year);
  }

  double sum() {
    double amount = 0;
    forEach((element) => amount += element.amount);
    return amount;
  }
}
