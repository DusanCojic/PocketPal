import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
// ignore: library_prefixes
import 'package:pocket_pal/widgets/year_picker.dart' as YP;

class MonthlyBarChart extends StatefulWidget {
  final Function(int) onYearChanged;
  final Future<List<double>> Function(int, Subscriber?) future;

  const MonthlyBarChart({
    super.key,
    required this.future,
    required this.onYearChanged,
  });

  @override
  State<StatefulWidget> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart>
    implements Subscriber {
  late int year;
  late bool firstHalf;

  void handleSelectedYear(int newYear) {
    setState(() {
      year = newYear;
    });

    widget.onYearChanged(newYear);
  }

  @override
  void initState() {
    year = DateTime.now().year;
    firstHalf = (DateTime.now().month <= 6) ? true : false;
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
                  top: 30.0,
                  left: 25.0,
                  right: 25.0,
                ),
                child: FutureBuilder<List<double>>(
                  future: widget.future(year, this),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container();
                    }

                    return BarChart(
                      BarChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            strokeWidth: 0.5,
                            color: Colors.black12,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 25.0,
                              getTitlesWidget: getBottomTitles,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30.0,
                              getTitlesWidget: getLeftTitles,
                              maxIncluded: false,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: getGroupData(snapshot.data!),
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
                      setState(() {
                        firstHalf = !firstHalf;
                      });
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
                      firstHalf ? "Jan - Jun" : "Jul - Dec",
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

  List<BarChartGroupData> getGroupData(List<double> data) {
    List<BarChartGroupData> result = [];

    int loopEnd = firstHalf ? 6 : 12;
    for (int index = firstHalf ? 0 : 6; index < loopEnd; index++) {
      result.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: double.parse(
                data[index].toStringAsFixed(2),
              ),
              width: 10.0,
              gradient: LinearGradient(
                colors: [
                  const Color(0xff8bc6ec).withOpacity(0.8),
                  const Color(0xff9599e2).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ],
        ),
      );
    }

    return result;
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black26,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
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

  @override
  void update() {
    setState(() {});
  }
}