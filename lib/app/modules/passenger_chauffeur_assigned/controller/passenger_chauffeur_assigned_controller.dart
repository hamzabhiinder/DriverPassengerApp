import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/ride_request_model.dart';
import '../../../data/services/directions_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';
import '../../chat/ride_chat_view.dart';
import '../../passenger_where_to/controller/passenger_where_to_controller.dart';

class PassengerChauffeurAssignedController extends GetxController {
  final MapController mapController = MapController();

  late final String vehicleModel;
  late final String chauffeurName;
  late final int baseFareUsd;
  late final int serviceFeeUsd;
  late final String cardMask;
  late final String rideId;
  late final String pickupLabel;
  late final String destinationLabel;

  static const kChauffeurName = 'James Robert';
  static const plate = 'DXB 1234';
  static const ratingFilled = 4;

  final RxString rxChauffeurName = kChauffeurName.obs;
  final RxString rxVehicleModel = 'BMW i5'.obs;
  final RxString rxPlate = plate.obs;
  final RxString rxStatus = 'pending'.obs;
  final RxString rxPhone = '+971501234567'.obs;
  final Rxn<LatLng> rxDriverLocation = Rxn<LatLng>();
  final Rxn<LatLng> rxPickupLocation = Rxn<LatLng>();
  final Rxn<LatLng> rxDestinationLocation = Rxn<LatLng>();
  final RxList<LatLng> rxTripRoutePoints = <LatLng>[].obs;
  final RxList<LatLng> rxDriverRoutePoints = <LatLng>[].obs;
  final RxList<LatLng> rxNearbyDrivers = <LatLng>[].obs;
  final RxString rxEtaLabel = ''.obs;
  final RxBool rxHasAssignedDriver = false.obs;
  String? _watchedDriverId;
  StreamSubscription<List<Map<String, dynamic>>>? _nearbySub;
  StreamSubscription<RideRequestModel?>? _rideSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _driverSub;

  /// Kept for older map code that still reads a single route list.
  RxList<LatLng> get rxRoutePoints =>
      rxDriverRoutePoints.isNotEmpty ? rxDriverRoutePoints : rxTripRoutePoints;

  @override
  void onInit() {
    super.onInit();
    final Object? raw = Get.arguments;
    if (raw is Map) {
      vehicleModel = raw['vehicleModel'] as String? ?? 'BMW i5';
      chauffeurName = raw['chauffeurName'] as String? ?? kChauffeurName;
      baseFareUsd = (raw['baseFareUsd'] as num?)?.toInt() ?? 120;
      serviceFeeUsd = (raw['serviceFeeUsd'] as num?)?.toInt() ?? 5;
      cardMask = raw['cardMask'] as String? ?? '**** **** **** 4242';
      rideId = raw['rideId'] as String? ?? 'general';
      pickupLabel = raw['pickupLabel'] as String? ?? 'Pickup';
      destinationLabel = raw['destinationLabel'] as String? ?? 'Destination';
      final double? pickupLat = (raw['pickupLat'] as num?)?.toDouble();
      final double? pickupLng = (raw['pickupLng'] as num?)?.toDouble();
      final double? destinationLat = (raw['destinationLat'] as num?)?.toDouble();
      final double? destinationLng = (raw['destinationLng'] as num?)?.toDouble();
      if (pickupLat != null && pickupLng != null) {
        rxPickupLocation.value = LatLng(pickupLat, pickupLng);
      }
      if (destinationLat != null && destinationLng != null) {
        rxDestinationLocation.value = LatLng(destinationLat, destinationLng);
      }
    } else {
      vehicleModel = 'BMW i5';
      chauffeurName = kChauffeurName;
      baseFareUsd = 120;
      serviceFeeUsd = 5;
      cardMask = '**** **** **** 4242';
      rideId = 'general';
      pickupLabel = 'Pickup';
      destinationLabel = 'Destination';
    }
    rxChauffeurName.value = chauffeurName;
    rxVehicleModel.value = vehicleModel;
    _bootstrapMap();
    _watchRide();
    _watchNearbyDrivers();
  }

  String get statusLabel {
    if (rxStatus.value == 'pending' && rxHasAssignedDriver.value) {
      return 'Chauffeur notified';
    }
    return switch (rxStatus.value) {
      'pending' => 'Finding chauffeur',
      'accepted' => 'Chauffeur assigned',
      'arriving' => 'Chauffeur arriving',
      'started' => 'Trip in progress',
      'completed' => 'Trip completed',
      'cancelled' => 'Ride cancelled',
      'scheduled' => 'Ride scheduled',
      _ => 'Chauffeur assigned',
    };
  }

  Future<void> _bootstrapMap() async {
    await _resolveMissingCoordinates();
    await _drawTripRoute();
    _fitMapToTrip();
  }

  Future<void> _resolveMissingCoordinates() async {
    final DirectionsService directions = Get.find<DirectionsService>();
    if (rxPickupLocation.value == null) {
      final LatLng? pickup = await directions.geocode(pickupLabel);
      rxPickupLocation.value =
          pickup ?? PassengerWhereToController.mapInitialCenter;
    }
    if (rxDestinationLocation.value == null) {
      final LatLng? dest = await directions.geocode(destinationLabel);
      if (dest != null) {
        rxDestinationLocation.value = dest;
      } else {
        final LatLng pickup =
            rxPickupLocation.value ?? PassengerWhereToController.mapInitialCenter;
        rxDestinationLocation.value = LatLng(
          pickup.latitude + 0.02,
          pickup.longitude + 0.015,
        );
      }
    }
  }

  Future<void> _drawTripRoute() async {
    final LatLng? pickup = rxPickupLocation.value;
    final LatLng? destination = rxDestinationLocation.value;
    if (pickup == null || destination == null) {
      return;
    }
    final DirectionsResult? route =
        await Get.find<DirectionsService>().fetchRoute(
      origin: pickup,
      destination: destination,
    );
    if (route == null || route.points.length < 2) {
      rxTripRoutePoints.assignAll(<LatLng>[pickup, destination]);
      if (!rxHasAssignedDriver.value) {
        rxEtaLabel.value = 'Route: pickup → destination';
      }
      return;
    }
    rxTripRoutePoints.assignAll(route.points);
    if (!rxHasAssignedDriver.value || rxDriverRoutePoints.isEmpty) {
      rxEtaLabel.value =
          'Trip ${route.durationMinutes} min · ${route.distanceKm.toStringAsFixed(1)} km';
    }
  }

  void _fitMapToTrip() {
    final List<LatLng> points = <LatLng>[
      if (rxPickupLocation.value != null) rxPickupLocation.value!,
      if (rxDestinationLocation.value != null) rxDestinationLocation.value!,
      if (rxDriverLocation.value != null) rxDriverLocation.value!,
      ...rxNearbyDrivers,
      ...rxTripRoutePoints.take(1),
      ...rxDriverRoutePoints.take(1),
    ];
    if (points.isEmpty) {
      return;
    }
    if (points.length == 1) {
      mapController.move(points.first, 15);
      return;
    }
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    for (final LatLng point in points) {
      if (point.latitude < minLat) {
        minLat = point.latitude;
      }
      if (point.latitude > maxLat) {
        maxLat = point.latitude;
      }
      if (point.longitude < minLng) {
        minLng = point.longitude;
      }
      if (point.longitude > maxLng) {
        maxLng = point.longitude;
      }
    }
    final LatLngBounds bounds = LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
    try {
      mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(56)),
      );
    } on Object {
      mapController.move(
        LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
        13,
      );
    }
  }

  void _watchRide() {
    if (rideId.isEmpty || rideId == 'general') {
      return;
    }
    _rideSub = Get.find<FirestoreService>().watchRide(rideId).listen(
      _applyRide,
      onError: (Object error) => Get.log('Ride watch error: $error'),
    );
  }

  void _watchNearbyDrivers() {
    _nearbySub = Get.find<FirestoreService>().watchOnlineDrivers().listen(
      (List<Map<String, dynamic>> drivers) {
        if (rxHasAssignedDriver.value) {
          return;
        }
        final List<LatLng> points = <LatLng>[];
        for (final Map<String, dynamic> driver in drivers) {
          final double? lat = (driver['lastLat'] as num?)?.toDouble();
          final double? lng = (driver['lastLng'] as num?)?.toDouble();
          if (lat != null && lng != null) {
            points.add(LatLng(lat, lng));
          }
        }
        rxNearbyDrivers.assignAll(points);
        if (points.isNotEmpty) {
          _fitMapToTrip();
        }
      },
      onError: (Object error) => Get.log('Nearby drivers error: $error'),
    );
  }

  void _applyRide(RideRequestModel? ride) {
    if (ride == null) {
      return;
    }
    rxStatus.value = ride.status;
    if (ride.vehicleCategory.isNotEmpty) {
      rxVehicleModel.value = ride.vehicleCategory;
    }
    if (ride.pickupLat != null && ride.pickupLng != null) {
      rxPickupLocation.value = LatLng(ride.pickupLat!, ride.pickupLng!);
    }
    if (ride.destinationLat != null && ride.destinationLng != null) {
      rxDestinationLocation.value =
          LatLng(ride.destinationLat!, ride.destinationLng!);
    }
    final String? driverId = ride.driverId;
    if (driverId != null && driverId.isNotEmpty) {
      rxHasAssignedDriver.value = true;
      _watchDriver(driverId);
    }
    _drawTripRoute();
    _fitMapToTrip();
  }

  void _watchDriver(String driverId) {
    if (_watchedDriverId == driverId) {
      return;
    }
    _watchedDriverId = driverId;
    rxNearbyDrivers.clear();
    _driverSub?.cancel();
    _driverSub = Get.find<FirestoreService>().watchDriverDoc(driverId).listen(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
        final String name = data['displayName'] as String? ?? '';
        final String phone = data['phone'] as String? ?? '';
        final String plateValue = data['vehiclePlate'] as String? ?? '';
        if (name.isNotEmpty) {
          rxChauffeurName.value = name;
        }
        if (phone.isNotEmpty) {
          rxPhone.value = phone;
        }
        if (plateValue.isNotEmpty) {
          rxPlate.value = plateValue;
        }
        final double? lat = (data['lastLat'] as num?)?.toDouble();
        final double? lng = (data['lastLng'] as num?)?.toDouble();
        if (lat != null && lng != null) {
          final LatLng point = LatLng(lat, lng);
          rxDriverLocation.value = point;
          _refreshDriverRoute(point);
          _fitMapToTrip();
        }
      },
      onError: (Object error) => Get.log('Driver watch error: $error'),
    );
  }

  Future<void> _refreshDriverRoute(LatLng driverPoint) async {
    final LatLng pickup = rxPickupLocation.value ??
        PassengerWhereToController.mapInitialCenter;
    final DirectionsResult? route =
        await Get.find<DirectionsService>().fetchRoute(
      origin: driverPoint,
      destination: pickup,
    );
    if (route == null || route.points.length < 2) {
      rxDriverRoutePoints.assignAll(<LatLng>[driverPoint, pickup]);
      rxEtaLabel.value = 'Chauffeur en route to pickup';
      return;
    }
    rxDriverRoutePoints.assignAll(route.points);
    rxEtaLabel.value =
        'ETA ${route.durationMinutes} min · ${route.distanceKm.toStringAsFixed(1)} km';
  }

  Future<void> onCall() async {
    final Uri uri = Uri(scheme: 'tel', path: rxPhone.value);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void onMessage() {
    Get.toNamed(
      AppRoutes.rideChat,
      arguments: RideChatArgs(
        chatId: 'ride_$rideId',
        title: rxChauffeurName.value,
        peerName: rxChauffeurName.value,
      ),
    );
  }

  Future<void> onRideComplete() async {
    if (rxStatus.value == 'cancelled') {
      Get.snackbar('Cancelled', 'This ride is no longer active.');
      Get.offAllNamed<void>(AppRoutes.passengerWhereTo);
      return;
    }
    if (rideId.isNotEmpty &&
        rideId != 'general' &&
        rxStatus.value != 'completed') {
      final FirestoreService firestore = Get.find<FirestoreService>();
      final RideRequestModel? ride = await firestore.getRide(rideId);
      final String? driverId = ride?.driverId;
      if (driverId != null && driverId.isNotEmpty) {
        await firestore.completeRide(
          rideId: rideId,
          driverId: driverId,
          fareUsd: (baseFareUsd + serviceFeeUsd).toDouble(),
        );
      } else {
        await firestore.updateRideStatus(rideId, 'completed');
      }
    }
    Get.offNamed<void>(
      AppRoutes.passengerRateRide,
      arguments: <String, dynamic>{
        'baseFareUsd': baseFareUsd,
        'serviceFeeUsd': serviceFeeUsd,
        'cardMask': cardMask,
        'chauffeurName': rxChauffeurName.value,
        'rideId': rideId,
      },
    );
  }

  @override
  void onClose() {
    _nearbySub?.cancel();
    _rideSub?.cancel();
    _driverSub?.cancel();
    mapController.dispose();
    super.onClose();
  }
}
