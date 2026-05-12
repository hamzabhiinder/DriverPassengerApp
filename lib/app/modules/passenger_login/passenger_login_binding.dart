import 'package:get/get.dart';

import 'passenger_login_controller.dart';

class PassengerLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerLoginController>(PassengerLoginController.new);
  }
}
