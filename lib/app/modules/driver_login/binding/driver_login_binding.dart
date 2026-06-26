import 'package:driver_passenger_app/app/modules/driver_login/controller/driver_login_controller.dart'
    show DriverLoginController;
import 'package:get/get.dart';

class DriverLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverLoginController>(DriverLoginController.new);
  }
}
