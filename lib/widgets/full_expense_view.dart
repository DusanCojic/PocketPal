import 'package:flutter/material.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/input_field_style.dart';
import 'package:intl/intl.dart';

class FullExpenseView extends StatefulWidget {
  final Expense expense;

  const FullExpenseView({super.key, required this.expense});

  @override
  State<StatefulWidget> createState() => _FullExpenseViewState();
}

class _FullExpenseViewState extends State<FullExpenseView> {
  List<String> categories = [];
  String? dropdownValue;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initializeCategories();

    _amountController.text = widget.expense.amount.toString();
    _dateController.text = DateFormat('yyyy-MM-dd').format(widget.expense.date);
    dropdownValue = widget.expense.category.name;
    _descriptionController.text = widget.expense.description;
  }

  void initializeCategories() async {
    List<Category> cats = await getCategories();
    setState(() {
      categories = cats.map((category) => category.name).toList();
    });
  }

  List<bool> fieldEmptyChecks = List.filled(3, false);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 500,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      )),
      child: SizedBox(
        height: 450,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                width: 35,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Text(
                "View and edit expense:",
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Form(
              key: GlobalKey<FormState>(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: customInputDecoration(
                        label: "Amount",
                        emptyCheck: fieldEmptyChecks[0],
                        icon: null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextFormField(
                        controller: _dateController,
                        decoration: customInputDecoration(
                          label: "Date",
                          emptyCheck: fieldEmptyChecks[1],
                          icon: Icons.calendar_month_rounded,
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              alignment: Alignment.centerRight,
                              isExpanded: true,
                              hint: const Text('Select a category'),
                              value: dropdownValue,
                              focusColor: Colors.transparent,
                              decoration: customInputDecoration(
                                label: "",
                                emptyCheck: fieldEmptyChecks[2],
                                icon: null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  dropdownValue = value;
                                });
                              },
                              items: categories.isEmpty
                                  ? []
                                  : categories.map<DropdownMenuItem<String>>(
                                      (String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Center(
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.text,
                        decoration: customInputDecoration(
                          label: "Description",
                          emptyCheck: false,
                          icon: null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(250, 48),
                        ),
                        onPressed: () async {
                          setState(() {
                            fieldEmptyChecks[0] =
                                _amountController.text.isEmpty;
                            fieldEmptyChecks[1] = _dateController.text.isEmpty;
                            fieldEmptyChecks[2] =
                                dropdownValue == null ? true : false;
                          });

                          if (fieldEmptyChecks.any((element) => element)) {
                            return;
                          }

                          if (_amountController.text ==
                                  widget.expense.amount.toString() &&
                              DateTime.parse(_dateController.text) ==
                                  widget.expense.date &&
                              dropdownValue == widget.expense.category.name &&
                              _descriptionController.text ==
                                  widget.expense.description) {
                            return;
                          }

                          String categoryName = dropdownValue ?? "";
                          Category category =
                              await getCategoryFromName(categoryName);

                          widget.expense.amount =
                              double.parse(_amountController.text);
                          widget.expense.date =
                              DateTime.parse(_dateController.text);
                          widget.expense.category = category;
                          widget.expense.description =
                              _descriptionController.text;

                          await updateExpense(widget.expense);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<List<Category>> getCategories() async {
    return ManagerService().service.getCategoryService().getCategories(null);
  }

  Future<Category> getCategoryFromName(String name) async {
    return await ManagerService()
        .service
        .getCategoryService()
        .getCategoryByName(name);
  }

  Future<void> updateExpense(Expense expense) async {
    await ManagerService().service.getExpenseService().updateExpense(expense);
  }
}
