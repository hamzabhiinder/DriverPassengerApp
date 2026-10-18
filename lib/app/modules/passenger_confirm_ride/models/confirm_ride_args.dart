class ConfirmRideArgs {
  const ConfirmRideArgs({
    required this.pickupLabel,
    required this.destinationLabel,
    required this.vehicleCategory,
    required this.vehicleName,
    required this.vehicleImageAsset,
    required this.baseFareUsd,
    required this.serviceFeeUsd,
    required this.etaMinutes,
    this.tripType = 'Point to Point',
    this.isScheduled = false,
    this.scheduledAtIso,
    this.pickupLat,
    this.pickupLng,
    this.destinationLat,
    this.destinationLng,
  });

  final String pickupLabel;
  final String destinationLabel;
  final String vehicleCategory;
  final String vehicleName;
  final String vehicleImageAsset;
  final int baseFareUsd;
  final int serviceFeeUsd;
  final int etaMinutes;
  final String tripType;
  final bool isScheduled;
  final String? scheduledAtIso;
  final double? pickupLat;
  final double? pickupLng;
  final double? destinationLat;
  final double? destinationLng;

  int get totalUsd => baseFareUsd + serviceFeeUsd;

  static ConfirmRideArgs fromArgs(dynamic raw) {
    if (raw is ConfirmRideArgs) {
      return raw;
    }
    if (raw is Map) {
      return ConfirmRideArgs(
        pickupLabel: raw['pickupLabel'] as String? ?? 'Current Location',
        destinationLabel:
            raw['destinationLabel'] as String? ?? '12280 Westheimer Rd #5',
        vehicleCategory: raw['vehicleCategory'] as String? ?? 'Executive Sedan',
        vehicleName: raw['vehicleName'] as String? ?? 'BMW i5 or Similar',
        vehicleImageAsset:
            raw['vehicleImageAsset'] as String? ?? 'assets/images/car_image.png',
        baseFareUsd: (raw['baseFareUsd'] as num?)?.toInt() ?? 120,
        serviceFeeUsd: (raw['serviceFeeUsd'] as num?)?.toInt() ?? 5,
        etaMinutes: (raw['etaMinutes'] as num?)?.toInt() ?? 5,
        tripType: raw['tripType'] as String? ?? 'Point to Point',
        isScheduled: raw['isScheduled'] == true,
        scheduledAtIso: raw['scheduledAt'] as String?,
        pickupLat: (raw['pickupLat'] as num?)?.toDouble(),
        pickupLng: (raw['pickupLng'] as num?)?.toDouble(),
        destinationLat: (raw['destinationLat'] as num?)?.toDouble(),
        destinationLng: (raw['destinationLng'] as num?)?.toDouble(),
      );
    }
    return const ConfirmRideArgs(
      pickupLabel: 'Current Location',
      destinationLabel: '12280 Westheimer Rd #5',
      vehicleCategory: 'Executive Sedan',
      vehicleName: 'BMW i5 or Similar',
      vehicleImageAsset: 'assets/images/car_image.png',
      baseFareUsd: 120,
      serviceFeeUsd: 5,
      etaMinutes: 5,
    );
  }
}
