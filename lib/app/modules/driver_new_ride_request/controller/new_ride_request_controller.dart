import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/ride_request_model.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';

class NewRideRequestController extends GetxController {
  late final RideRequestModel ride;
  final RxInt rxRemainingSeconds = 15.obs;
  final RxBool rxIsBusy = false.obs;
  Timer? _timer;

  FirestoreService get _firestore => Get.find<FirestoreService>();
  FirebaseAuthService get _auth => Get.find<FirebaseAuthService>();

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
        status: 'pending',
        createdAt: null,
      );
    }
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (rxRemainingSeconds.value > 0) {
        rxRemainingSeconds.value--;
      } else {
        _timer?.cancel();
        declineRide(isTimeout: true);
      }
    });
  }

  Future<void> acceptRide() async {
    if (rxIsBusy.value || ride.id.isEmpty) {
      return;
    }
    rxIsBusy.value = true;
    _timer?.cancel();
    try {
      final String? driverId = _auth.currentUser?.uid;
      await _firestore.updateRideStatus(
        ride.id,
        'accepted',
        driverId: driverId,
      );
      Get.offNamed(AppRoutes.driverGoingToPickup, arguments: ride);
    } on Object catch (error) {
      Get.snackbar(
        'Accept failed',
        '$error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
        colorText: Colors.white,
      );
    } finally {
      rxIsBusy.value = false;
    }
  }

  Future<void> declineRide({bool isTimeout = false}) async {
    if (rxIsBusy.value) {
      return;
    }
    rxIsBusy.value = true;
    _timer?.cancel();
    try {
      if (ride.id.isNotEmpty) {
        await _firestore.updateRideStatus(ride.id, 'declined');
      }
      Get.back<void>();
      if (isTimeout) {
        Get.snackbar(
          'Request expired',
          'The ride request timed out.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on Object catch (error) {
      Get.back<void>();
      Get.snackbar('Decline failed', '$error');
    } finally {
      rxIsBusy.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
