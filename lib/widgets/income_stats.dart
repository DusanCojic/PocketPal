import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/monthly_income_chart.dart';

class IncomeStats extends StatefulWidget {
  const IncomeStats({super.key});

  @override
  State<StatefulWidget> createState() => _IncomeStatsState();
}

class _IncomeStatsState extends State<IncomeStats> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: MonthlyIncomeChart(),
          ),
        ],
      ),
    );
  }
}
