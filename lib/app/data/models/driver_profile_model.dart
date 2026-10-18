import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfileModel {
  const DriverProfileModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.isOnline,
    required this.rating,
    required this.ridesCompleted,
    required this.earningsTodayUsd,
    required this.hoursOnlineToday,
    required this.acceptanceRate,
    this.phone,
    this.vehicleLabel,
  });

  final String id;
  final String email;
  final String displayName;
  final bool isOnline;
  final double rating;
  final int ridesCompleted;
  final double earningsTodayUsd;
  final double hoursOnlineToday;
  final double acceptanceRate;
  final String? phone;
  final String? vehicleLabel;

  factory DriverProfileModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    return DriverProfileModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'Driver',
      isOnline: data['isOnline'] as bool? ?? false,
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      ridesCompleted: (data['ridesCompleted'] as num?)?.toInt() ?? 0,
      earningsTodayUsd: (data['earningsTodayUsd'] as num?)?.toDouble() ?? 0,
      hoursOnlineToday: (data['hoursOnlineToday'] as num?)?.toDouble() ?? 0,
      acceptanceRate: (data['acceptanceRate'] as num?)?.toDouble() ?? 100,
      phone: data['phone'] as String?,
      vehicleLabel: data['vehicleLabel'] as String?,
    );
  }

  static Map<String, dynamic> bootstrapMap({
    required String email,
    required String displayName,
  }) {
    return <String, dynamic>{
      'email': email,
      'displayName': displayName,
      'isOnline': false,
      'rating': 5.0,
      'ridesCompleted': 0,
      'earningsTodayUsd': 0.0,
      'hoursOnlineToday': 0.0,
      'acceptanceRate': 100.0,
      'vehicleLabel': 'BlackX Chauffeur',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
