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
        color: const Color.fromRGBO(233, 234, 236, 0.2),
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
