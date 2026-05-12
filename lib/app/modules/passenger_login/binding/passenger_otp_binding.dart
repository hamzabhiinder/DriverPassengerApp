import 'package:get/get.dart';

import '../controller/passenger_login_controller.dart';
 
class PassengerOtpBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PassengerLoginController>()) {
      Get.lazyPut<PassengerLoginController>(PassengerLoginController.new);
    }
  }
}
