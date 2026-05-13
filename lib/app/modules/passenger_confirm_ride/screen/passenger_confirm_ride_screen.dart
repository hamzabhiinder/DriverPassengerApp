import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_confirm_ride_controller.dart';

class PassengerConfirmRideScreen
    extends GetView<PassengerConfirmRideController> {
  const PassengerConfirmRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final a = controller.args;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 70,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Get.back<void>(),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              shape: const CircleBorder(),
            ),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.onBackgroundBright,
              size: 18,
            ),
          ),
        ),

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Your Ride',
              style: AppTypography.castoro(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.onBackgroundBright,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Review your booking details',
              style: AppTypography.geist(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.bodySecondary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 20 + bottom),
        children: [
          _SectionCard(
            child: _LocationTimeline(
              pickup: a.pickupLabel,
              destination: a.destinationLabel,
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            child: _VehicleSummary(
              category: a.vehicleCategory,
              name: a.vehicleName,
              etaMinutes: a.etaMinutes,
              imageAsset: a.vehicleImageAsset,
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            child: _FareBreakdown(
              baseFare: a.baseFareUsd,
              serviceFee: a.serviceFeeUsd,
              total: a.totalUsd,
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            child: _PaymentRow(onChange: controller.onChangePayment),
          ),
          const SizedBox(height: 24),
          GoldGradientCtaButton(
            label: 'Confirm Booking',
            onPressed: controller.onConfirmBooking,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryContainer,
      borderRadius: BorderRadius.circular(18),
      child: Padding(padding: const EdgeInsets.all(18), child: child),
    );
  }
}

class _LocationTimeline extends StatelessWidget {
  const _LocationTimeline({required this.pickup, required this.destination});

  final String pickup;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Image.asset(
              'assets/icons/location_icon.png',
              width: 28,
              height: 28,
              color: AppColors.goldMid,
            ),
            Container(
              width: 2,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppColors.goldMid.withValues(alpha: 0.85),
              ),
            ),
            Image.asset(
              'assets/icons/plane_icon.png',
              width: 28,
              height: 28,
              color: AppColors.goldMid,
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pickup Location',
                style: AppTypography.geist(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceMuted,
                ),
              ),

              Text(
                pickup,
                style: AppTypography.geist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                ),
              ),
              const SizedBox(height: 35),
              Text(
                'Destination',
                style: AppTypography.geist(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceMuted,
                ),
              ),

              Text(
                destination,
                style: AppTypography.geist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VehicleSummary extends StatelessWidget {
  const _VehicleSummary({
    required this.category,
    required this.name,
    required this.etaMinutes,
    required this.imageAsset,
  });

  final String category;
  final String name;
  final int etaMinutes;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.onSurfaceMuted.withValues(alpha: 0.45),
                ),
                color: AppColors.background.withValues(alpha: 0.35),
              ),
              child: Text(
                'Selected Vehicle',
                style: AppTypography.geist(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: AppColors.bodySecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (_) => const Icon(
                  Icons.star_rate,
                  size: 18,
                  color: AppColors.goldMid,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: AppTypography.geist(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: AppTypography.geist(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.goldRing,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    'ETA: $etaMinutes min',
                    style: AppTypography.geist(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageAsset,
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 100,
                  width: 160,
                  child: Icon(
                    Icons.directions_car_filled_rounded,
                    color: AppColors.onSurfaceMuted,
                    size: 48,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _FareBreakdown extends StatelessWidget {
  const _FareBreakdown({
    required this.baseFare,
    required this.serviceFee,
    required this.total,
  });

  final int baseFare;
  final int serviceFee;
  final int total;

  @override
  Widget build(BuildContext context) {
    TextStyle rowLabel() => AppTypography.geist(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurfaceMuted,
    );
    TextStyle rowValue() => AppTypography.geist(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.onBackgroundBright,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Fare Breakdown',
          style: AppTypography.geist(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.onBackgroundBright,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Base Fare', style: rowLabel()),
            Text('\$$baseFare', style: rowValue()),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Service Fee', style: rowLabel()),
            Text('\$$serviceFee', style: rowValue()),
          ],
        ),
        const SizedBox(height: 14),
        Container(height: 1, color: AppColors.goldMid.withValues(alpha: 0.55)),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: AppTypography.geist(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.onBackgroundBright,
              ),
            ),
            Text(
              '\$$total',
              style: AppTypography.geist(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.goldRing,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTypography.geist(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onBackgroundBright,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background.withValues(alpha: 0.6),
                border: Border.all(
                  color: AppColors.goldMid.withValues(alpha: 0.5),
                ),
              ),
              child: UnconstrainedBox(
                child: Image.asset(
                  'assets/icons/card_icon.png',
                  width: 24,
                  height: 24,
                  color: AppColors.goldMid,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PassengerConfirmRideController.paymentSummary,
                    style: AppTypography.geist(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onBackgroundBright,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    PassengerConfirmRideController.paymentMask,
                    style: AppTypography.geist(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onChange,
              child: Text(
                'Change',
                style: AppTypography.geist(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.goldRing,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
