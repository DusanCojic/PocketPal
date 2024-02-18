import 'package:hive/hive.dart';
import 'package:pocket_pal/interface/category_service.dart';
import 'package:pocket_pal/model/category.dart';

class PersistentCategoryService implements CategoryService {
  final Box box;

  PersistentCategoryService({required this.box});

  @override
  Future<void> deleteCategory(Category category) async {
    await box.delete(category.key);
  }

  @override
  Future<List<Category>> getCategories() async {
    return box.values.cast<Category>().toList();
  }

  @override
  Future<void> saveCategory(Category category) async {
    await box.add(category);
    await box.flush();
  }

  @override
  Future<void> updateCategory(Category category) async {
    await box.put(category.key, category);
    await box.flush();
  }

  Future<void> dispose() async => await box.close();
}
