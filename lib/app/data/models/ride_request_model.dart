import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestModel {
  const RideRequestModel({
    required this.id,
    required this.passengerId,
    required this.passengerName,
    required this.passengerPhone,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.vehicleCategory,
    required this.fareUsd,
    required this.etaMinutes,
    required this.tripType,
    required this.status,
    required this.createdAt,
    this.driverId,
    this.notes,
    this.pickupLat,
    this.pickupLng,
    this.destinationLat,
    this.destinationLng,
    this.distanceKm,
    this.bookingCode,
    this.scheduledAt,
    this.rating,
  });

  final String id;
  final String passengerId;
  final String passengerName;
  final String passengerPhone;
  final String? driverId;
  final String pickupLabel;
  final String destinationLabel;
  final String vehicleCategory;
  final double fareUsd;
  final int etaMinutes;
  final String tripType;
  final String status;
  final DateTime? createdAt;
  final String? notes;
  final double? pickupLat;
  final double? pickupLng;
  final double? destinationLat;
  final double? destinationLng;
  final double? distanceKm;
  final String? bookingCode;
  final DateTime? scheduledAt;
  final int? rating;

  String get displayBookingCode =>
      bookingCode ?? '#BL-${id.length >= 4 ? id.substring(0, 4).toUpperCase() : id}';

  factory RideRequestModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    return RideRequestModel(
      id: doc.id,
      passengerId: data['passengerId'] as String? ?? '',
      passengerName: data['passengerName'] as String? ?? 'Passenger',
      passengerPhone: data['passengerPhone'] as String? ?? '',
      driverId: data['driverId'] as String?,
      pickupLabel: data['pickupLabel'] as String? ?? 'Pickup',
      destinationLabel: data['destinationLabel'] as String? ?? 'Destination',
      vehicleCategory: data['vehicleCategory'] as String? ?? 'VIP SUV',
      fareUsd: (data['fareUsd'] as num?)?.toDouble() ?? 0,
      etaMinutes: (data['etaMinutes'] as num?)?.toInt() ?? 5,
      tripType: data['tripType'] as String? ?? 'Airport Transfer',
      status: data['status'] as String? ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      notes: data['notes'] as String?,
      pickupLat: (data['pickupLat'] as num?)?.toDouble(),
      pickupLng: (data['pickupLng'] as num?)?.toDouble(),
      destinationLat: (data['destinationLat'] as num?)?.toDouble(),
      destinationLng: (data['destinationLng'] as num?)?.toDouble(),
      distanceKm: (data['distanceKm'] as num?)?.toDouble(),
      bookingCode: data['bookingCode'] as String?,
      scheduledAt: (data['scheduledAt'] as Timestamp?)?.toDate(),
      rating: (data['rating'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toCreateMap({required String? assignedDriverId}) {
    return <String, dynamic>{
      'passengerId': passengerId,
      'passengerName': passengerName,
      'passengerPhone': passengerPhone,
      'driverId': assignedDriverId,
      'pickupLabel': pickupLabel,
      'destinationLabel': destinationLabel,
      'vehicleCategory': vehicleCategory,
      'fareUsd': fareUsd,
      'etaMinutes': etaMinutes,
      'tripType': tripType,
      'status': scheduledAt != null ? 'scheduled' : status,
      'createdAt': FieldValue.serverTimestamp(),
      'notes': notes,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'distanceKm': distanceKm,
      'bookingCode': bookingCode,
      'scheduledAt': scheduledAt == null
          ? null
          : Timestamp.fromDate(scheduledAt!),
    };
  }
}
