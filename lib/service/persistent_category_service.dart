import 'package:hive/hive.dart';
import 'package:pocket_pal/interface/category_service.dart';
import 'package:pocket_pal/interface/subscriber.dart';
import 'package:pocket_pal/model/category.dart';
import 'package:pocket_pal/model/observable.dart';

class PersistentCategoryService implements CategoryService {
  final Box box;
  Observable categoriesChangeNotifier = Observable();

  PersistentCategoryService({required this.box});

  @override
  Future<void> deleteCategory(Category category) async {
    await box.delete(category.key);
    categoriesChangeNotifier.notifySubscribers();
  }

  @override
  Future<List<Category>> getCategories(Subscriber? sub) async {
    if (sub != null) categoriesChangeNotifier.subscribe(sub);
    return box.values.cast<Category>().toList();
  }

  @override
  Future<void> saveCategory(Category category) async {
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
