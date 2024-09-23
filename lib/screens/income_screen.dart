import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/account_list.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(233, 234, 236, 0.2),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: AccountList(),
      ),
    );
  }
}
