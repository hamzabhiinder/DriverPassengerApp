class RateRideArgs {
  const RateRideArgs({
    this.chauffeurName = 'James Robert',
    this.rideId = '',
  });

  final String chauffeurName;
  final String rideId;

  static RateRideArgs fromArgs(dynamic raw) {
    if (raw is RateRideArgs) {
      return raw;
    }
    if (raw is Map) {
      return RateRideArgs(
        chauffeurName: raw['chauffeurName'] as String? ?? 'James Robert',
        rideId: raw['rideId'] as String? ?? '',
      );
    }
    return const RateRideArgs();
  }
}
