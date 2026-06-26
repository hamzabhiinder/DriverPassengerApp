import 'dart:async';
import 'package:get/get.dart';

import '../../driver_accept_ride/screen/going_to_pickup.dart'
    show GoingToPickupView;

class NewRideRequestController extends GetxController {
  final rxRemainingSeconds = 15.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (rxRemainingSeconds.value > 0) {
        rxRemainingSeconds.value--;
      } else {
        _timer?.cancel();
        declineRide();
      }
    });
  }

  void acceptRide() {
    _timer?.cancel();

    Get.off(() => const GoingToPickupView());
  }

  void declineRide() {
    _timer?.cancel();
    Get.back();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
