import 'package:pocket_pal/extension/income_list_extension.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/model/income.dart';
import 'package:pocket_pal/service/persistent_account_service.dart';

extension PersistentAccountFilterExtension on PersistentAccountService {
  Future<List<Income>> getCustomPeriodIncomeForAccount(
      Account account, DateTime? from, DateTime? to) async {
    if (from == null || to == null) {
      throw "From and To must be non-null values";
    }

    List<Account> accounts = box.values.cast<Account>().toList();

    if (accounts.isEmpty || !accounts.contains(account)) {
      return [];
    }

    return accounts
        .firstWhere((element) => element == account)
        .incomeList
        .filterBetweenDates(from, to)
        .toList();
  }
}
