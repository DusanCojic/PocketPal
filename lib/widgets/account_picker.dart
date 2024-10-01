import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/service/manager_service.dart';

class AccountPicker extends StatefulWidget {
  final Function(Account) onSelected;

  const AccountPicker({
    super.key,
    required this.onSelected,
  });

  @override
  State<StatefulWidget> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> implements Subscriber {
  List<Account> accounts = [];
  late Account account;

  @override
  void initState() {
    super.initState();
    loadAccounts();
    ManagerService().service.getAccountService().subscribe(this);
  }

  @override
  void dispose() {
    ManagerService().service.getAccountService().unsubscribe(this);
    super.dispose();
  }

  Future<void> loadAccounts() async {
    accounts =
        await ManagerService().service.getAccountService().getAccounts(null);
    if (accounts.isNotEmpty) {
      setState(() {
        account = accounts.first;
      });
    } else {
      account = Account(
        name: "No accounts",
        colorCode: Colors.grey.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 35,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: Text(
              "Pick an account",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: accounts.isEmpty
                ? Container()
                : ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          accounts[index].name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          setState(() {
                            account = accounts[index];
                          });

                          widget.onSelected(account);

                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void update() {
    loadAccounts();
  }
}
