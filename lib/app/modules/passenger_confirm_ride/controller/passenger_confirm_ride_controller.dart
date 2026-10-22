import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';
import '../models/confirm_ride_args.dart';

class PassengerConfirmRideController extends GetxController {
  late final ConfirmRideArgs args;
  final RxString rxPaymentMask = '**** **** **** 4242'.obs;
  final RxString rxPaymentLabel = 'Credit Card'.obs;
  final RxList<Map<String, dynamic>> rxCards = <Map<String, dynamic>>[].obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _cardsSub;

  String get paymentSummary => rxPaymentLabel.value;
  String get paymentMask => rxPaymentMask.value;

  @override
  void onInit() {
    super.onInit();
    args = ConfirmRideArgs.fromArgs(Get.arguments);
    _watchCards();
  }

  void _watchCards() {
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    _cardsSub = Get.find<FirestoreService>().watchPassengerDoc(uid).listen(
      _applyCards,
      onError: (Object error) => Get.log('Confirm cards watch skipped: $error'),
    );
  }

  void _applyCards(DocumentSnapshot<Map<String, dynamic>> doc) {
    final List<dynamic> raw = doc.data()?['cards'] as List<dynamic>? ?? <dynamic>[];
    rxCards.assignAll(
      raw.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList(),
    );
    if (rxCards.isEmpty) {
      return;
    }
    final Map<String, dynamic> selected = rxCards.firstWhere(
      (Map<String, dynamic> card) => card['isDefault'] == true,
      orElse: () => rxCards.first,
    );
    rxPaymentMask.value = '${selected['mask'] ?? rxPaymentMask.value}';
    rxPaymentLabel.value = '${selected['brand'] ?? 'Credit Card'}';
  }

  Future<void> onChangePayment() async {
    final String? selected = await Get.bottomSheet<String>(
      Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select payment method',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              ...rxCards.map((Map<String, dynamic> card) {
                final String mask = '${card['mask']}';
                final String brand = '${card['brand']}';
                return ListTile(
                  title: Text(
                    '$brand $mask',
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => Get.back(result: '$mask|$brand'),
                );
              }),
              ListTile(
                title: const Text(
                  'BlackX Wallet',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Get.back(result: 'Wallet balance|Wallet'),
              ),
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
    if (selected == null) {
      return;
    }
    final List<String> parts = selected.split('|');
    rxPaymentMask.value = parts.first;
    rxPaymentLabel.value = parts.length > 1 ? parts[1] : 'Credit Card';
  }

  void onConfirmBooking() {
    Get.toNamed<void>(
      AppRoutes.passengerPaymentSummary,
      arguments: <String, dynamic>{
        'vehicleModel': args.vehicleName,
        'baseFareUsd': args.baseFareUsd,
        'serviceFeeUsd': args.serviceFeeUsd,
        'cardMask': paymentMask,
        'pickupLabel': args.pickupLabel,
        'destinationLabel': args.destinationLabel,
        'vehicleCategory': args.vehicleCategory,
        'vehicleName': args.vehicleName,
        'etaMinutes': args.etaMinutes,
        'tripType': args.tripType,
        'isScheduled': args.isScheduled,
        'scheduledAt': args.scheduledAtIso,
        'pickupLat': args.pickupLat,
        'pickupLng': args.pickupLng,
        'destinationLat': args.destinationLat,
        'destinationLng': args.destinationLng,
        if (args.flightNumber != null) 'flightNumber': args.flightNumber,
        if (args.hours != null) 'hours': args.hours,
        if (args.returnDestination != null)
          'returnDestination': args.returnDestination,
      },
    );
  }

  @override
  void onClose() {
    _cardsSub?.cancel();
    super.onClose();
  }
}
