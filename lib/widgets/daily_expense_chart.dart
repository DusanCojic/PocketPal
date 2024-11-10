import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/daily_line_chart.dart';
import 'package:pocket_pal/widgets/information_card.dart';

class DailyExpenseChart extends StatefulWidget {
  const DailyExpenseChart({super.key});

  @override
  State<StatefulWidget> createState() => _DailyExpenseChartState();
}

class _DailyExpenseChartState extends State<DailyExpenseChart>
    implements Subscriber {
  late int month;
  late int year;
  double average = 0;
  int day = 1;

  void handleSelectedMonth(int newMonth) {
    setState(() {
      month = newMonth;
    });
    initAverage();
    initDay();
  }

  void handleSelectedYear(int newYear) {
    setState(() {
      year = newYear;
    });
    initAverage();
    initDay();
  }

  Future<void> initAverage() async {
    double result = await ManagerService()
        .service
        .getExpenseService()
        .dailyAverage(month, year, null);
    setState(() {
      average = result;
    });
  }

  Future<void> initDay() async {
    int dayNum = await ManagerService()
        .service
        .getExpenseService()
        .dayWithTheHighestExpenses(month, year, null);
    setState(() {
      day = dayNum;
    });
  }

  @override
  void initState() {
    month = DateTime.now().month;
    year = DateTime.now().year;
    initAverage();
    initDay();
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
    return Column(
      children: [
        DailyLineChart(
          future: getData,
          lineNames: const [
            "Total",
          ],
          chartName: "Daily Expenses",
          onMonthChanged: handleSelectedMonth,
          onYearChanged: handleSelectedYear,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InformationCard(
                title: "Daily average",
                info: average.toStringAsFixed(2),
                color: const Color.fromARGB(255, 255, 179, 64),
                width: (MediaQuery.of(context).size.width - 80) / 2,
                height: 70.0,
              ),
              InformationCard(
                title: "Highest expense day",
                info:
                    "${DateFormat("EEEE").format(DateTime(year, month, day))}, $day",
                color: const Color(0xfffb8c00),
                width: (MediaQuery.of(context).size.width + 30) / 2,
                height: 70.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<List<List<double>>> getData(
      int month, int year, Subscriber? sub) async {
    return [
      await ManagerService()
          .service
          .getExpenseService()
          .totalDailyExpenses(month, year, sub),
    ];
  }

  @override
  void update() {
    initAverage();
    initDay();
  }
}
