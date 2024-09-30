import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';

class MonthlyIncomeChart extends StatefulWidget {
  const MonthlyIncomeChart({super.key});

  @override
  State<StatefulWidget> createState() => _MonthlyIncomeChartState();
}

class _MonthlyIncomeChartState extends State<MonthlyIncomeChart>
    implements Subscriber {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void update() {
    setState(() {});
  }
}
