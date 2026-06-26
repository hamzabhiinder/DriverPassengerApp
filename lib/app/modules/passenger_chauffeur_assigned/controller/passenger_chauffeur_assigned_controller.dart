import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class PassengerChauffeurAssignedController extends GetxController {
  final MapController mapController = MapController();

  late final String vehicleModel;
  late final String chauffeurName;
  late final int baseFareUsd;
  late final int serviceFeeUsd;
  late final String cardMask;

  static const kChauffeurName = 'James Robert';
  static const plate = 'DXB 1234';
  static const ratingFilled = 4;

  @override
  void onInit() {
    super.onInit();
    final raw = Get.arguments;
    if (raw is Map) {
      vehicleModel = raw['vehicleModel'] as String? ?? 'BMW i5';
      chauffeurName =
          raw['chauffeurName'] as String? ?? kChauffeurName;
      baseFareUsd = (raw['baseFareUsd'] as num?)?.toInt() ?? 120;
      serviceFeeUsd = (raw['serviceFeeUsd'] as num?)?.toInt() ?? 5;
      cardMask = raw['cardMask'] as String? ?? '**** **** **** 4242';
    } else {
      vehicleModel = 'BMW i5';
      chauffeurName = kChauffeurName;
      baseFareUsd = 120;
      serviceFeeUsd = 5;
      cardMask = '**** **** **** 4242';
    }
  }

  void onCall() {
    Get.snackbar(
      'Call',
      'Dial chauffeur — plug VoIP / tel: here.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void onMessage() {
    Get.snackbar(
      'Message',
      'Open chat — coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void onRideComplete() {
    Get.offNamed<void>(
      AppRoutes.passengerPaymentSummary,
      arguments: <String, dynamic>{
        'baseFareUsd': baseFareUsd,
        'serviceFeeUsd': serviceFeeUsd,
        'cardMask': cardMask,
        'chauffeurName': chauffeurName,
      },
    );
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
