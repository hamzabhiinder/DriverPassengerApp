class PaymentSummaryArgs {
  const PaymentSummaryArgs({
    required this.baseFareUsd,
    required this.serviceFeeUsd,
    required this.cardMask,
    required this.walletBalanceUsd,
    required this.chauffeurName,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.vehicleCategory,
    required this.etaMinutes,
    this.tripType = 'Point to Point',
    this.isScheduled = false,
    this.scheduledAtIso,
    this.vehicleName = '',
    this.pickupLat,
    this.pickupLng,
    this.destinationLat,
    this.destinationLng,
    this.pickupAddress = '9800 Airport Blvd, San Antonio, TX 78216',
    this.destinationAddress = '136 E Grayson St, San Antonio, TX 78215',
    this.flightNumber,
    this.hours,
    this.returnDestination,
  });

  final int baseFareUsd;
  final int serviceFeeUsd;
  final String cardMask;
  final double walletBalanceUsd;
  final String chauffeurName;
  final String pickupLabel;
  final String destinationLabel;
  final String? pickupAddress;
  final String destinationAddress;
  final String vehicleCategory;
  final int etaMinutes;
  final String tripType;
  final bool isScheduled;
  final String? scheduledAtIso;
  final String vehicleName;
  final double? pickupLat;
  final double? pickupLng;
  final double? destinationLat;
  final double? destinationLng;
  final String? flightNumber;
  final int? hours;
  final String? returnDestination;

  int get totalUsd => baseFareUsd + serviceFeeUsd;

  factory PaymentSummaryArgs.fromArgs(Object? rawArgs) {
    final Map<String, dynamic> raw = rawArgs is Map
        ? Map<String, dynamic>.from(rawArgs)
        : <String, dynamic>{};
    return PaymentSummaryArgs(
      baseFareUsd: (raw['baseFareUsd'] as num?)?.toInt() ?? 220,
      serviceFeeUsd: (raw['serviceFeeUsd'] as num?)?.toInt() ?? 5,
      cardMask: raw['cardMask'] as String? ?? '**** **** **** 4242',
      walletBalanceUsd: (raw['walletBalanceUsd'] as num?)?.toDouble() ?? 450,
      chauffeurName: raw['chauffeurName'] as String? ?? 'James Anderson',
      pickupLabel:
          raw['pickupLabel'] as String? ?? 'San Antonio International Airport',
      destinationLabel: raw['destinationLabel'] as String? ?? 'Hotel Emma',
      pickupAddress: raw['pickupAddress'] as String? ??
          '9800 Airport Blvd, San Antonio, TX 78216',
      destinationAddress: raw['destinationAddress'] as String? ??
          '136 E Grayson St, San Antonio, TX 78215',
      vehicleCategory: raw['vehicleCategory'] as String? ?? 'VIP SUV',
      etaMinutes: (raw['etaMinutes'] as num?)?.toInt() ?? 5,
      tripType: raw['tripType'] as String? ?? 'Point to Point',
      isScheduled: raw['isScheduled'] == true,
      scheduledAtIso: raw['scheduledAt'] as String?,
      vehicleName: raw['vehicleName'] as String? ?? '',
      pickupLat: (raw['pickupLat'] as num?)?.toDouble(),
      pickupLng: (raw['pickupLng'] as num?)?.toDouble(),
      destinationLat: (raw['destinationLat'] as num?)?.toDouble(),
      destinationLng: (raw['destinationLng'] as num?)?.toDouble(),
      flightNumber: raw['flightNumber'] as String?,
      hours: (raw['hours'] as num?)?.toInt(),
      returnDestination: raw['returnDestination'] as String?,
    );
  }
}
