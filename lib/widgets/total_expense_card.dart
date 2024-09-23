import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/util/time_period.dart';

import '../service/manager_service.dart';

// ignore: must_be_immutable
class TotalExpenseCard extends StatefulWidget {
  TimePeriod periodFilter;
  String categoryFilter;

  TotalExpenseCard({
    super.key,
    this.periodFilter = TimePeriod.thisMonth,
    this.categoryFilter = "All categories",
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          height: 130,
          width: 360,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: FutureBuilder<double>(
            future: getTotalExpenses(
              widget.periodFilter,
              widget.categoryFilter,
            ),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              String totalExpense = snapshot.hasData && snapshot.data != null
                  ? '\$${NumberFormat('#,##0.00').format(snapshot.data!)}'
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
                          color: Colors.black38,
                        ),
                      ),
                      TextSpan(
                        text: totalExpense,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue.withOpacity(0.9),
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
      TimePeriod periodFilter, String categoryFilter) async {
    if (categoryFilter == "All categories") {
      return await ManagerService()
          .service
          .getExpenseService()
          .getTotalExpense(period: periodFilter, sub: this);
    } else {
      Category category = await ManagerService()
          .service
          .getCategoryService()
          .getCategoryByName(categoryFilter);

      return await ManagerService()
          .service
          .getExpenseService()
          .totalExpensesByPeriodAndCategory(
              periodFilter, category, this, null, null);
    }
  }

  @override
  void update() {
    setState(() {});
  }
}
