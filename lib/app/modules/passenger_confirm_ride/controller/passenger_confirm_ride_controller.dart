import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
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
    Get.toNamed<void>(
      AppRoutes.passengerPaymentSummary,
      arguments: <String, dynamic>{
        'vehicleModel': args.vehicleName,
        'baseFareUsd': args.baseFareUsd,
        'serviceFeeUsd': args.serviceFeeUsd,
        'cardMask': paymentMask,
        'pickupLabel': args.pickupLabel,
        'destinationLabel': args.destinationLabel,
        'vehicleCategory': args.vehicleCategory,
        'etaMinutes': args.etaMinutes,
      },
    );
  }
}
