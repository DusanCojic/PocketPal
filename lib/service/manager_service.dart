import 'package:pocket_pal/interface/data_service.dart';

class ManagerService {
  ManagerService._internal();
  static final ManagerService _singleton = ManagerService._internal();
  factory ManagerService() => _singleton;

  late DataService? _service;

  void initialize() {}

  DataService get service {
    if (_service == null) throw "Service not initialized";

    return _service!;
  }
}
