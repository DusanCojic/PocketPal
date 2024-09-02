import 'package:flutter/material.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/widgets/full_expense_view.dart';

// ignore: must_be_immutable
class ExpenseCard extends StatefulWidget {
  Expense expense;

  ExpenseCard({super.key, required this.expense});

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          builder: (BuildContext context) {
            return FullExpenseView(expense: widget.expense);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.expense.category.color,
                    ),
                    child: Icon(
                      IconData(widget.expense.category.iconCode,
                          fontFamily: "MaterialIcons"),
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.expense.category.name,
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              '\$${widget.expense.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.expense.date.year}-${widget.expense.date.month}-${widget.expense.date.day}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
