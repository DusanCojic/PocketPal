import 'package:pocket_pal/model/category.dart';

abstract class CategoryService {
  Future<List<Category>> getCategories();
  Future<void> saveCategory(Category category);
  Future<void> deleteCategory(Category category);
  Future<void> updateCategory(Category category);
}
