import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/account_card.dart';

class AccountList extends StatefulWidget {
  const AccountList({super.key});

  @override
  State<StatefulWidget> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> implements Subscriber {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAccounts(),
      builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "There are no accounts!",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        }

        final accounts = snapshot.data!.reversed.toList();
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return AccountCard(account: accounts[index]);
            },
          ),
        );
      },
    );
  }

  Future<List<Account>> getAccounts() async {
    return await ManagerService().service.getAccountService().getAccounts(this);
  }

  @override
  void update() {
    setState(() {});
  }
}
