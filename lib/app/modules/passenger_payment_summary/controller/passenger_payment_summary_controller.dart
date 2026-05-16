import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../models/payment_summary_args.dart';

enum PassengerPaymentMethod { card, wallet }

class PassengerPaymentSummaryController extends GetxController {
  late final PaymentSummaryArgs args;

  final Rx<PassengerPaymentMethod> method =
      PassengerPaymentMethod.card.obs;

  @override
  void onInit() {
    super.onInit();
    args = PaymentSummaryArgs.fromArgs(Get.arguments);
  }

  void selectCard() => method.value = PassengerPaymentMethod.card;

  void selectWallet() => method.value = PassengerPaymentMethod.wallet;

  void onChangeCard() {
    Get.snackbar(
      'Payment',
      'Change card — connect your gateway here.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void onPay() {
    Get.offNamed<void>(
      AppRoutes.passengerRateRide,
      arguments: <String, dynamic>{
        'chauffeurName': args.chauffeurName,
      },
    );
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      Get.snackbar(
        'Payment',
        'Ride paid successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    });
  }
}
