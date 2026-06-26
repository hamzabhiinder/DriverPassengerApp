class PaymentSummaryArgs {
  const PaymentSummaryArgs({
    required this.baseFareUsd,
    required this.serviceFeeUsd,
    this.cardMask = '**** **** **** 4242',
    this.walletBalanceUsd = 450,
    this.chauffeurName = 'James Robert',
  });

  final int baseFareUsd;
  final int serviceFeeUsd;
  final String cardMask;
  final double walletBalanceUsd;
  final String chauffeurName;

  int get totalUsd => baseFareUsd + serviceFeeUsd;

  static PaymentSummaryArgs fromArgs(dynamic raw) {
    if (raw is PaymentSummaryArgs) {
      return raw;
    }
    if (raw is Map) {
      return PaymentSummaryArgs(
        baseFareUsd: (raw['baseFareUsd'] as num?)?.toInt() ?? 120,
        serviceFeeUsd: (raw['serviceFeeUsd'] as num?)?.toInt() ?? 5,
        cardMask: raw['cardMask'] as String? ?? '**** **** **** 4242',
        walletBalanceUsd:
            (raw['walletBalanceUsd'] as num?)?.toDouble() ?? 450,
        chauffeurName: raw['chauffeurName'] as String? ?? 'James Robert',
      );
    }
    return const PaymentSummaryArgs(
      baseFareUsd: 120,
      serviceFeeUsd: 5,
    );
  }
}
