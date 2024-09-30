import 'package:pocket_pal/model/income.dart';

extension IncomeListExtension on Iterable<Income> {
  Iterable<Income> filterAfterDate(DateTime date) {
    return where((element) => element.date.isAfter(date));
  }

  Iterable<Income> filterBetweenDates(DateTime from, DateTime to) {
    return where(
      (element) => element.date.isAfter(from) && element.date.isBefore(to),
    );
  }

  Iterable<Income> filterGivenYear(int year) {
    return where((element) => element.date.year == year);
  }

  Iterable<Income> filterForGivenDate(DateTime date) {
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
