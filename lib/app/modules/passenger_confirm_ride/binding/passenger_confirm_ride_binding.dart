import 'package:get/get.dart';

import '../controller/passenger_confirm_ride_controller.dart';

class PassengerConfirmRideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerConfirmRideController>(
      PassengerConfirmRideController.new,
    );
  }
}
