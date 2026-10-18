import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/driver_profile_model.dart';
import '../models/ride_request_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _drivers =>
      _firestore.collection('drivers');

  CollectionReference<Map<String, dynamic>> get _rides =>
      _firestore.collection('ride_requests');

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('notifications');

  CollectionReference<Map<String, dynamic>> get _tickets =>
      _firestore.collection('support_tickets');

  CollectionReference<Map<String, dynamic>> get _chats =>
      _firestore.collection('chats');

  CollectionReference<Map<String, dynamic>> get _passengers =>
      _firestore.collection('passengers');

  CollectionReference<Map<String, dynamic>> get _payments =>
      _firestore.collection('payments');

  Future<void> ensureDriverProfile({
    required String driverId,
    required String email,
    String? displayName,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> existing =
        await _drivers.doc(driverId).get();
    final Map<String, dynamic> defaults = <String, dynamic>{
      ...DriverProfileModel.bootstrapMap(
        email: email,
        displayName: displayName ?? email.split('@').first,
      ),
      'phone': '',
      'walletBalanceUsd': 0.0,
      'pendingPayoutUsd': 0.0,
      'payoutMethod': 'Bank transfer',
      'vehicleMake': 'Mercedes-Benz',
      'vehicleModel': 'S-Class',
      'vehiclePlate': 'DXB 1234',
      'vehicleColor': 'Black',
      'vehicleYear': 2024,
      'notifyNewRides': true,
      'notifyEarnings': true,
      'shareLiveLocation': true,
      'documents': <Map<String, dynamic>>[
        <String, dynamic>{
          'name': 'Driver License',
          'status': 'verified',
          'expiresAt': '2027-12-31',
        },
        <String, dynamic>{
          'name': 'Vehicle Registration',
          'status': 'verified',
          'expiresAt': '2026-11-30',
        },
        <String, dynamic>{
          'name': 'Insurance',
          'status': 'pending',
          'expiresAt': '2026-08-15',
        },
        <String, dynamic>{
          'name': 'Background Check',
          'status': 'verified',
          'expiresAt': '2027-01-01',
        },
      ],
    };
    if (!existing.exists) {
      await _drivers.doc(driverId).set(defaults);
      await addNotification(
        userId: driverId,
        title: 'Welcome to BlackX',
        body: 'Your chauffeur account is ready. Go online to receive rides.',
        type: 'system',
      );
      return;
    }
    final Map<String, dynamic> data = existing.data() ?? <String, dynamic>{};
    final Map<String, dynamic> patch = <String, dynamic>{};
    for (final MapEntry<String, dynamic> entry in defaults.entries) {
      if (!data.containsKey(entry.key)) {
        patch[entry.key] = entry.value;
      }
    }
    if (patch.isNotEmpty) {
      await _drivers.doc(driverId).set(patch, SetOptions(merge: true));
    }
  }

  Future<DriverProfileModel?> getDriverProfile(String driverId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _drivers.doc(driverId).get();
    if (!doc.exists) {
      return null;
    }
    return DriverProfileModel.fromDoc(doc);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDriverDoc(
    String driverId,
  ) {
    return _drivers.doc(driverId).snapshots();
  }

  Stream<List<Map<String, dynamic>>> watchOnlineDrivers({int limit = 12}) {
    return _drivers
        .where('isOnline', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
          return <String, dynamic>{'id': doc.id, ...doc.data()};
        },
      ).toList();
    });
  }

  Stream<DriverProfileModel?> watchDriverProfile(String driverId) {
    return _drivers.doc(driverId).snapshots().map(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        if (!doc.exists) {
          return null;
        }
        return DriverProfileModel.fromDoc(doc);
      },
    );
  }

  Future<void> updateDriverStatus(
    String driverId,
    bool isOnline, {
    double? lat,
    double? lng,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'isOnline': isOnline,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (lat != null && lng != null) {
      data['location'] = GeoPoint(lat, lng);
      data['lastLat'] = lat;
      data['lastLng'] = lng;
    }
    await _drivers.doc(driverId).set(data, SetOptions(merge: true));
  }

  Future<void> updateDriverLocation(
    String driverId, {
    required double lat,
    required double lng,
  }) async {
    await _drivers.doc(driverId).set(
      <String, dynamic>{
        'location': GeoPoint(lat, lng),
        'lastLat': lat,
        'lastLng': lng,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateDriverFields(
    String driverId,
    Map<String, dynamic> fields,
  ) async {
    await _drivers.doc(driverId).set(
      <String, dynamic>{
        ...fields,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Stream<List<RideRequestModel>> listenToPendingRideRequests(String driverId) {
    return _rides.where('status', isEqualTo: 'pending').snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs
            .map(RideRequestModel.fromDoc)
            .where(
              (RideRequestModel ride) =>
                  ride.driverId == null ||
                  ride.driverId!.isEmpty ||
                  ride.driverId == driverId,
            )
            .toList();
      },
    );
  }

  Future<String> createRideRequest({
    required RideRequestModel ride,
    String? preferredDriverId,
    bool assignDriver = true,
  }) async {
    String? driverId = preferredDriverId;
    final bool shouldAssign = assignDriver && ride.scheduledAt == null;
    if (shouldAssign && (driverId == null || driverId.isEmpty)) {
      final QuerySnapshot<Map<String, dynamic>> onlineDrivers = await _drivers
          .where('isOnline', isEqualTo: true)
          .limit(1)
          .get();
      if (onlineDrivers.docs.isNotEmpty) {
        driverId = onlineDrivers.docs.first.id;
      }
    }
    if (!shouldAssign) {
      driverId = null;
    }
    final DocumentReference<Map<String, dynamic>> ref = await _rides.add(
      ride.toCreateMap(assignedDriverId: driverId),
    );
    if (driverId != null) {
      await addNotification(
        userId: driverId,
        title: 'New ride request',
        body: '${ride.passengerName} · ${ride.pickupLabel} → ${ride.destinationLabel}',
        type: 'ride',
        rideId: ref.id,
      );
    }
    await addNotification(
      userId: ride.passengerId,
      title: ride.scheduledAt != null ? 'Ride scheduled' : 'Chauffeur requested',
      body: '${ride.pickupLabel} → ${ride.destinationLabel}',
      type: 'ride',
      rideId: ref.id,
    );
    return ref.id;
  }

  Future<void> updateRideStatus(
    String rideId,
    String status, {
    String? driverId,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (driverId != null) {
      data['driverId'] = driverId;
    }
    await _rides.doc(rideId).update(data);
  }

  Future<void> completeRide({
    required String rideId,
    required String driverId,
    required double fareUsd,
  }) async {
    final WriteBatch batch = _firestore.batch();
    batch.update(_rides.doc(rideId), <String, dynamic>{
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    batch.set(
      _drivers.doc(driverId),
      <String, dynamic>{
        'ridesCompleted': FieldValue.increment(1),
        'earningsTodayUsd': FieldValue.increment(fareUsd),
        'walletBalanceUsd': FieldValue.increment(fareUsd),
        'pendingPayoutUsd': FieldValue.increment(fareUsd),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    await batch.commit();
    await addNotification(
      userId: driverId,
      title: 'Trip completed',
      body: 'You earned \$${fareUsd.toStringAsFixed(2)}. Great work.',
      type: 'earnings',
      rideId: rideId,
    );
  }

  Stream<List<RideRequestModel>> watchDriverTrips(String driverId) {
    return _rides.where('driverId', isEqualTo: driverId).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        final List<RideRequestModel> trips =
            snapshot.docs.map(RideRequestModel.fromDoc).toList();
        trips.sort((RideRequestModel a, RideRequestModel b) {
          final DateTime aDate =
              a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final DateTime bDate =
              b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        return trips;
      },
    );
  }

  Future<RideRequestModel?> getRide(String rideId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _rides.doc(rideId).get();
    if (!doc.exists) {
      return null;
    }
    return RideRequestModel.fromDoc(doc);
  }

  Future<void> addNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    String? rideId,
  }) async {
    await _notifications.add(<String, dynamic>{
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'rideId': rideId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> watchNotifications(String userId) {
    return _notifications.where('userId', isEqualTo: userId).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        final List<Map<String, dynamic>> items = snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return <String, dynamic>{'id': doc.id, ...doc.data()};
          },
        ).toList();
        items.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
          final Timestamp? aTs = a['createdAt'] as Timestamp?;
          final Timestamp? bTs = b['createdAt'] as Timestamp?;
          return (bTs?.millisecondsSinceEpoch ?? 0)
              .compareTo(aTs?.millisecondsSinceEpoch ?? 0);
        });
        return items;
      },
    );
  }

  Future<void> markNotificationRead(String notificationId) async {
    await _notifications.doc(notificationId).update(<String, dynamic>{
      'isRead': true,
    });
  }

  Future<void> markAllNotificationsRead(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> unread = await _notifications
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();
    final WriteBatch batch = _firestore.batch();
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in unread.docs) {
      batch.update(doc.reference, <String, dynamic>{'isRead': true});
    }
    await batch.commit();
  }

  Future<String> createSupportTicket({
    required String userId,
    required String subject,
    required String message,
    required String category,
  }) async {
    final DocumentReference<Map<String, dynamic>> ref = await _tickets.add(
      <String, dynamic>{
        'userId': userId,
        'subject': subject,
        'message': message,
        'category': category,
        'status': 'open',
        'createdAt': FieldValue.serverTimestamp(),
      },
    );
    await addNotification(
      userId: userId,
      title: 'Support ticket opened',
      body: subject,
      type: 'support',
    );
    return ref.id;
  }

  Stream<List<Map<String, dynamic>>> watchSupportTickets(String userId) {
    return _tickets.where('userId', isEqualTo: userId).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        final List<Map<String, dynamic>> items = snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return <String, dynamic>{'id': doc.id, ...doc.data()};
          },
        ).toList();
        items.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
          final Timestamp? aTs = a['createdAt'] as Timestamp?;
          final Timestamp? bTs = b['createdAt'] as Timestamp?;
          return (bTs?.millisecondsSinceEpoch ?? 0)
              .compareTo(aTs?.millisecondsSinceEpoch ?? 0);
        });
        return items;
      },
    );
  }

  Future<void> requestPayout(String driverId, double amount) async {
    await _drivers.doc(driverId).set(
      <String, dynamic>{
        'pendingPayoutUsd': FieldValue.increment(-amount),
        'walletBalanceUsd': FieldValue.increment(-amount),
        'lastPayoutAt': FieldValue.serverTimestamp(),
        'lastPayoutAmountUsd': amount,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    await addNotification(
      userId: driverId,
      title: 'Payout requested',
      body: '\$${amount.toStringAsFixed(2)} is being processed to your bank.',
      type: 'wallet',
    );
  }

  Future<void> sendChatMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    await _chats.doc(chatId).collection('messages').add(<String, dynamic>{
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _chats.doc(chatId).set(
      <String, dynamic>{
        'lastMessage': text,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> ensurePassengerProfile({
    required String passengerId,
    String? displayName,
    String? phone,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> existing =
        await _passengers.doc(passengerId).get();
    final Map<String, dynamic> defaults = <String, dynamic>{
      'displayName': displayName ?? 'Rider',
      'firstName': '',
      'lastName': '',
      'phone': phone ?? '',
      'walletBalanceUsd': 250.0,
      'rating': 5.0,
      'notifyRideUpdates': true,
      'notifyPromos': true,
      'savedPlaces': <String>[
        'Home · Downtown Residence',
        'Work · Business Bay Office',
        'Hotel Emma',
        'San Antonio International Airport',
      ],
      'cards': <Map<String, dynamic>>[
        <String, dynamic>{
          'brand': 'Visa',
          'last4': '4242',
          'mask': '**** **** **** 4242',
          'expiry': '12/28',
          'isDefault': true,
        },
        <String, dynamic>{
          'brand': 'Mastercard',
          'last4': '5555',
          'mask': '**** **** **** 5555',
          'expiry': '08/27',
          'isDefault': false,
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (!existing.exists) {
      await _passengers.doc(passengerId).set(defaults);
      await addNotification(
        userId: passengerId,
        title: 'Welcome to BlackX',
        body: 'Your rider account is ready. Book a chauffeur anytime.',
        type: 'system',
      );
      return;
    }
    final Map<String, dynamic> data = existing.data() ?? <String, dynamic>{};
    final Map<String, dynamic> patch = <String, dynamic>{};
    for (final MapEntry<String, dynamic> entry in defaults.entries) {
      if (!data.containsKey(entry.key)) {
        patch[entry.key] = entry.value;
      }
    }
    if (patch.isNotEmpty) {
      await _passengers.doc(passengerId).set(patch, SetOptions(merge: true));
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchPassengerDoc(
    String passengerId,
  ) {
    return _passengers.doc(passengerId).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPassengerDoc(
    String passengerId,
  ) {
    return _passengers.doc(passengerId).get();
  }

  Future<void> updatePassengerFields(
    String passengerId,
    Map<String, dynamic> fields,
  ) async {
    await _passengers.doc(passengerId).set(
      <String, dynamic>{
        ...fields,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Stream<List<RideRequestModel>> watchPassengerRides(String passengerId) {
    return _rides.where('passengerId', isEqualTo: passengerId).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        final List<RideRequestModel> trips =
            snapshot.docs.map(RideRequestModel.fromDoc).toList();
        trips.sort((RideRequestModel a, RideRequestModel b) {
          final DateTime aDate =
              a.scheduledAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final DateTime bDate =
              b.scheduledAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        return trips;
      },
    );
  }

  Stream<RideRequestModel?> watchRide(String rideId) {
    return _rides.doc(rideId).snapshots().map(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        if (!doc.exists) {
          return null;
        }
        return RideRequestModel.fromDoc(doc);
      },
    );
  }

  Future<void> submitRideRating({
    required String rideId,
    required String passengerId,
    required int rating,
    required String feedback,
    required List<String> tags,
  }) async {
    await _rides.doc(rideId).update(<String, dynamic>{
      'rating': rating,
      'feedback': feedback,
      'ratingTags': tags,
      'ratedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await addNotification(
      userId: passengerId,
      title: 'Thanks for rating',
      body: 'You rated this ride $rating stars.',
      type: 'ride',
      rideId: rideId,
    );
  }

  Future<void> cancelRide({
    required String rideId,
    required String passengerId,
  }) async {
    await _rides.doc(rideId).update(<String, dynamic>{
      'status': 'cancelled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await addNotification(
      userId: passengerId,
      title: 'Ride cancelled',
      body: 'Your booking was cancelled.',
      type: 'ride',
      rideId: rideId,
    );
  }

  Future<void> saveFcmToken(String userId, String token) async {
    await _firestore.collection('user_tokens').doc(userId).set(
      <String, dynamic>{
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<String> recordPayment({
    required String userId,
    required String rideId,
    required double amountUsd,
    required String method,
    required String status,
    String? cardMask,
  }) async {
    final DocumentReference<Map<String, dynamic>> ref = await _payments.add(
      <String, dynamic>{
        'userId': userId,
        'rideId': rideId,
        'amountUsd': amountUsd,
        'method': method,
        'status': status,
        'cardMask': cardMask,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );
    return ref.id;
  }

  Stream<List<Map<String, dynamic>>> watchPayments(String userId) {
    return _payments.where('userId', isEqualTo: userId).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        final List<Map<String, dynamic>> items = snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return <String, dynamic>{'id': doc.id, ...doc.data()};
          },
        ).toList();
        items.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
          final Timestamp? aTs = a['createdAt'] as Timestamp?;
          final Timestamp? bTs = b['createdAt'] as Timestamp?;
          return (bTs?.millisecondsSinceEpoch ?? 0)
              .compareTo(aTs?.millisecondsSinceEpoch ?? 0);
        });
        return items;
      },
    );
  }

  Future<void> topUpWallet(String passengerId, double amountUsd) async {
    await _passengers.doc(passengerId).set(
      <String, dynamic>{
        'walletBalanceUsd': FieldValue.increment(amountUsd),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    await recordPayment(
      userId: passengerId,
      rideId: '',
      amountUsd: amountUsd,
      method: 'wallet_topup',
      status: 'completed',
    );
    await addNotification(
      userId: passengerId,
      title: 'Wallet topped up',
      body: '\$${amountUsd.toStringAsFixed(2)} added to your BlackX wallet.',
      type: 'wallet',
    );
  }

  Future<void> acceptTerms(String passengerId) async {
    await updatePassengerFields(passengerId, <String, dynamic>{
      'termsAcceptedAt': FieldValue.serverTimestamp(),
      'termsVersion': '4.51',
    });
  }

  Stream<List<Map<String, dynamic>>> watchChatMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map(
        (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
          return <String, dynamic>{'id': doc.id, ...doc.data()};
        },
      ).toList();
    });
  }
}
