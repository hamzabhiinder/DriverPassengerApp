import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../passenger_where_to/controller/passenger_where_to_controller.dart';
import '../models/vehicle_option.dart';

class PassengerSelectVehicleController extends GetxController {
  static const _car1 = 'assets/images/car_image.png';
  static const _car2 = 'assets/images/car2_image.png';

  final RxInt selectedIndex = 0.obs;

  late final List<VehicleOption> vehicles;

  @override
  void onInit() {
    super.onInit();
    vehicles = const [
      VehicleOption(
        categoryLabel: 'Executive Sedan',
        name: 'BMW i5 or Similar',
        luggageLabel: '2 large suitcases',
        passengersLabel: 'Passengers: 1–3',
        priceLabel: '\$120',
        imageAsset: _car1,
      ),
      VehicleOption(
        categoryLabel: 'Elite SUV',
        name: 'Chevrolet Tahoe or Similar',
        luggageLabel: '4 large suitcases',
        passengersLabel: 'Passengers: 1–6',
        priceLabel: '\$180',
        imageAsset: _car2,
      ),
      VehicleOption(
        categoryLabel: 'VIP SUV',
        name: 'Mercedes-Maybach GLS or Similar',
        luggageLabel: '4 large suitcases',
        passengersLabel: 'Passengers: 1–4',
        priceLabel: '\$220',
        imageAsset: _car2,
      ),
    ];
  }

  void selectVehicle(int index) {
    if (index >= 0 && index < vehicles.length) {
      selectedIndex.value = index;
    }
  }

  void onContinue() {
    final v = vehicles[selectedIndex.value];
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
