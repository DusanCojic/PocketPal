import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/service/manager_service.dart';
import 'package:pocket_pal/widgets/full_category_view.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> implements Subscriber {
  @override
  void dispose() {
    ManagerService().service.getCategoryService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color.fromRGBO(245, 245, 247, 1.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final categories = snapshot.data!.reversed.toList();
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color.fromRGBO(245, 245, 247, 1.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 25.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    Category category = categories[index];

                    if (category.name == "Uncategorized") {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: category.color,
                                    ),
                                    child: Icon(
                                      IconData(category.iconCode,
                                          fontFamily: "MaterialIcons"),
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Slidable(
                      key: ValueKey(index - categories[index].hashCode),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await deleteCategory(categories[index]);
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return FullCategoryView(
                                  category: category,
                                  onCategoryEditted: getCategories,
                                );
                              },
                            );
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.white,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 30,
                              height: MediaQuery.of(context).size.height / 10,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: category.color,
                                      ),
                                      child: Icon(
                                        IconData(category.iconCode,
                                            fontFamily: "MaterialIcons"),
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        category.name,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Category>> getCategories() async {
    return await ManagerService()
        .service
        .getCategoryService()
        .getCategories(this);
  }

  Future<void> deleteCategory(Category cat) async {
    List<Expense> expenses = await ManagerService()
        .service
        .getExpenseService()
        .filterByCategory(cat);

    Category uncategorized = await ManagerService()
        .service
        .getCategoryService()
        .getCategoryByName('Uncategorized');

    for (Expense ex in expenses) {
      ex.category = uncategorized;
      await ManagerService().service.getExpenseService().updateExpense(ex);
    }

    await ManagerService().service.getCategoryService().deleteCategory(cat);
  }

  @override
  void update() {
    setState(() {});
  }
}
