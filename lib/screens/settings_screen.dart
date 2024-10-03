import 'package:flutter/material.dart';
import 'package:pocket_pal/widgets/category_list.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 247, 1.0),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0, right: 150.0, bottom: 20.0),
            child: SizedBox(
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 38.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        builder: (context) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: CategoryList(),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 120.0),
                    ),
                    child: const Text(
                      "Edit categories",
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
