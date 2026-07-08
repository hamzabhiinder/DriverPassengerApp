import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../passenger_where_to/controller/passenger_where_to_controller.dart';
import '../models/vehicle_option.dart';

class PassengerSelectVehicleController extends GetxController {
  static const _car1 = 'assets/images/car_image.png';
  static const _car2 = 'assets/images/car2_image.png';

  final selectedIndex = Rxn<int>();
  final rxShowPartyBuses = false.obs;

  final List<VehicleOption> _standardSUVs = const [
    VehicleOption(
      categoryLabel: 'Executive Sedan',
      name: 'BMW i5 or Similar',
      luggageLabel: '2 large suitcases',
      passengersLabel: 'Passengers: 1â€“3',
      priceLabel: '\$120',
      imageAsset: _car1,
    ),
    VehicleOption(
      categoryLabel: 'Elite SUV',
      name: 'Chevrolet Tahoe or Similar',
      luggageLabel: '4 large suitcases',
      passengersLabel: 'Passengers: 1â€“6',
      priceLabel: '\$180',
      imageAsset: _car2,
    ),
    VehicleOption(
      categoryLabel: 'VIP SUV',
      name: 'Mercedes-Maybach GLS or Similar',
      luggageLabel: '4 large suitcases',
      passengersLabel: 'Passengers: 1â€“4',
      priceLabel: '\$220',
      imageAsset: _car2,
    ),
  ];

  final List<VehicleOption> _partyBuses = const [
    VehicleOption(
      categoryLabel: 'VIP Party Sprinter',
      name: 'Mercedes-Benz Sprinter',
      luggageLabel: 'Varies',
      passengersLabel: 'Passengers: 6â€“14',
      priceLabel: '\$299',
      imageAsset:
          'assets/images/sprinter.png',
    ),
    VehicleOption(
      categoryLabel: 'Ultimate Party Bus',
      name: 'Luxury Party Bus',
      luggageLabel: 'Amenities included',
      passengersLabel: 'Passengers: 12â€“22',
      priceLabel: '\$399',
      imageAsset: 'assets/images/sprinter.png',
    ),
  ];

  List<VehicleOption> get activeVehicles =>
      rxShowPartyBuses.value ? _partyBuses : _standardSUVs;

  @override
  void onInit() {
    super.onInit();
    selectedIndex.value = null;
  }

  void selectVehicle(int index) {
    if (index >= 0 && index < activeVehicles.length) {
      selectedIndex.value = index;
    }
  }

  void togglePartyBusView() {
    rxShowPartyBuses.value = !rxShowPartyBuses.value;
    selectedIndex.value = null;
  }

  void onContinue() {
    if (selectedIndex.value == null) {
      Get.snackbar(
        'Selection Required',
        'Please choose your premium ride to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB88E2F).withOpacity(0.9),
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final index = selectedIndex.value!;
    if (index >= activeVehicles.length) {
      selectedIndex.value = null;
      return;
    }

    final v = activeVehicles[index];
    final base = _parseUsdFromLabel(v.priceLabel);

    String pickup = 'Current Location';
    String destination = '12280 Westheimer Rd #5';

    if (Get.isRegistered<PassengerWhereToController>()) {
      final w = Get.find<PassengerWhereToController>();
      final p = w.pickupController.text.trim();
      final d = w.destinationController.text.trim();
      if (p.isNotEmpty) {
        pickup = p;
      }
      if (d.isNotEmpty) {
        destination = d;
      }
    }

    Get.offNamed<void>(
      AppRoutes.passengerConfirmRide,
      arguments: <String, dynamic>{
        'pickupLabel': pickup,
        'destinationLabel': destination,
        'vehicleCategory': v.categoryLabel,
        'vehicleName': v.name,
        'vehicleImageAsset': v.imageAsset,
        'baseFareUsd': base,
        'serviceFeeUsd': 5,
        'etaMinutes': 5,
      },
    );
  }

  static int _parseUsdFromLabel(String priceLabel) {
    final digits = priceLabel.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 120;
  }
}
