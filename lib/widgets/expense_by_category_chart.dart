import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/util/time_period.dart';

class ExpenseByCategoryChart extends StatefulWidget {
  final TimePeriod period;

  const ExpenseByCategoryChart({
    super.key,
    required this.period,
  });

  @override
  State<StatefulWidget> createState() => _ExpenseByCategoryChartState();
}

class _ExpenseByCategoryChartState extends State<ExpenseByCategoryChart>
    implements Subscriber {
  @override
  void initState() {
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: FutureBuilder<List<PieChartSectionData>>(
        future: buildSections(widget.period, this),
        builder: (BuildContext context,
            AsyncSnapshot<List<PieChartSectionData>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container();
          }

          final stats = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text("Total Expense"),
                        ),
                        Center(
                          child: FutureBuilder<double>(
                            future: getTotal(widget.period),
                            builder: (context, snapshot) {
                              final total = snapshot.data ?? 0.00;

                              return Text(
                                "\$${NumberFormat("#,##0.00").format(total)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    PieChart(
                      PieChartData(
                        sections: stats,
                        sectionsSpace: 5.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<PieChartSectionData>> buildSections(
      TimePeriod period, Subscriber? sub) async {
    final stats = await ManagerService()
        .service
        .getExpenseService()
        .totalExpensesForEveryCategory(period, sub);

    List<PieChartSectionData> result = [];

    stats.forEach((category, total) {
      result.add(
        PieChartSectionData(
          value: total,
          color: Color(category.colorValue).withOpacity(0.7),
          showTitle: false,
          radius: 20,
        ),
      );
    });

    return result;
  }

  Future<double> getTotal(TimePeriod period) async {
    return await ManagerService().service.getExpenseService().getTotalExpense(
          period: period,
        );
  }

  @override
  void update() {
    setState(() {});
  }
}
