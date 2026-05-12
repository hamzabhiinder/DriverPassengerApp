import 'package:get/get.dart';

import '../controller/passenger_select_vehicle_controller.dart';

class PassengerSelectVehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerSelectVehicleController>(
      PassengerSelectVehicleController.new,
    );
  }
}
