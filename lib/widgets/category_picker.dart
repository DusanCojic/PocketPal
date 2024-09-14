import 'package:flutter/material.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/service/manager_service.dart';

class CategoryPicker extends StatefulWidget {
  final Function(String) onSelected;

  const CategoryPicker({super.key, required this.onSelected});

  @override
  State<StatefulWidget> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  final List<String> categories = ["All categories"];

  late String chosen = categories[0];

  @override
  void initState() {
    initializeCategories();

    super.initState();
  }

  void initializeCategories() async {
    List<Category> cats = await getCategories();

    setState(() {
      categories.addAll(cats.map((e) => e.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 400.0,
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
            padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: Text(
              "Pick a category",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    categories[index],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    setState(() {
                      chosen = categories[index];
                    });

                    widget.onSelected(chosen);

                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Category>> getCategories() async {
    return await ManagerService()
        .service
        .getCategoryService()
        .getCategories(null);
  }
}
