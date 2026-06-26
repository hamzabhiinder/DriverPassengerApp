import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../driver_new_ride_request/screen/driver_new_ride_request.dart'
    show NewRideRequestView;

class DriverHomeController extends GetxController {
  final rxIsOnline = false.obs;

  final rxEarnings = '\$425.00'.obs;
  final rxRidesCompleted = '23'.obs;
  final rxHoursOnline = '12'.obs;

  final initialMapCenter = const LatLng(25.2048, 55.2708);

  void toggleOnlineStatus() {
    rxIsOnline.value = !rxIsOnline.value;

    if (rxIsOnline.value) {
      Future.delayed(const Duration(seconds: 3), () {
        if (rxIsOnline.value) {
          Get.to(() => const NewRideRequestView());
        }
      });
    }
  }
}
