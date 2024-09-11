import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/util/time_period.dart';

import '../service/manager_service.dart';

class TotalExpenseCard extends StatefulWidget {
  String periodFilter = "This month";
  String categoryFilter = "All categories";

  TotalExpenseCard({
    super.key,
    required this.periodFilter,
    required this.categoryFilter,
  });

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
            future: getTotalExpenses(
              widget.periodFilter,
              widget.categoryFilter,
            ),
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

  Future<double> getTotalExpenses(
      String periodFilter, String categoryFilter) async {
    if (categoryFilter == "All categories") {
      switch (periodFilter) {
        case "This month":
          return await ManagerService()
              .service
              .getExpenseService()
              .getTotalExpense(period: TimePeriod.thisMonth, sub: this);
        case "Today":
          return await ManagerService()
              .service
              .getExpenseService()
              .getTotalExpense(period: TimePeriod.today, sub: this);
        case "This week":
          return await ManagerService()
              .service
              .getExpenseService()
              .getTotalExpense(period: TimePeriod.thisWeek, sub: this);
        case "This year":
          return await ManagerService()
              .service
              .getExpenseService()
              .getTotalExpense(period: TimePeriod.lastYear, sub: this);
        case "All":
          return await ManagerService()
              .service
              .getExpenseService()
              .getTotalExpense(period: TimePeriod.all, sub: this);
      }
    } else {
      Category category = await ManagerService()
          .service
          .getCategoryService()
          .getCategoryByName(categoryFilter);

      switch (periodFilter) {
        case "This month":
          return await ManagerService()
              .service
              .getExpenseService()
              .totalExpensesByPeriodAndCategory(
                  TimePeriod.thisMonth, category, this, null, null);
        case "Today":
          return await ManagerService()
              .service
              .getExpenseService()
              .totalExpensesByPeriodAndCategory(
                  TimePeriod.today, category, this, null, null);
        case "This week":
          return await ManagerService()
              .service
              .getExpenseService()
              .totalExpensesByPeriodAndCategory(
                  TimePeriod.thisWeek, category, this, null, null);
        case "This year":
          return await ManagerService()
              .service
              .getExpenseService()
              .totalExpensesByPeriodAndCategory(
                  TimePeriod.ytd, category, this, null, null);
        case "All":
          return await ManagerService()
              .service
              .getExpenseService()
              .totalExpensesByPeriodAndCategory(
                  TimePeriod.all, category, this, null, null);
      }
    }

    return ManagerService()
        .service
        .getExpenseService()
        .getTotalExpense(period: TimePeriod.thisMonth, sub: this);
  }

  @override
  void update() {
    setState(() {});
  }
}
