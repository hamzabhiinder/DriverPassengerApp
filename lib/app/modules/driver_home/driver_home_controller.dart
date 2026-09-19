import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../driver_new_ride_request/screen/driver_new_ride_request.dart'
    show NewRideRequestView;

import '../../data/services/firestore_service.dart';
import '../../data/services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class DriverHomeController extends GetxController {
  final rxIsOnline = false.obs;

  final rxEarnings = '\$425.00'.obs;
  final rxRidesCompleted = '23'.obs;
  final rxHoursOnline = '12'.obs;

  final initialMapCenter = const LatLng(25.2048, 55.2708);
  StreamSubscription? _rideRequestsSubscription;

  @override
  void onClose() {
    _rideRequestsSubscription?.cancel();
    super.onClose();
  }

  void toggleOnlineStatus() async {
    rxIsOnline.value = !rxIsOnline.value;
    
    try {
      final authService = Get.find<FirebaseAuthService>();
      final firestoreService = Get.find<FirestoreService>();
      final driverId = authService.currentUser?.uid;

      if (driverId != null) {
        // Update status in Firestore
        await firestoreService.updateDriverStatus(
          driverId, 
          rxIsOnline.value,
          lat: initialMapCenter.latitude,
          lng: initialMapCenter.longitude,
        );

        if (rxIsOnline.value) {
          // Listen for incoming ride requests
          _rideRequestsSubscription = firestoreService
              .listenToRideRequests(driverId)
              .listen((snapshot) {
            if (snapshot.docs.isNotEmpty) {
               // A new ride request arrived
               Get.to(() => const NewRideRequestView());
               // Optional: you might want to cancel the subscription here or handle it differently
            }
          });
        } else {
          // Driver went offline, stop listening
          await _rideRequestsSubscription?.cancel();
          _rideRequestsSubscription = null;
        }
      }
    } catch (e) {
      print('Error updating online status: \$e');
    }
  }
}
