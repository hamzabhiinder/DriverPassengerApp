import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_input_field.dart';
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
        toolbarHeight: 68.h,
        leadingWidth: 70.w,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: IconButton(
            onPressed: () => Get.back<void>(),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              shape: const CircleBorder(),
            ),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.onBackgroundBright,
              size: 18.sp,
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
            SizedBox(height: 2.h),
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
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h + bottom),
        children: [
          _SectionCard(
            child: _LocationTimeline(
              pickup: a.pickupLabel,
              destination: a.destinationLabel,
            ),
          ),
          SizedBox(height: 12.h),
          _SectionCard(
            child: _VehicleSummary(
              category: a.vehicleCategory,
              name: a.vehicleName,
              etaMinutes: a.etaMinutes,
              imageAsset: a.vehicleImageAsset,
            ),
          ),
          SizedBox(height: 12.h),
          const _SpecialInstructionsCard(),
          SizedBox(height: 12.h),
          _SectionCard(
            child: _FareBreakdown(
              baseFare: a.baseFareUsd,
              serviceFee: a.serviceFeeUsd,
              total: a.totalUsd,
            ),
          ),
          SizedBox(height: 12.h),
          _SectionCard(
            child: _PaymentRow(onChange: controller.onChangePayment),
          ),
          SizedBox(height: 24.h),
          GoldGradientCtaButton(
            label: 'Continue to Payment',
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
      borderRadius: BorderRadius.circular(18.r),
      child: Padding(padding: EdgeInsets.all(18.w), child: child),
    );
  }
}

class _SpecialInstructionsCard extends StatefulWidget {
  const _SpecialInstructionsCard();

  @override
  State<_SpecialInstructionsCard> createState() =>
      _SpecialInstructionsCardState();
}

class _SpecialInstructionsCardState extends State<_SpecialInstructionsCard> {
  bool _isExpanded = true;
  final TextEditingController _notesController = TextEditingController();
  static const int _maxChars = 250;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryContainer,
      borderRadius: BorderRadius.circular(18.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.goldColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Special Instructions (Optional)',
                      style: AppTypography.geist(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackgroundBright,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.bodySecondary,
                    size: 22.sp,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              SizedBox(height: 12.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppInputField(
                    controller: _notesController,
                    hint:
                        'Add gate code, meet at valet, flight number, special requests, etc.',
                    maxLength: _maxChars,
                    maxLines: 3,
                    showBorder: false,
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${_notesController.text.length}/$_maxChars',
                    style: AppTypography.geist(
                      fontSize: 11,
                      color: AppColors.hint,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
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
              width: 28.w,
              height: 28.w,
              color: AppColors.goldMid,
            ),
            Container(
              width: 2.w,
              height: 40.h,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                color: AppColors.goldMid.withValues(alpha: 0.85),
              ),
            ),
            Image.asset(
              'assets/icons/plane_icon.png',
              width: 28.w,
              height: 28.w,
              color: AppColors.goldMid,
            ),
          ],
        ),
        SizedBox(width: 14.w),
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
              SizedBox(height: 35.h),
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
    final columnWidth = (0.42.sw).clamp(130.0, 180.0);
    final imageWidth = (0.38.sw).clamp(120.0, 170.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
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
                (_) => Icon(
                  Icons.star_rate,
                  size: 18.sp,
                  color: AppColors.goldMid,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 28.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: columnWidth,
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
                  SizedBox(height: 4.h),
                  Text(
                    name,
                    style: AppTypography.geist(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.goldRing,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 11.h),
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
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                imageAsset,
                width: imageWidth,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => SizedBox(
                  height: 100.h,
                  width: 160.w,
                  child: Icon(
                    Icons.directions_car_filled_rounded,
                    color: AppColors.onSurfaceMuted,
                    size: 48.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
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
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Base Fare', style: rowLabel()),
            Text('\$$baseFare', style: rowValue()),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Service Fee', style: rowLabel()),
            Text('\$$serviceFee', style: rowValue()),
          ],
        ),
        SizedBox(height: 14.h),
        Container(height: 1, color: AppColors.goldMid.withValues(alpha: 0.55)),
        SizedBox(height: 14.h),
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
        SizedBox(height: 14.h),
        Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
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
                  width: 24.w,
                  height: 24.w,
                  color: AppColors.goldMid,
                ),
              ),
            ),
            SizedBox(width: 12.w),
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
                  SizedBox(height: 2.h),
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
