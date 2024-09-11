import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/category_picker.dart';
import 'package:pocket_pal/widgets/period_picker.dart';

class FilterExpenses extends StatefulWidget {
  final Function(String) onPeriodChanged;
  final Function(String) onCategorySelected;

  const FilterExpenses({
    super.key,
    required this.onPeriodChanged,
    required this.onCategorySelected,
  });

  @override
  State<StatefulWidget> createState() => _FilterExpensesState();
}

class _FilterExpensesState extends State<FilterExpenses> {
  String period = "This month";
  String category = "All categories";

  void handleSelectedPeriod(String newPeriod) {
    setState(() {
      period = newPeriod;
    });

    widget.onPeriodChanged(newPeriod);
  }

  void handleSelectedCategory(String newCategory) {
    setState(() {
      category = newCategory;
    });

    widget.onCategorySelected(newCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (BuildContext context) {
                  return PeriodPicker(
                    onSelected: handleSelectedPeriod,
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 17.0,
              ),
              backgroundColor: const Color.fromARGB(255, 235, 235, 235),
            ),
            child: Text(
              period,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 30.0,
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (BuildContext context) {
                  return CategoryPicker(
                    onSelected: handleSelectedCategory,
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 17.0,
              ),
              backgroundColor: const Color.fromARGB(255, 235, 235, 235),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
