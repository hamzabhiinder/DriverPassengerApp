import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/services/directions_service.dart';
import '../../../data/services/driver_location_service.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/push_notification_service.dart';
import '../../../data/services/session_service.dart';
import '../../../routes/app_routes.dart';
import '../../passenger_trip_options/passenger_trip_options_view.dart';

class PassengerWhereToController extends GetxController {
  PassengerWhereToController() {
    pickupController = TextEditingController();
    destinationController = TextEditingController();
  }

  static final LatLng mapInitialCenter = LatLng(29.4241, -98.4936);

  static const double mapInitialZoom = 14;
  static const Duration _routePreviewDebounce = Duration(milliseconds: 650);

  final MapController mapController = MapController();
  final Rxn<LatLng> rxUserLocation = Rxn<LatLng>();
  final Rxn<LatLng> rxDestinationLocation = Rxn<LatLng>();
  final RxList<LatLng> rxRoutePoints = <LatLng>[].obs;
  final RxString rxEtaLabel = ''.obs;
  final RxBool rxIsPreviewingRoute = false.obs;

  late final TextEditingController pickupController;
  late final TextEditingController destinationController;
  Timer? _routePreviewTimer;
  int _previewRequestId = 0;

  @override
  void onInit() {
    super.onInit();
    destinationController.addListener(_onDestinationChanged);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _ensureSession();
    await locateUser();
    if (Get.isRegistered<PushNotificationService>()) {
      await Get.find<PushNotificationService>().refreshForCurrentUser();
    }
  }

  Future<void> _ensureSession() async {
    try {
      final FirebaseAuthService auth = Get.find<FirebaseAuthService>();
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
      final String? passengerId = auth.currentUser?.uid;
      if (passengerId == null) {
        return;
      }
      await Get.find<FirestoreService>().ensurePassengerProfile(
        passengerId: passengerId,
      );
    } on Object catch (error) {
      debugPrint('Passenger session sync skipped: $error');
    }
  }

  void _onDestinationChanged() {
    scheduleRoutePreview();
  }

  void scheduleRoutePreview() {
    _routePreviewTimer?.cancel();
    final String destination = destinationController.text.trim();
    if (destination.length < 4) {
      if (destination.isEmpty) {
        clearRoutePreview();
      }
      return;
    }
    _routePreviewTimer = Timer(_routePreviewDebounce, () {
      previewRouteIfPossible();
    });
  }

  void clearRoutePreview() {
    rxRoutePoints.clear();
    rxDestinationLocation.value = null;
    rxEtaLabel.value = '';
    rxIsPreviewingRoute.value = false;
  }

  Future<void> locateUser() async {
    final LatLng? point =
        await Get.find<DriverLocationService>().getCurrentLatLng();
    if (point == null) {
      return;
    }
    rxUserLocation.value = point;
    mapController.move(point, mapInitialZoom);
    final String? address =
        await Get.find<DirectionsService>().reverseGeocode(point);
    if (address != null && address.isNotEmpty) {
      pickupController.text = address;
    } else if (pickupController.text.trim().isEmpty) {
      pickupController.text = 'Current Location';
    }
  }

  void onRecenterMap() {
    final LatLng target = rxUserLocation.value ?? mapInitialCenter;
    mapController.move(target, mapInitialZoom);
    locateUser();
  }

  Future<void> previewRouteIfPossible() async {
    final String pickup = pickupController.text.trim();
    final String destination = destinationController.text.trim();
    if (destination.isEmpty) {
      clearRoutePreview();
      return;
    }
    final int requestId = ++_previewRequestId;
    rxIsPreviewingRoute.value = true;
    rxEtaLabel.value = 'Finding route…';
    final DirectionsService directions = Get.find<DirectionsService>();
    LatLng? origin = rxUserLocation.value;
    if (origin == null) {
      origin = await directions.geocode(
        pickup.isEmpty ? 'Current Location' : pickup,
      );
      if (origin != null) {
        rxUserLocation.value = origin;
      }
    }
    final LatLng? dest = await directions.geocode(destination);
    if (requestId != _previewRequestId) {
      return;
    }
    if (origin == null || dest == null) {
      rxIsPreviewingRoute.value = false;
      rxEtaLabel.value = 'Address not found';
      return;
    }
    rxDestinationLocation.value = dest;
    final DirectionsResult? route = await directions.fetchRoute(
      origin: origin,
      destination: dest,
    );
    if (requestId != _previewRequestId) {
      return;
    }
    rxIsPreviewingRoute.value = false;
    if (route == null || route.points.length < 2) {
      rxRoutePoints.assignAll(<LatLng>[origin, dest]);
      rxEtaLabel.value = 'Route ready';
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds(origin, dest),
          padding: const EdgeInsets.all(48),
        ),
      );
      return;
    }
    rxRoutePoints.assignAll(route.points);
    rxEtaLabel.value =
        '${route.durationMinutes} min · ${route.distanceKm.toStringAsFixed(1)} km';
    mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(route.points),
        padding: const EdgeInsets.all(48),
      ),
    );
  }

  String get _resolvedPickup {
    final String pickup = pickupController.text.trim();
    return pickup.isEmpty ? 'Current Location' : pickup;
  }

  Future<void> onSelectVehicle() async {
    await previewRouteIfPossible();
    Get.toNamed<void>(
      AppRoutes.passengerSelectVehicle,
      arguments: <String, dynamic>{
        'pickupLabel': _resolvedPickup,
        'destinationLabel': destinationController.text.trim().isEmpty
            ? 'Hotel Emma'
            : destinationController.text.trim(),
        'pickupLat': rxUserLocation.value?.latitude,
        'pickupLng': rxUserLocation.value?.longitude,
        'destinationLat': rxDestinationLocation.value?.latitude,
        'destinationLng': rxDestinationLocation.value?.longitude,
      },
    );
  }

  void onScheduleTap() {
    Get.toNamed(AppRoutes.passengerSchedule);
  }

  Future<void> onSavedTap() async {
    final Object? selected = await Get.toNamed(AppRoutes.passengerSavedPlaces);
    if (selected is String && selected.isNotEmpty) {
      destinationController.text = selected;
      await previewRouteIfPossible();
    }
  }

  void onAirportTap() {
    Get.toNamed(
      AppRoutes.passengerTripOptions,
      arguments: <String, dynamic>{
        'tripKind': PassengerTripKind.airport,
        'pickupLabel': _resolvedPickup,
      },
    );
  }

  void onHourlyTap() {
    Get.toNamed(
      AppRoutes.passengerTripOptions,
      arguments: <String, dynamic>{
        'tripKind': PassengerTripKind.hourly,
        'pickupLabel': _resolvedPickup,
      },
    );
  }

  void onRoundTripTap() {
    Get.toNamed(
      AppRoutes.passengerTripOptions,
      arguments: <String, dynamic>{
        'tripKind': PassengerTripKind.roundTrip,
        'pickupLabel': _resolvedPickup,
      },
    );
  }

  Future<void> switchRole() async {
    await Get.find<SessionService>().logout();
  }

  @override
  void onClose() {
    _routePreviewTimer?.cancel();
    destinationController.removeListener(_onDestinationChanged);
    mapController.dispose();
    pickupController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}
