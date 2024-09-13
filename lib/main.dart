import 'package:flutter/material.dart';
import 'package:pocket_pal/model/category.dart';

import 'package:pocket_pal/service/manager_service.dart';
import './widgets/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ManagerService().initialize();

  Category uncategorized = Category(
    name: "Uncategorized",
    iconCode: Icons.close_rounded.codePoint,
    colorValue: Colors.grey.value,
  );

  await ManagerService()
      .service
      .getCategoryService()
      .saveCategory(uncategorized);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: BottomBar(),
      ),
    );
  }
}
