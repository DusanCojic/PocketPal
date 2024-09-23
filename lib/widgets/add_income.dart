import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/model/income.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/input_field_style.dart';

class AddIncome extends StatefulWidget {
  final Account account;

  const AddIncome({super.key, required this.account});

  @override
  State<StatefulWidget> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool isAmountEmpty = false;
  bool isDateEmpty = false;

  @override
  void initState() {
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

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
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration(
                      label: "Amount",
                      emptyCheck: isAmountEmpty,
                      icon: null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dateController,
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration(
                      label: "Date",
                      emptyCheck: isDateEmpty,
                      icon: null,
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
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
                          isDateEmpty = _amountController.text.isEmpty;
                          isAmountEmpty = _dateController.text.isEmpty;
                        });

                        if (isDateEmpty || isAmountEmpty) {
                          return;
                        }

                        Income newIncome = Income(
                          amount: double.parse(
                              _amountController.text.replaceAll(',', '.')),
                          date: DateTime.parse(_dateController.text),
                        );

                        await ManagerService()
                            .service
                            .getAccountService()
                            .addIncome(
                              widget.account,
                              newIncome,
                            );

                        _amountController.clear();
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
