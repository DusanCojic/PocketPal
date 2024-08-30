import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/screens/expense_screen.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/expense_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<StatefulWidget> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> implements Subscriber {
  @override
  void dispose() {
    ManagerService().service.getExpenseService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Expense>>(
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

          final expenses = snapshot.data!.reversed.toList();
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              return Slidable(
                key: ValueKey(index - expenses[index].hashCode),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => removeExpense(expenses[index]),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ExpenseCard(expense: expenses[index]),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Expense>> buildList() async {
    return await ManagerService()
        .service
        .getExpenseService()
        .getAllExpenses(this);
  }

  Future<void> removeExpense(Expense expense) async {
    await ManagerService().service.getExpenseService().deleteExpense(expense);
  }

  @override
  void update() {
    setState(() {});
  }
}
