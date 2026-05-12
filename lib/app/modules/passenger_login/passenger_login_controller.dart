import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class PassengerLoginController extends GetxController {
  final phoneController = TextEditingController();

  void sendOtp() {
    final raw = phoneController.text.trim();
    if (raw.isEmpty) {
      Get.snackbar(
        'Phone number',
        'Enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    // TODO: integrate OTP API; navigate after success.
    Get.offAllNamed<void>(AppRoutes.passengerHome);
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
