import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/year_picker.dart' as YP;
import 'package:pocket_pal/widgets/month_picker.dart' as MP;

class DailyLineChart extends StatefulWidget {
  final Function(int) onMonthChanged;
  final Function(int) onYearChanged;
  final Future<List<double>> Function(int, int, Subscriber?) future;

  const DailyLineChart({
    super.key,
    required this.future,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  State<StatefulWidget> createState() => _DailyLineChartState();
}

class _DailyLineChartState extends State<DailyLineChart> implements Subscriber {
  late int month;
  late int year;

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

  void handleSelectedYear(int newYear) {
    setState(() {
      year = newYear;
    });

    widget.onYearChanged(newYear);
  }

  void handleSelectedMonth(int newMonth) {
    setState(() {
      month = newMonth;
    });

    widget.onMonthChanged(newMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 365,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300.0,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                ),
                child: FutureBuilder<List<double>>(
                  future: widget.future(month, year, this),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container();
                    }

                    return LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 25.0,
                              getTitlesWidget: getBottomTitles,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35.0,
                              getTitlesWidget: getLeftTitles,
                              maxIncluded: false,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            strokeWidth: 0.5,
                            color: Colors.black12,
                          ),
                          getDrawingVerticalLine: (value) => const FlLine(
                            strokeWidth: 0.5,
                            color: Colors.black12,
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            spots: getSpots(snapshot.data!),
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff8bc6ec),
                                Color(0xff9599e2),
                              ],
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff8bc6ec).withOpacity(0.4),
                                  const Color(0xff9599e2).withOpacity(0.4),
                                ],
                              ),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpot) {
                            return touchedSpot.map((touchedSpot) {
                              final text =
                                  '${touchedSpot.x.toInt()} : ${touchedSpot.y}';
                              return LineTooltipItem(
                                text,
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        builder: (BuildContext context) {
                          return YP.YearPicker(
                            onSelectedYear: handleSelectedYear,
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
                      year.toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        builder: (BuildContext context) {
                          return MP.MonthPicker(
                            onSelectedMonth: handleSelectedMonth,
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
                      getMonthName(month),
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> getSpots(List<double> data) {
    List<FlSpot> result = [];

    for (int i = 0; i < data.length; i++) {
      result.add(
        FlSpot(
          double.parse((i + 1).toString()),
          data[i],
        ),
      );
    }

    return result;
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  String getMonthName(int number) {
    switch (number) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }
    return "";
  }

  @override
  void update() {
    setState(() {});
  }
}