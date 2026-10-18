import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../data/models/driver_profile_model.dart';
import '../../data/models/ride_request_model.dart';
import '../../data/services/driver_location_service.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../routes/app_routes.dart';

class DriverHomeController extends GetxController {
  final RxBool rxIsOnline = false.obs;
  final RxBool rxIsUpdatingStatus = false.obs;
  final RxInt rxTabIndex = 0.obs;
  final Rxn<DriverProfileModel> rxProfile = Rxn<DriverProfileModel>();
  final RxList<RideRequestModel> rxTrips = <RideRequestModel>[].obs;

  final LatLng initialMapCenter = const LatLng(25.2048, 55.2708);
  StreamSubscription<List<RideRequestModel>>? _rideRequestsSubscription;
  StreamSubscription<DriverProfileModel?>? _profileSubscription;
  StreamSubscription<List<RideRequestModel>>? _tripsSubscription;
  final Set<String> _presentedRideIds = <String>{};

  FirebaseAuthService get _auth => Get.find<FirebaseAuthService>();
  FirestoreService get _firestore => Get.find<FirestoreService>();
  DriverLocationService get _location => Get.find<DriverLocationService>();

  String get driverId => _auth.currentUser?.uid ?? '';

  String get earningsLabel {
    final double value = rxProfile.value?.earningsTodayUsd ?? 0;
    return '\$${value.toStringAsFixed(2)}';
  }

  String get ridesLabel => '${rxProfile.value?.ridesCompleted ?? 0}';

  String get hoursLabel {
    final double hours = rxProfile.value?.hoursOnlineToday ?? 0;
    return hours.toStringAsFixed(1);
  }

  String get acceptanceLabel {
    final double rate = rxProfile.value?.acceptanceRate ?? 100;
    return '${rate.toStringAsFixed(0)}%';
  }

  String get displayName => rxProfile.value?.displayName ?? 'Driver';

  LatLng get mapCenter =>
      _location.rxCurrentLocation.value ?? initialMapCenter;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      return;
    }
    await _firestore.ensureDriverProfile(
      driverId: uid,
      email: _auth.currentUser?.email ?? '',
      displayName: _auth.currentUser?.email?.split('@').first,
    );
    _profileSubscription =
        _firestore.watchDriverProfile(uid).listen((DriverProfileModel? profile) {
      rxProfile.value = profile;
      if (profile != null) {
        rxIsOnline.value = profile.isOnline;
      }
    });
    _tripsSubscription =
        _firestore.watchDriverTrips(uid).listen((List<RideRequestModel> trips) {
      rxTrips.assignAll(trips);
    });
    final DriverProfileModel? profile = await _firestore.getDriverProfile(uid);
    if (profile?.isOnline == true) {
      rxIsOnline.value = true;
      await _startOnlineSession(showSnack: false);
    }
  }

  Future<void> toggleOnlineStatus() async {
    if (rxIsUpdatingStatus.value) {
      return;
    }
    if (driverId.isEmpty) {
      Get.snackbar(
        'Not signed in',
        'Please log in again to go online.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
        colorText: Colors.white,
      );
      return;
    }
    final bool nextIsOnline = !rxIsOnline.value;
    rxIsOnline.value = nextIsOnline;
    rxIsUpdatingStatus.value = true;
    try {
      if (nextIsOnline) {
        await _startOnlineSession(showSnack: true);
      } else {
        await _stopOnlineSession(showSnack: true);
      }
    } on Object catch (error) {
      rxIsOnline.value = !nextIsOnline;
      Get.snackbar(
        'Could not update status',
        '$error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
        colorText: Colors.white,
      );
    } finally {
      rxIsUpdatingStatus.value = false;
    }
  }

  Future<void> _startOnlineSession({required bool showSnack}) async {
    final LatLng? current = await _location.getCurrentLatLng();
    await _firestore.updateDriverStatus(
      driverId,
      true,
      lat: (current ?? initialMapCenter).latitude,
      lng: (current ?? initialMapCenter).longitude,
    );
    await _location.startTracking();
    await _rideRequestsSubscription?.cancel();
    _rideRequestsSubscription = _firestore
        .listenToPendingRideRequests(driverId)
        .listen(_handleRideRequests);
    if (showSnack) {
      Get.snackbar(
        'You are online',
        'Listening for ride requests.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB88E2F),
        colorText: Colors.black,
      );
    }
  }

  Future<void> _stopOnlineSession({required bool showSnack}) async {
    await _location.stopTracking();
    await _rideRequestsSubscription?.cancel();
    _rideRequestsSubscription = null;
    _presentedRideIds.clear();
    await _firestore.updateDriverStatus(driverId, false);
    if (showSnack) {
      Get.snackbar(
        'You are offline',
        'Status saved in Firebase.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB88E2F),
        colorText: Colors.black,
      );
    }
  }

  void _handleRideRequests(List<RideRequestModel> rides) {
    if (rides.isEmpty || !rxIsOnline.value) {
      return;
    }
    final RideRequestModel ride = rides.first;
    if (_presentedRideIds.contains(ride.id)) {
      return;
    }
    if (Get.currentRoute.contains('new-ride') ||
        Get.currentRoute.contains('going-to-pickup') ||
        Get.currentRoute.contains('trip-completed')) {
      return;
    }
    _presentedRideIds.add(ride.id);
    Get.toNamed(AppRoutes.driverNewRideRequest, arguments: ride);
  }

  Future<void> simulateIncomingRide() async {
    if (driverId.isEmpty) {
      return;
    }
    final LatLng center = mapCenter;
    final String rideId = await _firestore.createRideRequest(
      preferredDriverId: driverId,
      ride: RideRequestModel(
        id: '',
        passengerId: 'sim-passenger',
        passengerName: 'Sarah Johnson',
        passengerPhone: '+971501234567',
        pickupLabel: 'Current Location',
        destinationLabel: '12280 Westheimer Rd #5, Houston, TX',
        vehicleCategory: 'VIP SUV',
        fareUsd: 120,
        etaMinutes: 5,
        tripType: 'Airport Transfer',
        status: 'pending',
        createdAt: DateTime.now(),
        notes: 'Flight AA1234. Soft drinks preferred.',
        pickupLat: center.latitude,
        pickupLng: center.longitude,
        destinationLat: center.latitude + 0.02,
        destinationLng: center.longitude + 0.02,
        distanceKm: 12.4,
        bookingCode: '#BL-${DateTime.now().millisecondsSinceEpoch % 10000}',
      ),
    );
    Get.snackbar(
      'Test request created',
      'Ride $rideId queued for you.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }

  void selectTab(int index) {
    rxTabIndex.value = index;
  }

  void openTrips() => selectTab(1);

  void openEarnings() => selectTab(2);

  void openAccount() => selectTab(3);

  @override
  void onClose() {
    _rideRequestsSubscription?.cancel();
    _profileSubscription?.cancel();
    _tripsSubscription?.cancel();
    super.onClose();
  }
}
