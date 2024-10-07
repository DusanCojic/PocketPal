import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/expense_stats.dart';
import 'package:pocket_pal/widgets/income_stats.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 234, 236, 0.2),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Statistics",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              indicatorColor:
                  selectedIndex == 0 ? Colors.redAccent : Colors.lightGreen,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        color:
                            selectedIndex == 0 ? Colors.redAccent : Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Expenses",
                        style: TextStyle(
                          color: selectedIndex == 0
                              ? Colors.redAccent
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: selectedIndex == 1
                            ? Colors.lightGreen
                            : Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Income",
                        style: TextStyle(
                          color: selectedIndex == 1
                              ? Colors.lightGreen
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ExpenseStats(),
              IncomeStats(),
            ],
          ),
        ),
      ),
    );
  }
}
