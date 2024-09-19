import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/input_field_style.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<StatefulWidget> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool isNameEmpty = false;
  bool isAmountEmpty = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
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
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "Add Income",
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: customInputDecoration(
                      label: "Name",
                      emptyCheck: isNameEmpty,
                      icon: null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration(
                      label: "Amount",
                      emptyCheck: isAmountEmpty,
                      icon: null,
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
                          isNameEmpty = _nameController.text.isEmpty;
                          isAmountEmpty = _amountController.text.isEmpty;
                        });

                        if (isNameEmpty || isAmountEmpty) {
                          return;
                        }

                        _nameController.clear();
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
