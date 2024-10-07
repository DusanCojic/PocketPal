import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/account_picker.dart';
import 'package:pocket_pal/widgets/information_card.dart';
import 'package:pocket_pal/widgets/monthly_bar_chart.dart';

class MonthlyIncomeChart extends StatefulWidget {
  const MonthlyIncomeChart({super.key});

  @override
  State<StatefulWidget> createState() => _MonthlyIncomeChartState();
}

class _MonthlyIncomeChartState extends State<MonthlyIncomeChart>
    implements Subscriber {
  Account? account;
  late int year;
  double average = 0;
  int month = 1;

  @override
  void initState() {
    year = DateTime.now().year;
    initAccount();
    ManagerService().service.getAccountService().subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    ManagerService().service.getAccountService().unsubscribe(this);
    super.dispose();
  }

  void initAccount() async {
    List<Account> accounts =
        await ManagerService().service.getAccountService().getAccounts(null);
    setState(() {
      if (accounts.isNotEmpty) {
        account = accounts.first;
        initAverage();
        initMonth();
      } else {
        account = Account(
          name: "No accounts",
          colorCode: Colors.grey.value,
        );
      }
    });
  }

  Future<void> initAverage() async {
    if (account != null) {
      double result = await ManagerService()
          .service
          .getAccountService()
          .monthlyAverageForAccount(account!, year);
      setState(() {
        average = result;
      });
    }
  }

  Future<void> initMonth() async {
    if (account != null) {
      int result = await ManagerService()
          .service
          .getAccountService()
          .monthWithTheHighestIncome(account!, year);

      setState(() {
        month = result;
      });
    }
  }

  void handleSelectedAccount(Account newAccount) {
    setState(() {
      account = newAccount;
    });
    initAverage();
    initMonth();
  }

  void handleSelectedYear(int newYear) {
    setState(() {
      year = newYear;
    });
    initAverage();
    initMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text(
                      "Monthly Income",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (account != null && account?.name != "No accounts") {
                          showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return AccountPicker(
                                onSelected: handleSelectedAccount,
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 10.0,
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 245, 245, 245),
                      ),
                      child: Text(
                        account?.name ?? "Loading...",
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: FutureBuilder<List<List<double>>>(
                  future: getData(year, null),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container();
                    }

                    return MonthlyBarChart(
                      future: getData,
                      onYearChanged: handleSelectedYear,
                      barNames: const [],
                      showLegend: false,
                      gradients: [
                        LinearGradient(
                          colors: [
                            const Color(0xff81c784).withOpacity(0.8),
                            const Color(0xff4caf50).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InformationCard(
                title: "Monthly average",
                info: "\$${average.toStringAsFixed(2)}",
                color: const Color(0xff81c784),
                width: (MediaQuery.of(context).size.width - 80) / 2,
                height: 70.0,
              ),
              InformationCard(
                title: "Highest income month",
                info: DateFormat("MMMM").format(DateTime(year, month)),
                color: const Color(0xff4caf50),
                width: (MediaQuery.of(context).size.width + 30) / 2,
                height: 70.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<List<double>>> getData(int year, Subscriber? sub) async {
    return [
      (account != null && account?.name != "No accounts")
          ? await ManagerService()
              .service
              .getAccountService()
              .getMonthlyIncomeForAccount(account!, year)
          : [],
    ];
  }

  @override
  void update() {
    initAccount();
    initAverage();
    initMonth();
  }
}
