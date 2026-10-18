import 'package:get/get.dart';

import '../../../data/models/ride_request_model.dart';
import '../../../routes/app_routes.dart';

class TripCompletedController extends GetxController {
  late final RideRequestModel ride;

  String get fareLabel => '\$${ride.fareUsd.toStringAsFixed(0)}';

  @override
  void onInit() {
    super.onInit();
    final Object? args = Get.arguments;
    if (args is RideRequestModel) {
      ride = args;
    } else {
      ride = const RideRequestModel(
        id: '',
        passengerId: '',
        passengerName: 'Passenger',
        passengerPhone: '',
        pickupLabel: 'Pickup',
        destinationLabel: 'Destination',
        vehicleCategory: 'VIP SUV',
        fareUsd: 0,
        etaMinutes: 5,
        tripType: 'Ride',
        status: 'completed',
        createdAt: null,
      );
    }
  }

  void continueDriving() {
    Get.offAllNamed(AppRoutes.driverHome);
  }
}
