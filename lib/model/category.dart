import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part "category.g.dart";

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String icon;

  @HiveField(2)
  int colorValue = 0;

  Color get color => Color(colorValue);
  set color(Color color) => colorValue = color.value;

  Category.withColor({required this.name, required this.icon, required color}) {
    this.color = color;
  }

  Category({required this.name, required this.icon, required this.colorValue});
}
