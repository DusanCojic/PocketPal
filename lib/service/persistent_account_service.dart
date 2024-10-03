import 'package:hive/hive.dart';
import 'package:pocket_pal/extension/persistent_account_service_total_extension.dart';
import 'package:pocket_pal/interface/account_service.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/model/income.dart';
import 'package:pocket_pal/model/observable.dart';

class PersistentAccountService implements AccountService {
  final Box box;
  Observable accountChangeNotifier = Observable();

  PersistentAccountService({required this.box});

  @override
  Future<void> deleteAccount(Account account) async {
    await box.delete(account.key);
    accountChangeNotifier.notifySubscribers();
  }

  @override
  Future<void> saveAccount(Account account) async {
    await box.add(account);
    await box.flush();
    accountChangeNotifier.notifySubscribers();
  }

  @override
  Future<void> updateAccount(Account account) async {
    await box.put(account.key, account);
    await box.flush();
    accountChangeNotifier.notifySubscribers();
  }

  @override
  Future<List<Account>> getAccounts(Subscriber? sub) async {
    if (sub != null) accountChangeNotifier.subscribe(sub);
    return box.values.cast<Account>().toList();
  }

  @override
  void subscribe(Subscriber sub) {
    accountChangeNotifier.subscribe(sub);
  }

  @override
  void unsubscribe(Subscriber sub) {
    accountChangeNotifier.unsubscribe(sub);
  }

  @override
  Future<void> addIncome(Account account, Income income) async {
    account.addIncome(income);
    await box.put(account.key, account);
    accountChangeNotifier.notifySubscribers();
  }

  @override
  Future<void> removeIncome(Account account, Income income) async {
    account.removeIncome(income);
    await box.put(account.key, account);
    accountChangeNotifier.notifySubscribers();
  }

  @override
  Future<List<double>> getMonthlyIncomeForAccount(
      Account account, int year) async {
    List<double> result = [];

    for (int i = 1; i <= 12; i++) {
      DateTime from = DateTime(year, i, 1).subtract(const Duration(days: 1));
      DateTime to =
          (i == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, i + 1, 1);

      result.add(
        await getTotalCustomPeriodIncomeForAccount(account, from, to),
      );
    }

    return result;
  }

  @override
  Future<double> monthlyAverageForAccount(Account account, int year) async {
    double sum = 0;
    int numberOfMonths = 0;

    for (int i = 1; i <= 12; i++) {
      DateTime from = DateTime(year, i, 1).subtract(const Duration(days: 1));
      DateTime to =
          (i == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, i + 1, 1);

      double ithMonth =
          await getTotalCustomPeriodIncomeForAccount(account, from, to);
      if (ithMonth > 0) {
        sum += ithMonth;
        numberOfMonths++;
      }
    }

    if (numberOfMonths == 0) {
      return 0.0;
    }

    return sum / numberOfMonths;
  }

  @override
  Future<int> monthWithTheHighestIncome(Account account, int year) async {
    int month = 1;
    double max = 0;

    for (int i = 1; i <= 12; i++) {
      DateTime from = DateTime(year, i, 1).subtract(const Duration(days: 1));
      DateTime to =
          (i == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, i + 1, 1);

      double ithMonth =
          await getTotalCustomPeriodIncomeForAccount(account, from, to);
      if (ithMonth > max) {
        max = ithMonth;
        month = i;
      }
    }

    return month;
  }
}
