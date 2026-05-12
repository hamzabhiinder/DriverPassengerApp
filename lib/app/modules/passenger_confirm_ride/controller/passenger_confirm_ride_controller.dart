import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/confirm_ride_args.dart';

class PassengerConfirmRideController extends GetxController {
  late final ConfirmRideArgs args;

  static const paymentSummary = 'Credit Card';
  static const paymentMask = '**** **** **** 4242';

  @override
  void onInit() {
    super.onInit();
    args = ConfirmRideArgs.fromArgs(Get.arguments);
  }

  void onChangePayment() {
    Get.snackbar(
      'Payment',
      'Change payment — connect your gateway here.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void onConfirmBooking() {
    Get.back<void>();
    Future<void>.microtask(() {
      Get.snackbar(
        'Booking',
        'Your ride is confirmed.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    });
  }
}
