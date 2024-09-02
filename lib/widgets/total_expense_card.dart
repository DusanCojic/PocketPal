import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/util/time_period.dart';

import '../service/manager_service.dart';

class TotalExpenseCard extends StatefulWidget {
  const TotalExpenseCard({super.key});

  @override
  State<TotalExpenseCard> createState() => _TotalExpenseCardState();
}

class _TotalExpenseCardState extends State<TotalExpenseCard>
    implements Subscriber {
  @override
  void dispose() {
    ManagerService().service.getExpenseService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 15.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          height: 130,
          width: 500,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("../../assets/sun-tornado.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: FutureBuilder<double>(
            future: getTotalExpenses(),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              String totalExpense = snapshot.hasData && snapshot.data != null
                  ? '\$${snapshot.data!.toStringAsFixed(2)}'
                  : '\$0.00';
              return Padding(
                padding: const EdgeInsets.only(top: 35.0, left: 30.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                    children: [
                      const TextSpan(
                        text: "Total Expense\n",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: totalExpense,
                        style: const TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<double> getTotalExpenses() async {
    return await ManagerService()
        .service
        .getExpenseService()
        .getTotalExpense(sub: this, period: TimePeriod.thisMonth);
  }

  @override
  void update() {
    setState(() {});
  }
}
