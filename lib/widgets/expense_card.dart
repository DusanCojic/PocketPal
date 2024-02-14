import 'package:flutter/material.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard({super.key});

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueAccent.withOpacity(0.5),
                Colors.purpleAccent.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: FutureBuilder<double>(
              future: getTotalExpenses(),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 15.0,
                    ),
                    children: [
                      const TextSpan(text: 'Total Expense:\n'),
                      TextSpan(
                        text: '\$${snapshot.data.toString()}',
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<double> getTotalExpenses() async {
    await Future.delayed(const Duration(seconds: 1));
    return 24513.32;
  }
}
