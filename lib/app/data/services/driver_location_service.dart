import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'firebase_auth_service.dart';
import 'firestore_service.dart';

class DriverLocationService extends GetxService {
  StreamSubscription<Position>? _positionSubscription;
  final Rxn<LatLng> rxCurrentLocation = Rxn<LatLng>();

  Future<bool> ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<LatLng?> getCurrentLatLng() async {
    final bool hasPermission = await ensurePermission();
    if (!hasPermission) {
      return null;
    }
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    final LatLng latLng = LatLng(position.latitude, position.longitude);
    rxCurrentLocation.value = latLng;
    return latLng;
  }

  Future<void> startTracking() async {
    final bool hasPermission = await ensurePermission();
    if (!hasPermission) {
      return;
    }
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 25,
      ),
    ).listen(_onPosition);
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<void> _onPosition(Position position) async {
    final LatLng latLng = LatLng(position.latitude, position.longitude);
    rxCurrentLocation.value = latLng;
    if (!Get.isRegistered<FirebaseAuthService>() ||
        !Get.isRegistered<FirestoreService>()) {
      return;
    }
    final String? driverId = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (driverId == null) {
      return;
    }
    await Get.find<FirestoreService>().updateDriverLocation(
      driverId,
      lat: position.latitude,
      lng: position.longitude,
    );
  }

  @override
  void onClose() {
    _positionSubscription?.cancel();
    super.onClose();
  }
}
