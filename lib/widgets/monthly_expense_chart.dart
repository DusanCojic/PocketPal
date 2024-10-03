import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/information_card.dart';
import 'package:pocket_pal/widgets/monthly_bar_chart.dart';

class MonthlyExpenseChart extends StatefulWidget {
  const MonthlyExpenseChart({super.key});

  @override
  State<StatefulWidget> createState() => _MonthlyExpenseChartState();
}

class _MonthlyExpenseChartState extends State<MonthlyExpenseChart>
    implements Subscriber {
  late int year;
  double average = 0.0;
  String highestMonth = "";

  void handleSelectedYear(int newYear) {
    setState(() {
      year = newYear;
    });
    getAverage();
    initMonth();
  }

  @override
  void initState() {
    year = DateTime.now().year;
    getAverage();
    initMonth();
    ManagerService().service.getExpenseService().subscribe(this);
    super.initState();
  }

  Future<void> getAverage() async {
    double result = await ManagerService()
        .service
        .getExpenseService()
        .monthlyAverage(year, null);
    setState(() {
      average = result;
    });
  }

  Future<void> initMonth() async {
    int month = await ManagerService()
        .service
        .getExpenseService()
        .monthWithTheHighestExpenses(year, null);
    setState(() {
      switch (month) {
        case 1:
          highestMonth = "January";
          break;
        case 2:
          highestMonth = "February";
          break;
        case 3:
          highestMonth = "March";
          break;
        case 4:
          highestMonth = "April";
          break;
        case 5:
          highestMonth = "May";
          break;
        case 6:
          highestMonth = "June";
          break;
        case 7:
          highestMonth = "July";
          break;
        case 8:
          highestMonth = "August";
          break;
        case 9:
          highestMonth = "September";
          break;
        case 10:
          highestMonth = "October";
          break;
        case 11:
          highestMonth = "November";
          break;
        case 12:
          highestMonth = "December";
          break;
        default:
          highestMonth = "";
      }
    });
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
        MonthlyBarChart(
          future: getData,
          barNames: const [
            "Total",
            "Average",
          ],
          onYearChanged: handleSelectedYear,
          showLegend: false,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InformationCard(
                title: "Monthly average",
                info: "\$${average.toStringAsFixed(2)}",
                color: const Color(0xff8bc6ec),
                width: (MediaQuery.of(context).size.width - 80) / 2,
                height: 70.0,
              ),
              InformationCard(
                title: "Highest expense month",
                info: highestMonth,
                color: const Color(0xff9599e2),
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
      await ManagerService()
          .service
          .getExpenseService()
          .totalMonthlyExpenses(year, sub),
    ];
  }

  @override
  void update() {
    getAverage();
    initMonth();
  }
}
