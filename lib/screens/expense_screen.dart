import 'package:flutter/material.dart';
import 'package:pocket_pal/util/time_period.dart';
import 'package:pocket_pal/widgets/expense_list.dart';
import 'package:pocket_pal/widgets/filter_expenses.dart';
import 'package:pocket_pal/widgets/total_expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  TimePeriod period = TimePeriod.thisMonth;
  String category = "All categories";

  void setPeriod(TimePeriod newPeriod) {
    setState(() {
      period = newPeriod;
    });
  }

  void setCategory(String newCategory) {
    setState(() {
      category = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(233, 234, 236, 0.2),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset("assets/sun-tornado.png").image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 55.0),
                  child: TotalExpenseCard(
                    periodFilter: period,
                    categoryFilter: category,
                  ),
                ),
              ],
            ),
            FilterExpenses(
              onPeriodChanged: setPeriod,
              onCategorySelected: setCategory,
            ),
            ExpenseList(
              periodFilter: period,
              categoryFilter: category,
            ),
          ],
        ),
      ),
    );
  }
}
