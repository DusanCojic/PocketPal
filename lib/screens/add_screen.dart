import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/add_expense.dart';

// ignore: must_be_immutable
class AddScreen extends StatelessWidget {
  int pressedFromPage = 0;

  AddScreen({
    super.key,
    required this.pressedFromPage,
  });

  @override
  Widget build(BuildContext context) {
    switch (pressedFromPage) {
      case 0:
        return const AddExpense();
      case 1:
        return const SizedBox(
          height: 450,
          child: Center(
            child: Text('Pressed from income screen'),
          ),
        );
      default:
        return const AddExpense();
    }
  }
}
