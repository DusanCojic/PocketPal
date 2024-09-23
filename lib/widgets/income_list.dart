import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/model/income.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/income_card.dart';

class IncomeList extends StatefulWidget {
  final Account account;

  const IncomeList({
    super.key,
    required this.account,
  });

  @override
  State<StatefulWidget> createState() => _IncomeListState();
}

class _IncomeListState extends State<IncomeList> implements Subscriber {
  @override
  void initState() {
    ManagerService().service.getAccountService().subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    ManagerService().service.getAccountService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.account.incomeList.isEmpty) {
      return SizedBox(
        height: 600.0,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              width: 35,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            const SizedBox(height: 250),
            const Center(
              child: Text(
                "There is no income in this account!",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final incomes = widget.account.incomeList.reversed.toList();
    incomes.sort((a, b) => b.date.compareTo(a.date));

    return SizedBox(
      height: 600.0,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 35,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: incomes.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => deleteIncome(
                            widget.account,
                            incomes[index],
                          ),
                          backgroundColor: Colors.redAccent.withOpacity(0.2),
                          foregroundColor: Colors.redAccent,
                          icon: Icons.delete,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: IncomeCard(
                      income: incomes[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteIncome(Account account, Income income) async {
    await ManagerService()
        .service
        .getAccountService()
        .removeIncome(account, income);
  }

  @override
  void update() {
    setState(() {});
  }
}
