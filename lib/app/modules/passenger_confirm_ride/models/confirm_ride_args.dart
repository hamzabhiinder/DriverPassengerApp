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
  });

  final String pickupLabel;
  final String destinationLabel;
  final String vehicleCategory;
  final String vehicleName;
  final String vehicleImageAsset;
  final int baseFareUsd;
  final int serviceFeeUsd;
  final int etaMinutes;

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
