import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/model/income.dart';

abstract class AccountService {
  Future<List<Account>> getAccounts(Subscriber? sub);
  Future<void> saveAccount(Account account);
  Future<void> addIncome(Account account, Income income);
  Future<void> removeIncome(Account account, Income income);
  Future<void> updateAccount(Account account);
  Future<void> deleteAccount(Account account);

  Future<List<double>> getMonthlyIncomeForAccount(Account account, int year);

  void subscribe(Subscriber sub);
  void unsubscribe(Subscriber sub);
}
