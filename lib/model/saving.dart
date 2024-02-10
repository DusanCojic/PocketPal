import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class Saving extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  @HiveField(2)
  double goal;

  @HiveField(3)
  Color color;

  Saving({
    required this.name,
    required this.amount,
    required this.goal,
    required this.color,
  });
}
