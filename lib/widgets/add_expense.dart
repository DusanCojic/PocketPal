// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  List<String> categories = ['Groceries', 'Bills', 'Subscription'];
  late String dropdownValue;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (categories.isNotEmpty) {
      dropdownValue = categories.first;
    } else {
      dropdownValue = 'abc';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            "Add Expense:",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Form(
          key: GlobalKey<FormState>(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: "Name",
                    contentPadding: const EdgeInsets.only(left: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: "Amount",
                      contentPadding: const EdgeInsets.only(left: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      filled: false,
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Select a category'),
                    value: dropdownValue,
                    focusColor: Colors.transparent,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(250, 48),
                    ),
                    onPressed: () {
                      print(_nameController.text);
                      print(_amountController.text);
                      print(_dateController.text);
                      print(dropdownValue);
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
}
