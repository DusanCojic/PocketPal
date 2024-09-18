import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/util/time_period.dart';
import 'package:pocket_pal/widgets/expense_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class ExpenseList extends StatefulWidget {
  TimePeriod periodFilter;
  String categoryFilter;

  ExpenseList({
    super.key,
    this.periodFilter = TimePeriod.thisMonth,
    this.categoryFilter = "All categories",
  });

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
        future: buildList(
          widget.periodFilter,
          widget.categoryFilter,
        ),
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
          expenses.sort((a, b) => b.date.compareTo(a.date));
          return Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(index - expenses[index].hashCode),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => removeExpense(expenses[index]),
                        backgroundColor: Colors.redAccent.withOpacity(0.2),
                        foregroundColor: Colors.redAccent,
                        icon: Icons.delete,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ExpenseCard(expense: expenses[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<Expense>> buildList(
      TimePeriod periodFilter, String categoryFilter) async {
    ManagerService().service.getCategoryService().subscribe(this);

    if (categoryFilter == "All categories") {
      return await ManagerService().service.getExpenseService().getExpenses(
            period: periodFilter,
            sub: this,
          );
    } else {
      Category category = await ManagerService()
          .service
          .getCategoryService()
          .getCategoryByName(categoryFilter);

      return await ManagerService()
          .service
          .getExpenseService()
          .filterByPeriodAndCategory(periodFilter, category, this, null, null);
    }
  }

  Future<void> removeExpense(Expense expense) async {
    await ManagerService().service.getExpenseService().deleteExpense(expense);
  }

  @override
  void update() {
    setState(() {});
  }
}
