import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/add_income.dart';
import 'package:pocket_pal/widgets/full_account_view.dart';
import 'package:pocket_pal/widgets/income_list.dart';

class AccountCard extends StatefulWidget {
  final Account account;

  const AccountCard({super.key, required this.account});

  @override
  State<StatefulWidget> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return IncomeList(
              account: widget.account,
            );
          },
        );
      },
      child: Card(
        elevation: 3,
        color: Color(widget.account.colorCode),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 8,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset("assets/Lines.png").image,
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 35.0),
                    child: Text(
                      widget.account.name,
                      style: const TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0, top: 10.0),
                        child: PopupMenuTheme(
                          data: const PopupMenuThemeData(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            shadowColor: Colors.white,
                          ),
                          child: PopupMenuButton<String>(
                            onSelected: (String value) {
                              switch (value) {
                                case 'Delete':
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Delete account"),
                                        content: Text(
                                            "Are you sure you want to delete \"${widget.account.name}\" account?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await ManagerService()
                                                  .service
                                                  .getAccountService()
                                                  .deleteAccount(
                                                      widget.account);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  break;
                                case 'Edit':
                                  showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: FullAccountView(
                                          account: widget.account,
                                        ),
                                      );
                                    },
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return ['Delete', 'Edit'].map((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Center(
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            child: const Icon(
                              Icons.more_horiz_rounded,
                              color: Colors.white,
                              size: 33.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0, top: 10.0),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: AddIncome(
                                    account: widget.account,
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
