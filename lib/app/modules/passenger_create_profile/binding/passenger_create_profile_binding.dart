import 'package:get/get.dart';

import '../controller/passenger_create_profile_controller.dart';

class PassengerCreateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerCreateProfileController>(
      PassengerCreateProfileController.new,
    );
  }
}
