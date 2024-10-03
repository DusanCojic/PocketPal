import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/monthly_bar_chart.dart';

class MonthlyExpenseChart extends StatefulWidget {
  const MonthlyExpenseChart({super.key});

  @override
  State<StatefulWidget> createState() => _MonthlyExpenseChartState();
}

class _MonthlyExpenseChartState extends State<MonthlyExpenseChart>
    implements Subscriber {
  late int year;

  void handleSelectedYear(int newYear) {
    setState(() {
      year = newYear;
    });
  }

  @override
  void initState() {
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
    return MonthlyBarChart(
      future: getData,
      barNames: const [
        "Total",
        "Average",
      ],
      onYearChanged: handleSelectedYear,
      showLegend: false,
    );
  }

  Future<List<List<double>>> getData(int year, Subscriber? sub) async {
    return [
      await ManagerService()
          .service
          .getExpenseService()
          .totalMonthlyExpenses(year, sub),
    ];
  }

  @override
  void update() {
    setState(() {});
  }
}
