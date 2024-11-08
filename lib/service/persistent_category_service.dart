import 'package:hive/hive.dart';
import 'package:pocket_pal/interface/category_service.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/observable.dart';
import 'package:pocket_pal/service/manager_service.dart';

class PersistentCategoryService implements CategoryService {
  final Box box;
  Observable categoriesChangeNotifier = Observable();

  PersistentCategoryService({required this.box});

  @override
  Future<void> deleteCategory(Category category) async {
    Category uncategorized = await getCategoryByName("Uncategorized");
    await ManagerService().service.getExpenseService().replaceCategory(
          category,
          uncategorized,
        );
    await box.delete(category.key);
    categoriesChangeNotifier.notifySubscribers();
  }

  @override
  Future<List<Category>> getCategories(Subscriber? sub) async {
    if (sub != null) categoriesChangeNotifier.subscribe(sub);
    return box.values.cast<Category>().toList();
  }

  @override
  Future<bool> categoryExists(Category category) async {
    List<Category> categories = await getCategories(null);
    return categories.any((element) => element.name == category.name);
  }

  @override
  Future<void> saveCategory(Category category) async {
    if (await categoryExists(category)) return;
    await box.add(category);
    await box.flush();
    categoriesChangeNotifier.notifySubscribers();
  }

  @override
  Future<void> updateCategory(Category category) async {
    await box.put(category.key, category);
    await box.flush();
    categoriesChangeNotifier.notifySubscribers();
  }

  @override
  Future<Category> getCategoryByName(String name) async {
    return box.values
        .cast<Category>()
        .toList()
        .firstWhere((element) => element.name == name);
  }

  @override
  Future<Category> getCategoryById(int categoryId) async {
    return await box.get(categoryId);
  }

  Future<void> dispose() async => await box.close();

  @override
  void subscribe(Subscriber sub) {
    categoriesChangeNotifier.subscribe(sub);
  }

  @override
  void unsubscribe(Subscriber sub) {
    categoriesChangeNotifier.unsubscribe(sub);
  }
}
