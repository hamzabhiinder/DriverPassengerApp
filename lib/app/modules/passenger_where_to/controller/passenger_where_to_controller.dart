import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/services/role_service.dart';
import '../../../routes/app_routes.dart';

class PassengerWhereToController extends GetxController {
  PassengerWhereToController() {
    pickupController = TextEditingController();
    destinationController = TextEditingController();
  }

  static final LatLng mapInitialCenter = LatLng(25.2048, 55.2708);

  static const double mapInitialZoom = 15;

  final MapController mapController = MapController();

  late final TextEditingController pickupController;
  late final TextEditingController destinationController;

  final RoleService _roleService = Get.find<RoleService>();

  void onRecenterMap() {
    mapController.move(mapInitialCenter, mapInitialZoom);
  }

  void onSelectVehicle() {
    Get.toNamed<void>(AppRoutes.passengerSelectVehicle);
  }

  void onScheduleTap() {
    Get.snackbar(
      'Schedule',
      'Scheduled rides — coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void onSavedTap() {
    Get.snackbar(
      'Saved',
      'Saved places — coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void onAirportTap() {
    Get.snackbar(
      'Airport',
      'Airport trips — coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> switchRole() async {
    await _roleService.clearRole();
    Get.offAllNamed<void>(AppRoutes.roleSelect);
  }

  @override
  void onClose() {
    mapController.dispose();
    pickupController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}
