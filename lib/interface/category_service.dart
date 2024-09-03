import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';

abstract class CategoryService {
  Future<List<Category>> getCategories(Subscriber? sub);
  Future<bool> categoryExists(Category category);
  Future<void> saveCategory(Category category);
  Future<void> deleteCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<Category> getCategoryByName(String name);
  Future<Category> getCategoryById(int categoryId);
  void subscribe(Subscriber sub);
  void unsubscribe(Subscriber sub);
}
