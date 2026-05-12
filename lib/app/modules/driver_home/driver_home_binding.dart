import 'package:get/get.dart';

import 'driver_home_controller.dart';

class DriverHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverHomeController>(DriverHomeController.new);
  }
}
