import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

class PassengerChauffeurAssignedController extends GetxController {  final MapController mapController = MapController();

  /// Shown under chauffeur name (from booking confirm args when passed).
  late final String vehicleModel;

  static const chauffeurName = 'James Robert';
  static const plate = 'DXB 1234';
  static const ratingFilled = 4;

  @override
  void onInit() {
    super.onInit();
    final raw = Get.arguments;
    if (raw is Map && raw['vehicleModel'] != null) {
      vehicleModel = raw['vehicleModel'] as String;
    } else {
      vehicleModel = 'BMW i5';
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

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
