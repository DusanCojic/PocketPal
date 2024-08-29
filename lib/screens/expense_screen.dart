import 'package:flutter/material.dart';
import 'package:pocket_pal/model/observable.dart';
import 'package:pocket_pal/widgets/expense_list.dart';
import 'package:pocket_pal/widgets/total_expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  final Observable expensesChangeNotifier;

  const ExpenseScreen({super.key, required this.expensesChangeNotifier});

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
        child: const Column(
          children: [
            TotalExpenseCard(),
            ExpenseList(),
          ],
        ),
      ),
    );
  }
}
