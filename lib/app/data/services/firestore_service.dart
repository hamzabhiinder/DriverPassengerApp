import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update driver status (online/offline) and location
  Future<void> updateDriverStatus(String driverId, bool isOnline, {double? lat, double? lng}) async {
    try {
      final data = <String, dynamic>{
        'isOnline': isOnline,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (lat != null && lng != null) {
        data['location'] = GeoPoint(lat, lng);
      }

      await _firestore.collection('drivers').doc(driverId).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating driver status: \$e');
    }
  }

  // Listen for new ride requests assigned to this driver
  Stream<QuerySnapshot> listenToRideRequests(String driverId) {
    return _firestore
        .collection('ride_requests')
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }
}
