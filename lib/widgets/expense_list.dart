import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/expense_card.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          return const ExpenseCard();
        },
      ),
    );
  }
}
