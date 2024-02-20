import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/add_expense.dart';

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
        return const Center(
          child: Text('Pressed from account page'),
        );
      case 3:
        return const Center(
          child: Text('Pressed from query page'),
        );
      case 4:
        return const Center(
          child: Text('Pressed from settings page'),
        );
      default:
        return const AddExpense();
    }
  }
}
