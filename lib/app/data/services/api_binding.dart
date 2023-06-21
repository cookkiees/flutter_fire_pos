import 'package:get/get.dart';

import 'api_service.dart';

class ApiServiceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
  }
}
