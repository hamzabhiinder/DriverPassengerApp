import 'package:get/get.dart';

import '../controller/passenger_rate_ride_controller.dart';

class PassengerRateRideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerRateRideController>(PassengerRateRideController.new);
  }
}
