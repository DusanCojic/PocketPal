import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/daily_line_chart.dart';

class AverageDailyExpenseChart extends StatefulWidget {
  const AverageDailyExpenseChart({super.key});

  @override
  State<StatefulWidget> createState() => _AverageDailyExpenseChartState();
}

class _AverageDailyExpenseChartState extends State<AverageDailyExpenseChart>
    implements Subscriber {
  late int month;
  late int year;

  void handleSelectedMonth(int newMonth) {
    setState(() {
      month = newMonth;
    });
  }

  void handleSelectedYear(int newYear) {
    setState(() {
      year = newYear;
    });
  }

  @override
  void initState() {
    month = DateTime.now().month;
    year = DateTime.now().year;
    ManagerService().service.getExpenseService().subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    ManagerService().service.getExpenseService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DailyLineChart(
      future: getData,
      onMonthChanged: handleSelectedMonth,
      onYearChanged: handleSelectedYear,
    );
  }

  Future<List<double>> getData(int month, int year, Subscriber? sub) async {
    return await ManagerService()
        .service
        .getExpenseService()
        .averageDailyExpense(month, year, sub);
  }

  @override
  void update() {
    setState(() {});
  }
}
