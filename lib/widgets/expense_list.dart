import 'package:flutter/material.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/expense_card.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: buildList(),
      builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "There are no expenses!",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        }

        final expenses = snapshot.data!;
        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return ExpenseCard(expense: expenses[index]);
          },
        );
      },
    );
  }

  Future<List<Expense>> buildList() async {
    return await ManagerService().service.getExpenseService().getAllExpenses();
  }
}
