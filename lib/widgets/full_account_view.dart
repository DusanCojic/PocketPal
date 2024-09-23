import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pocket_pal/model/account.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/input_field_style.dart';

class FullAccountView extends StatefulWidget {
  final Account account;

  const FullAccountView({super.key, required this.account});

  @override
  State<StatefulWidget> createState() => _FullAccountViewState();
}

class _FullAccountViewState extends State<FullAccountView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Color currentColor = Colors.blueAccent;
  Color pickerColor = Colors.blueAccent;

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  bool isNameEmpty = false;
  bool isAmountEmpty = false;

  @override
  void initState() {
    _nameController.text = widget.account.name;
    _amountController.text = widget.account.initialBalance.toString();
    currentColor = Color(widget.account.colorCode);
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
              "View and edit account",
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: customInputDecoration(
                            label: "Name",
                            emptyCheck: isNameEmpty,
                            icon: null,
                          ),
                        ),
                      ), // Space between TextFormField and button
                      ElevatedButton(
                        onPressed: () => _dialogBuilder(context),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                        ),
                        child: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: currentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration(
                      label: "Initial account balance",
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

                        if (isNameEmpty ||
                            isAmountEmpty ||
                            (double.parse(_amountController.text) ==
                                    widget.account.initialBalance &&
                                _nameController.text == widget.account.name &&
                                widget.account.colorCode ==
                                    currentColor.value)) {
                          return;
                        }

                        widget.account.name = _nameController.text;
                        widget.account.total -= widget.account.initialBalance;
                        widget.account.initialBalance =
                            double.parse(_amountController.text);
                        widget.account.total += widget.account.initialBalance;
                        widget.account.colorCode = currentColor.value;

                        await ManagerService()
                            .service
                            .getAccountService()
                            .updateAccount(widget.account);
                      },
                      child: const Text(
                        "Edit",
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

  // Color picker
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: currentColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentColor = pickerColor;
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
