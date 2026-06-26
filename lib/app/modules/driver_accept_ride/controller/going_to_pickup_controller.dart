import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../driver_trip_complete/screen/trip_completed.dart'
    show TripCompletedView;

enum TripState {
  goingToPickup,
  waitingForPassenger,
  passengerOnboard,
  arrivedAtDestination,
}

class GoingToPickupController extends GetxController {
  final rxTripState = TripState.goingToPickup.obs;

  final pickupLocation = const LatLng(25.2048, 55.2708);

  void handlePrimaryAction() {
    switch (rxTripState.value) {
      case TripState.goingToPickup:
        rxTripState.value = TripState.waitingForPassenger;
        _showNotification(
          'Status Updated',
          'Sarah Johnson has been notified of your arrival.',
        );
        break;
      case TripState.waitingForPassenger:
        rxTripState.value = TripState.passengerOnboard;
        _showNotification(
          'Trip Started',
          'Heading to destination: 12280 Westheimer Rd #5',
        );
        break;
      case TripState.passengerOnboard:
        rxTripState.value = TripState.arrivedAtDestination;
        _showNotification('Arrived!', 'You have arrived at the destination.');
        break;
      case TripState.arrivedAtDestination:
        Get.off(() => const TripCompletedView());
        break;
    }
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

  void arrivedAtPickup() {
    Get.snackbar(
      'Status Updated',
      'Sarah Johnson has been notified of your arrival.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }

  void openGPS() async {
    final googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${pickupLocation.latitude},${pickupLocation.longitude}",
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open map application.');
    }
  }

  void callCustomer() async {
    final phoneUri = Uri(scheme: 'tel', path: '+971501234567');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void messageCustomer() {
    Get.snackbar('Chat', 'Opening secure chat with Sarah Johnson...');
  }
}
