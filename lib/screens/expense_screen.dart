import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/expense_list.dart';
import 'package:pocket_pal/widgets/filter_expenses.dart';
import 'package:pocket_pal/widgets/total_expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  String period = "This month";
  String category = "All categories";

  void setPeriod(String newPeriod) {
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
            TotalExpenseCard(
              periodFilter: period,
              categoryFilter: category,
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
