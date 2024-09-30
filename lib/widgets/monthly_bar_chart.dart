import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/service/manager_service.dart';
// ignore: library_prefixes
import 'package:pocket_pal/widgets/year_picker.dart' as YP;

class MonthlyBarChart extends StatefulWidget {
  final Function(int) onYearChanged;
  final List<String> barNames;
  final Future<List<List<double>>> Function(int, Subscriber?) future;
  final List<LinearGradient> gradients;
  final bool showLegend;

  MonthlyBarChart({
    super.key,
    required this.future,
    required this.onYearChanged,
    required this.barNames,
    List<LinearGradient>? gradients,
    this.showLegend = true,
  }) : gradients = gradients ?? _defaultGradients;

  static final List<LinearGradient> _defaultGradients = [
    LinearGradient(
      colors: [
        const Color(0xff8bc6ec).withOpacity(0.8),
        const Color(0xff9599e2).withOpacity(0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [
        const Color.fromARGB(255, 255, 179, 64).withOpacity(0.8),
        const Color(0xfffb8c00).withOpacity(0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [
        const Color(0xff81c784).withOpacity(0.8),
        const Color(0xff4caf50).withOpacity(0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [
        const Color(0xffff5252).withOpacity(0.8),
        const Color(0xfff44336).withOpacity(0.8),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

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
    ManagerService().service.getAccountService().subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    ManagerService().service.getExpenseService().unsubscribe(this);
    ManagerService().service.getAccountService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: widget.showLegend ? 420 : 365,
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
                child: FutureBuilder<List<List<double>>>(
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
                              reservedSize: 35.0,
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
            widget.showLegend
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 19.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: getLegendItems(),
                    ),
                  )
                : Container(),
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

  List<BarChartGroupData> getGroupData(List<List<double>> data) {
    List<BarChartGroupData> result = [];

    int gradientIndex = 0;
    int loopEnd = firstHalf ? 6 : 12;
    for (int index = firstHalf ? 0 : 6; index < loopEnd; index++) {
      List<BarChartRodData> rodData = [];

      for (List<double> l in data) {
        rodData.add(
          BarChartRodData(
            toY: double.parse(
              l[index].toStringAsFixed(2),
            ),
            width: 10.0,
            gradient:
                widget.gradients[(gradientIndex++) % widget.gradients.length],
          ),
        );
      }

      gradientIndex = 0;

      result.add(
        BarChartGroupData(
          x: index,
          barRods: rodData,
        ),
      );
    }

    return result;
  }

  List<SizedBox> getLegendItems() {
    int gradientIndex = 0;

    List<SizedBox> result = [];
    for (String barName in widget.barNames) {
      result.add(
        SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: widget
                      .gradients[(gradientIndex++) % widget.gradients.length],
                ),
              ),
              const SizedBox(width: 5),
              Text(barName),
              const SizedBox(width: 15),
            ],
          ),
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
