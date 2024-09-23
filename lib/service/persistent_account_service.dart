import 'package:hive/hive.dart';
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
}
