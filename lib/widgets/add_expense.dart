import 'package:flutter/material.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/add_category.dart';
import 'package:pocket_pal/widgets/input_field_style.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  List<String> categories = [];
  String? dropdownValue;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initializeCategories();
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
    return SizedBox(
      height: 480,
      child: Column(
        children: [
          Container(
            width: 35,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "Add Expense:",
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
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return AddCategory(
                                      onCategoryAdded: initializeCategories,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 25.0,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            alignment: Alignment.centerRight,
                            isExpanded: true,
                            hint: const Text('Select a category'),
                            value: dropdownValue,
                            focusColor: Colors.transparent,
                            decoration: InputDecoration(
                              errorText: fieldEmptyChecks[2]
                                  ? "This field cannot be empty"
                                  : null,
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
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
                          fieldEmptyChecks[0] = _amountController.text.isEmpty;
                          fieldEmptyChecks[1] = _dateController.text.isEmpty;
                          fieldEmptyChecks[2] =
                              dropdownValue == null ? true : false;
                        });

                        if (fieldEmptyChecks.any((element) => element)) {
                          return;
                        }

                        String categoryName = dropdownValue ?? "";
                        Category category =
                            await getCategoryFromName(categoryName);

                        Expense newExpense = Expense(
                          amount: double.parse(_amountController.text),
                          date: DateTime.parse(_dateController.text),
                          category: category,
                          description: _descriptionController.text,
                        );

                        await saveExpense(newExpense);

                        _amountController.clear();
                        _dateController.clear();
                        _descriptionController.clear();
                        setState(() {
                          dropdownValue = null;
                        });
                      },
                      child: const Text(
                        'Add',
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

  Future<void> saveExpense(Expense expense) async {
    await ManagerService().service.getExpenseService().saveExpense(expense);
  }
}
