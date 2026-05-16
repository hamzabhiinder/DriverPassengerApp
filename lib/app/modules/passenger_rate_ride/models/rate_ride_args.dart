class RateRideArgs {
  const RateRideArgs({this.chauffeurName = 'James Robert'});

  final String chauffeurName;

  static RateRideArgs fromArgs(dynamic raw) {
    if (raw is RateRideArgs) {
      return raw;
    }
    if (raw is Map) {
      return RateRideArgs(
        chauffeurName: raw['chauffeurName'] as String? ?? 'James Robert',
      );
    }
    return const RateRideArgs();
  }
}
