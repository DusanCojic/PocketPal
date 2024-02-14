import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_pal/model/expense.dart';
import 'package:pocket_pal/model/income.dart';
import 'package:pocket_pal/model/saving.dart';

import 'model/category.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(IncomeAdapter());
  Hive.registerAdapter(SavingAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}
