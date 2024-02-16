import 'package:pocket_pal/interface/data_service.dart';
import 'package:pocket_pal/service/persistent_data.service.dart';

class ManagerService {
  ManagerService._internal();
  static final ManagerService _singleton = ManagerService._internal();
  factory ManagerService() => _singleton;

  late DataService? _service;

  Future<void> initialize() async {
    _service = PersistentDataService();
    await _service?.initialize();
  }

  DataService get service {
    if (_service == null) throw "Service not initialized";

    return _service!;
  }
}
