import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/util/time_period.dart';
import 'package:pocket_pal/widgets/expense_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseList extends StatefulWidget {
  String periodFilter;
  String categoryFilter;

  ExpenseList({
    super.key,
    this.periodFilter = "This month",
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
            ),
          );
        },
      ),
    );
  }

  Future<List<Expense>> buildList(
      String periodFilter, String categoryFilter) async {
    ManagerService().service.getCategoryService().subscribe(this);

    if (categoryFilter == "All categories") {
      switch (periodFilter) {
        case "This month":
          return await ManagerService()
              .service
              .getExpenseService()
              .getExpenses(period: TimePeriod.thisMonth, sub: this);
        case "Today":
          return await ManagerService()
              .service
              .getExpenseService()
              .getExpenses(period: TimePeriod.today, sub: this);
        case "This week":
          return await ManagerService()
              .service
              .getExpenseService()
              .getExpenses(period: TimePeriod.thisWeek, sub: this);
        case "This year":
          return await ManagerService()
              .service
              .getExpenseService()
              .getExpenses(period: TimePeriod.lastYear, sub: this);
        case "All":
          return await ManagerService()
              .service
              .getExpenseService()
              .getAllExpenses(this);
      }
    } else {
      Category category = await ManagerService()
          .service
          .getCategoryService()
          .getCategoryByName(categoryFilter);

      switch (periodFilter) {
        case "This month":
          return await ManagerService()
              .service
              .getExpenseService()
              .filterByPeriodAndCategory(
                  TimePeriod.thisMonth, category, this, null, null);
        case "Today":
          return await ManagerService()
              .service
              .getExpenseService()
              .filterByPeriodAndCategory(
                  TimePeriod.today, category, this, null, null);
        case "This week":
          return await ManagerService()
              .service
              .getExpenseService()
              .filterByPeriodAndCategory(
                  TimePeriod.thisWeek, category, this, null, null);
        case "This year":
          return await ManagerService()
              .service
              .getExpenseService()
              .filterByPeriodAndCategory(
                  TimePeriod.ytd, category, this, null, null);
        case "All":
          return await ManagerService()
              .service
              .getExpenseService()
              .filterByCategory(category, this);
      }
    }

    return ManagerService()
        .service
        .getExpenseService()
        .getExpenses(period: TimePeriod.thisMonth, sub: this);
  }

  Future<void> removeExpense(Expense expense) async {
    await ManagerService().service.getExpenseService().deleteExpense(expense);
  }

  @override
  void update() {
    setState(() {});
  }
}
