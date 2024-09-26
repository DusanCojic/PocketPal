import 'package:flutter/material.dart';
import 'package:pocket_pal/util/time_period.dart';
import 'package:pocket_pal/widgets/daily_expense_chart.dart';
import 'package:pocket_pal/widgets/expense_by_category_chart.dart';
import 'package:pocket_pal/widgets/expense_by_category_table.dart';
import 'package:pocket_pal/widgets/monthly_expense_chart.dart';
import 'package:pocket_pal/widgets/period_picker.dart';

class ExpenseStats extends StatefulWidget {
  const ExpenseStats({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseStatsState();
}

class _ExpenseStatsState extends State<ExpenseStats> {
  TimePeriod period = TimePeriod.thisMonth;
  bool ascSort = false;

  void handleSelectedPeriod(TimePeriod newPeriod) {
    setState(() {
      period = newPeriod;
    });
  }

  void handleSortChange() {
    setState(() {
      ascSort = !ascSort;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ExpenseByCategoryChart(
              period: period,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      builder: (BuildContext context) {
                        return PeriodPicker(
                          onSelected: handleSelectedPeriod,
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0,
                    ),
                    backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                  ),
                  child: Text(
                    getPeriodName(period),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    handleSortChange();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 10.0,
                    ),
                    backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                  ),
                  child: Container(
                    child: ascSort == true
                        ? const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.black,
                            size: 21.0,
                          )
                        : const Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.black,
                            size: 21.0,
                          ),
                  ),
                ),
              ],
            ),
          ),
          ExpenseByCategoryTable(
            period: period,
            sort: ascSort,
          ),
          const MonthlyExpenseChart(),
          const DailyExpenseChart(),
          const SizedBox(height: 55),
        ],
      ),
    );
  }

  String getPeriodName(TimePeriod period) {
    switch (period) {
      case TimePeriod.thisMonth:
        return "This month";
      case TimePeriod.today:
        return "Today";
      case TimePeriod.thisWeek:
        return "This week";
      case TimePeriod.ytd:
        return "This year";
      case TimePeriod.all:
        return "All";
      case TimePeriod.lastYear:
        return "Last year";
      case TimePeriod.custom:
        return "";
    }
  }
}
