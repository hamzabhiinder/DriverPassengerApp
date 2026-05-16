import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../models/rate_ride_args.dart';

class PassengerRateRideController extends GetxController {
  late final RateRideArgs args;

  final RxInt rating = 3.obs;
  final feedbackController = TextEditingController();
  final RxList<String> selectedTags = <String>[].obs;

  static const quickTags = <String>[
    'Professional',
    'Clean Vehicle',
    'On Time',
    'Safe Driving',
    'Friendly',
  ];

  @override
  void onInit() {
    super.onInit();
    args = RateRideArgs.fromArgs(Get.arguments);
  }

  void setRating(int stars) {
    if (stars >= 1 && stars <= 5) {
      rating.value = stars;
    }
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void onSubmitRating() {
    Get.offAllNamed<void>(AppRoutes.passengerWhereTo);
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      Get.snackbar(
        'Thanks',
        'Your feedback helps us improve.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    });
  }

  void onSkip() {
    Get.offAllNamed<void>(AppRoutes.passengerWhereTo);
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
