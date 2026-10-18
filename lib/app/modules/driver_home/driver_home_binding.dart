import 'package:get/get.dart';

import '../driver_account/driver_account_view.dart';
import '../driver_earnings/driver_earnings_view.dart';
import '../driver_trips/driver_trips_view.dart';
import 'driver_home_controller.dart';

class DriverHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverHomeController>(DriverHomeController.new);
    Get.lazyPut<DriverTripsController>(DriverTripsController.new, fenix: true);
    Get.lazyPut<DriverEarningsController>(
      DriverEarningsController.new,
      fenix: true,
    );
    Get.lazyPut<DriverAccountController>(
      DriverAccountController.new,
      fenix: true,
    );
  }
}
