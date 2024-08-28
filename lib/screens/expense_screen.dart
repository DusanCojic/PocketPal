import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/expense_list.dart';
import 'package:pocket_pal/widgets/total_expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(254, 254, 248, 0.8),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          children: const [
            TotalExpenseCard(),
            ExpenseList(),
          ],
        ),
      ),
    );
  }
}
