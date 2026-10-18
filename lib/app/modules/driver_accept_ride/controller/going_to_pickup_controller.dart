import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/ride_request_model.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';
import '../../chat/ride_chat_view.dart';

enum TripState {
  goingToPickup,
  waitingForPassenger,
  passengerOnboard,
  arrivedAtDestination,
}

class GoingToPickupController extends GetxController {
  late final RideRequestModel ride;
  final Rx<TripState> rxTripState = TripState.goingToPickup.obs;
  final RxBool rxIsBusy = false.obs;

  FirestoreService get _firestore => Get.find<FirestoreService>();
  FirebaseAuthService get _auth => Get.find<FirebaseAuthService>();

  LatLng get pickupLocation => LatLng(
        ride.pickupLat ?? 25.2048,
        ride.pickupLng ?? 55.2708,
      );

  String get primaryActionLabel {
    switch (rxTripState.value) {
      case TripState.goingToPickup:
        return 'Arrived at Pickup';
      case TripState.waitingForPassenger:
        return 'Passenger Onboard';
      case TripState.passengerOnboard:
        return 'Arrived at Destination';
      case TripState.arrivedAtDestination:
        return 'Complete Trip';
    }
  }

  String get statusTitle {
    switch (rxTripState.value) {
      case TripState.goingToPickup:
        return 'Going to pickup';
      case TripState.waitingForPassenger:
        return 'Waiting for passenger';
      case TripState.passengerOnboard:
        return 'Trip in progress';
      case TripState.arrivedAtDestination:
        return 'Arrived at destination';
    }
  }

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
        status: 'accepted',
        createdAt: null,
      );
    }
  }

  Future<void> handlePrimaryAction() async {
    if (rxIsBusy.value) {
      return;
    }
    rxIsBusy.value = true;
    try {
      switch (rxTripState.value) {
        case TripState.goingToPickup:
          await _updateStatus('arrived');
          rxTripState.value = TripState.waitingForPassenger;
          _showNotification(
            'Status Updated',
            '${ride.passengerName} has been notified of your arrival.',
          );
          break;
        case TripState.waitingForPassenger:
          await _updateStatus('onboard');
          rxTripState.value = TripState.passengerOnboard;
          _showNotification(
            'Trip Started',
            'Heading to ${ride.destinationLabel}',
          );
          break;
        case TripState.passengerOnboard:
          await _updateStatus('arrived_destination');
          rxTripState.value = TripState.arrivedAtDestination;
          _showNotification('Arrived!', 'You have arrived at the destination.');
          break;
        case TripState.arrivedAtDestination:
          final String? driverId = _auth.currentUser?.uid;
          if (ride.id.isNotEmpty && driverId != null) {
            await _firestore.completeRide(
              rideId: ride.id,
              driverId: driverId,
              fareUsd: ride.fareUsd,
            );
          }
          Get.offNamed(AppRoutes.driverTripCompleted, arguments: ride);
          break;
      }
    } on Object catch (error) {
      Get.snackbar(
        'Update failed',
        '$error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
        colorText: Colors.white,
      );
    } finally {
      rxIsBusy.value = false;
    }
  }

  Future<void> _updateStatus(String status) async {
    if (ride.id.isEmpty) {
      return;
    }
    await _firestore.updateRideStatus(ride.id, status);
  }

  void _showNotification(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> openGPS() async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${pickupLocation.latitude},${pickupLocation.longitude}',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open map application.');
    }
  }

  Future<void> callCustomer() async {
    final String phone =
        ride.passengerPhone.isEmpty ? '+971501234567' : ride.passengerPhone;
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void messageCustomer() {
    Get.toNamed(
      AppRoutes.rideChat,
      arguments: RideChatArgs(
        chatId: ride.id.isEmpty ? 'driver-support' : 'ride_${ride.id}',
        title: ride.passengerName,
        peerName: ride.passengerName,
      ),
    );
  }

  Future<void> reportNoShow() async {
    if (ride.id.isEmpty) {
      return;
    }
    await _firestore.updateRideStatus(ride.id, 'no_show');
    Get.offAllNamed(AppRoutes.driverHome);
    Get.snackbar(
      'No-show reported',
      'Trip closed. You are back on the dashboard.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }
}
