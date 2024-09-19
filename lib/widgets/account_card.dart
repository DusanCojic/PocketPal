import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/add_income.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  State<StatefulWidget> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 0,
        color: Colors.lightBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset("assets/Lines.png").image,
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0, top: 15.0),
                    child: Text(
                      "Salary",
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: PopupMenuTheme(
                      data: const PopupMenuThemeData(
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        shadowColor: Colors.white,
                      ),
                      child: PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == "Delete") {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Delete account"),
                                  content: const Text(
                                      "Are you sure you want to delete \"Salary\" account?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return ['Delete'].map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: Center(
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            );
                          }).toList();
                        },
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          "Total income",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          "\$125,365.76",
                          style: TextStyle(
                            fontSize: 34,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0, top: 60.0),
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: const AddIncome(),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_rounded,
                        color: Colors.white,
                        size: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
