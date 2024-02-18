import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/service/persistent_category_service.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'fake_path_provider_platform.dart';

void main() {
  group(
    "Persistent Category service tests",
    persistentCategoryServiceTests,
  );
}

void persistentCategoryServiceTests() {
  late PersistentCategoryService service;
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    await Hive.initFlutter();

    Hive.registerAdapter<Category>(CategoryAdapter());

    final box = await Hive.openBox<Category>(
      "testCategoryBox",
    );

    await box.clear();
    await box.flush();

    List<Category> testCategories = [
      Category(
        name: "1",
        icon: "1",
        colorValue: 1,
      ),
      Category(
        name: "2",
        icon: "2",
        colorValue: 2,
      )
    ];

    for (var element in testCategories) {
      await box.add(element);
    }

    service = PersistentCategoryService(box: box);
  });

  tearDownAll(() async {
    await service.box.clear();
    await service.box.flush();
    await service.dispose();

    await Hive.close();
  });

  test(
    "Get All categories should return 2 categories",
    () async => getAllCategories(service),
  );

  test(
    "Save 1 category to box",
    () async => saveCategory(service),
  );

  test(
    "Update category name",
    () async => updateCategory(service),
  );

  test(
    "Delete category",
    () async => deleteCategory(service),
  );
}

void updateCategory(PersistentCategoryService service) async {
  List<Category> categories = await service.getCategories();

  Category category = categories[1];

  category.name = "4";
  category.icon = "4";

  await service.updateCategory(category);

  categories = await service.getCategories();

  expect(categories[1].name, "4");
  expect(categories[1].icon, "4");
}

void deleteCategory(PersistentCategoryService service) async {
  List<Category> categories = await service.getCategories();

  Category category = categories[1];

  await service.deleteCategory(category);

  categories = await service.getCategories();

  expect(categories[0].name, "1");
  expect(categories[1].name, "3");
}

void saveCategory(PersistentCategoryService service) async {
  Category newCategory = Category(name: "3", icon: "3", colorValue: 0);

  await service.saveCategory(newCategory);

  List<Category> categories = await service.getCategories();

  expect(categories.length, 3);
  expect(categories[2].name, "3");
  expect(categories[2].icon, "3");
}

void getAllCategories(PersistentCategoryService service) async {
  List<Category> categories = await service.getCategories();

  expect(categories.length, 2);
  expect(categories[0].name, "1");
  expect(categories[1].name, "2");
}
