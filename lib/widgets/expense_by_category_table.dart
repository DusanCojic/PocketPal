import 'package:flutter/material.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/util/time_period.dart';
import 'package:pocket_pal/widgets/expense_by_category_card.dart';

class ExpenseByCategoryTable extends StatefulWidget {
  final TimePeriod period;
  final bool sort;

  const ExpenseByCategoryTable({
    super.key,
    required this.period,
    required this.sort,
  });

  @override
  State<StatefulWidget> createState() => _ExpenseByCategoryTableState();
}

class _ExpenseByCategoryTableState extends State<ExpenseByCategoryTable>
    implements Subscriber {
  @override
  void initState() {
    ManagerService().service.getExpenseService().subscribe(this);
    super.initState();
  }

  @override
  void dispose() {
    ManagerService().service.getExpenseService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(widget.period, this),
      builder: (BuildContext context,
          AsyncSnapshot<Map<Category, double>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        }

        final data = snapshot.data!;
        final sortedData = Map.fromEntries(
          data.entries.toList()
            ..sort(
              (a, b) => widget.sort
                  ? a.value.compareTo(b.value)
                  : b.value.compareTo(a.value),
            ),
        );

        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedData.length,
            itemBuilder: (context, index) {
              Category key = sortedData.keys.elementAt(index);
              if (sortedData[key] != 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ExpenseByCategoryCard(
                    category: key,
                    value: sortedData[key],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  Future<Map<Category, double>> getData(
      TimePeriod period, Subscriber? sub) async {
    return await ManagerService()
        .service
        .getExpenseService()
        .totalExpensesForEveryCategory(period, sub);
  }

  @override
  void update() {
    setState(() {});
  }
}
