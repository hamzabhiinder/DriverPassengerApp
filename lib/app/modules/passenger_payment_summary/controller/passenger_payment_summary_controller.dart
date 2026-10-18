import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/models/ride_request_model.dart';
import '../../../data/services/directions_service.dart';
import '../../../data/services/driver_location_service.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';
import '../models/payment_summary_args.dart';

enum PassengerPaymentMethod { card, wallet }

class PassengerPaymentSummaryController extends GetxController {
  late final PaymentSummaryArgs args;

  final Rx<PassengerPaymentMethod> method = PassengerPaymentMethod.card.obs;
  final RxBool rxIsPaying = false.obs;
  final RxString rxCardMask = '**** **** **** 4242'.obs;
  final RxDouble rxWalletBalance = 0.0.obs;
  final RxList<Map<String, dynamic>> rxCards = <Map<String, dynamic>>[].obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSub;

  @override
  void onInit() {
    super.onInit();
    args = PaymentSummaryArgs.fromArgs(Get.arguments);
    rxCardMask.value = args.cardMask;
    rxWalletBalance.value = args.walletBalanceUsd;
    _watchProfile();
  }

  void _watchProfile() {
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    _profileSub = Get.find<FirestoreService>().watchPassengerDoc(uid).listen(
      _applyProfile,
      onError: (Object error) => Get.log('Payment profile watch skipped: $error'),
    );
  }

  void _applyProfile(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    rxWalletBalance.value = (data['walletBalanceUsd'] as num?)?.toDouble() ?? rxWalletBalance.value;
    final List<dynamic> raw = data['cards'] as List<dynamic>? ?? <dynamic>[];
    rxCards.assignAll(
      raw.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList(),
    );
  }

  void selectCard() => method.value = PassengerPaymentMethod.card;

  void selectWallet() => method.value = PassengerPaymentMethod.wallet;

  Future<void> onChangeCard() async {
    final String? selected = await Get.bottomSheet<String>(
      Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select card',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              ...rxCards.map((Map<String, dynamic> card) {
                final String mask = '${card['mask']}';
                return ListTile(
                  title: Text(
                    '${card['brand']} $mask',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => Get.back(result: mask),
                );
              }),
              ListTile(
                title: const Text(
                  'Manage cards',
                  style: TextStyle(color: Color(0xFFC59341)),
                ),
                onTap: () {
                  Get.back();
                  Get.toNamed<void>(AppRoutes.passengerCards);
                },
              ),
            ],
          ),
        ),
      ),
    );
    if (selected != null) {
      rxCardMask.value = selected;
      method.value = PassengerPaymentMethod.card;
    }
  }

  Future<void> onPay() async {
    if (rxIsPaying.value) {
      return;
    }
    rxIsPaying.value = true;
    try {
      final FirebaseAuthService auth = Get.find<FirebaseAuthService>();
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
      final String passengerId = auth.currentUser!.uid;
      final FirestoreService firestore = Get.find<FirestoreService>();
      await firestore.ensurePassengerProfile(passengerId: passengerId);
      final DocumentSnapshot<Map<String, dynamic>> profile =
          await firestore.getPassengerDoc(passengerId);
      final Map<String, dynamic> data = profile.data() ?? <String, dynamic>{};
      final double wallet = (data['walletBalanceUsd'] as num?)?.toDouble() ?? 0;
      final bool payWithWallet = method.value == PassengerPaymentMethod.wallet;
      if (payWithWallet && wallet < args.totalUsd) {
        Get.snackbar(
          'Wallet',
          'Not enough wallet balance for this ride.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      final DateTime? scheduledAt = args.scheduledAtIso == null
          ? null
          : DateTime.tryParse(args.scheduledAtIso!);
      final ({
        double? pickupLat,
        double? pickupLng,
        double? destinationLat,
        double? destinationLng,
        double distanceKm,
        int etaMinutes,
      }) coords = await _resolveTripCoordinates();
      final String rideId = await firestore.createRideRequest(
        ride: RideRequestModel(
          id: '',
          passengerId: passengerId,
          passengerName: data['displayName'] as String? ?? 'Passenger',
          passengerPhone: data['phone'] as String? ?? '',
          pickupLabel: args.pickupLabel,
          destinationLabel: args.destinationLabel,
          vehicleCategory: args.vehicleName.isEmpty
              ? args.vehicleCategory
              : args.vehicleName,
          fareUsd: args.totalUsd.toDouble(),
          etaMinutes: coords.etaMinutes,
          tripType: args.tripType,
          status: scheduledAt == null ? 'pending' : 'scheduled',
          createdAt: DateTime.now(),
          notes: payWithWallet ? 'Paid via wallet' : 'Paid via ${rxCardMask.value}',
          bookingCode: '#BL-${DateTime.now().millisecondsSinceEpoch % 10000}',
          distanceKm: coords.distanceKm,
          scheduledAt: scheduledAt,
          pickupLat: coords.pickupLat,
          pickupLng: coords.pickupLng,
          destinationLat: coords.destinationLat,
          destinationLng: coords.destinationLng,
        ),
      );
      await firestore.recordPayment(
        userId: passengerId,
        rideId: rideId,
        amountUsd: args.totalUsd.toDouble(),
        method: payWithWallet ? 'wallet' : 'card',
        status: 'completed',
        cardMask: payWithWallet ? null : rxCardMask.value,
      );
      if (payWithWallet) {
        await firestore.updatePassengerFields(
          passengerId,
          <String, dynamic>{
            'walletBalanceUsd': FieldValue.increment(-args.totalUsd.toDouble()),
          },
        );
      }
      if (scheduledAt != null) {
        Get.offAllNamed<void>(AppRoutes.passengerScheduledRides);
        Get.snackbar(
          'Scheduled',
          'Your chauffeur is booked for the selected time.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB88E2F),
          colorText: Colors.black,
        );
        return;
      }
      Get.offNamed<void>(
        AppRoutes.passengerChauffeurAssigned,
        arguments: <String, dynamic>{
          'vehicleModel': args.vehicleName.isEmpty
              ? args.vehicleCategory
              : args.vehicleName,
          'chauffeurName': args.chauffeurName,
          'baseFareUsd': args.baseFareUsd,
          'serviceFeeUsd': args.serviceFeeUsd,
          'cardMask': rxCardMask.value,
          'rideId': rideId,
          'pickupLabel': args.pickupLabel,
          'destinationLabel': args.destinationLabel,
          'pickupLat': coords.pickupLat,
          'pickupLng': coords.pickupLng,
          'destinationLat': coords.destinationLat,
          'destinationLng': coords.destinationLng,
        },
      );
    } on Object catch (error) {
      Get.snackbar(
        'Booking failed',
        '$error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
        colorText: Colors.white,
      );
    } finally {
      rxIsPaying.value = false;
    }
  }

  Future<
      ({
        double? pickupLat,
        double? pickupLng,
        double? destinationLat,
        double? destinationLng,
        double distanceKm,
        int etaMinutes,
      })> _resolveTripCoordinates() async {
    final DirectionsService directions = Get.find<DirectionsService>();
    double? pickupLat = args.pickupLat;
    double? pickupLng = args.pickupLng;
    double? destinationLat = args.destinationLat;
    double? destinationLng = args.destinationLng;
    if (pickupLat == null || pickupLng == null) {
      final LatLng? current =
          await Get.find<DriverLocationService>().getCurrentLatLng();
      if (current != null) {
        pickupLat = current.latitude;
        pickupLng = current.longitude;
      } else {
        final LatLng? geocoded = await directions.geocode(args.pickupLabel);
        pickupLat = geocoded?.latitude;
        pickupLng = geocoded?.longitude;
      }
    }
    if (destinationLat == null || destinationLng == null) {
      final LatLng? dest = await directions.geocode(args.destinationLabel);
      destinationLat = dest?.latitude;
      destinationLng = dest?.longitude;
    }
    double distanceKm = 12;
    int etaMinutes = args.etaMinutes;
    if (pickupLat != null &&
        pickupLng != null &&
        destinationLat != null &&
        destinationLng != null) {
      final DirectionsResult? route = await directions.fetchRoute(
        origin: LatLng(pickupLat, pickupLng),
        destination: LatLng(destinationLat, destinationLng),
      );
      if (route != null) {
        distanceKm = route.distanceKm;
        etaMinutes = route.durationMinutes;
      }
    }
    return (
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
    );
  }

  @override
  void onClose() {
    _profileSub?.cancel();
    super.onClose();
  }
}
