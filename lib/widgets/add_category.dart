import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/input_field_style.dart';

class AddCategory extends StatefulWidget {
  final Function onCategoryAdded;

  const AddCategory({super.key, required this.onCategoryAdded});

  @override
  State<StatefulWidget> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _nameCotroller = TextEditingController();

  IconData? icon = Icons.home;

  Color currentColor = Colors.blueAccent;
  Color pickerColor = Colors.blueAccent;

  _pickIcon() async {
    icon = await showIconPicker(
      context,
      iconPackModes: [
        IconPack.material,
      ],
    );

    setState(() {});
  }

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  bool isNameEmpty = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
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
              "Add Category",
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
                    controller: _nameCotroller,
                    keyboardType: TextInputType.text,
                    decoration: customInputDecoration(
                      label: "Name",
                      emptyCheck: isNameEmpty,
                      icon: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickIcon,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 20.0),
                          ),
                          child: const Text("Select an icon"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            icon,
                            color: Colors.blueAccent,
                            size: 35.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: ElevatedButton(
                            onPressed: () => _dialogBuilder(context),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            child: CircleAvatar(
                              radius: 15.0,
                              backgroundColor: currentColor,
                            ),
                          ),
                        ),
                      ],
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
                          isNameEmpty = _nameCotroller.text.isEmpty;
                        });

                        if (isNameEmpty) {
                          return;
                        }

                        Category newCategory = Category(
                          name: _nameCotroller.text,
                          iconCode: icon?.codePoint ?? Icons.home.codePoint,
                          colorValue: currentColor.value,
                        );

                        await ManagerService()
                            .service
                            .getCategoryService()
                            .saveCategory(newCategory);

                        widget.onCategoryAdded();

                        _nameCotroller.clear();
                        setState(() {
                          currentColor = Colors.blueAccent;
                          icon = Icons.home;
                        });
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
