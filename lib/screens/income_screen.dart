import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/account_card.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
      padding: EdgeInsets.all(15),
      child: Column(children: [
        AccountCard(),
        AccountCard(),
        AccountCard(),
        AccountCard(),
      ]),
    ));
  }
}
