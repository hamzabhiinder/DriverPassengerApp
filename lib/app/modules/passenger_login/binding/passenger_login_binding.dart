import 'package:get/get.dart';

import '../controller/passenger_login_controller.dart';

class PassengerLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerLoginController>(PassengerLoginController.new);
  }
}
