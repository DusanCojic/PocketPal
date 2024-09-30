import 'package:pocket_pal/extension/income_list_extension.dart';
import 'package:pocket_pal/extension/persistent_account_service_filter_extension.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/service/persistent_account_service.dart';

extension PersistentAccountTotalExtension on PersistentAccountService {
  Future<double> getTotalCustomPeriodIncomeForAccount(
      Account account, DateTime? from, DateTime? to) async {
    return (await getCustomPeriodIncomeForAccount(account, from, to)).sum();
  }
}
