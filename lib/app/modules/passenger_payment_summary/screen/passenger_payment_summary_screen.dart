import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../controller/passenger_payment_summary_controller.dart';

class PassengerPaymentSummaryScreen
    extends GetView<PassengerPaymentSummaryController> {
  const PassengerPaymentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.paddingOf(context).bottom;
    final a = controller.args;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Get.back<void>(),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            shape: const CircleBorder(),
          ),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16.sp),
        ),
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
               
                Text(
                  'Secure Checkout',
                  style: AppTypography.castoro(
                    fontSize: AppFontSize.title,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onBackgroundBright,
                  ),
                ),
                SizedBox(width: 6.w),
                 Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.goldColor,
                  size: 16.sp,
                ),
                
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Review and confirm your booking',
              style: AppTypography.geist(
                fontSize: AppFontSize.caption,
                color: AppColors.bodySecondary.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h + bottom),
        children: [
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Summary',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.subtitle,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                _routeTimeline(
                  pickupTitle: a.pickupLabel,
                  pickupSubtitle: a.pickupAddress ?? "No Address",
                  destinationTitle: a.destinationLabel,
                  destinationSubtitle: a.destinationAddress,
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: _meta(
                        icon: Icons.directions_car_outlined,
                        label: 'Ride Type',
                        value: a.vehicleCategory,
                      ),
                    ),
                    _metaDivider(),
                    Expanded(
                      child: _meta(
                        icon: Icons.schedule,
                        label: 'ETA',
                        value: '${a.etaMinutes} min',
                      ),
                    ),
                    _metaDivider(),
                    Expanded(
                      child: _meta(
                        icon: Icons.person_outline,
                        label: 'Chauffeur',
                        value: 'Professional',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Summary',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.subtitle,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 14.h),
                _fareRow('Base Fare', '\$${a.baseFareUsd}'),
                SizedBox(height: 10.h),
                _fareRow('Service Fee', '\$${a.serviceFeeUsd}'),
                SizedBox(height: 12.h),
                Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTypography.geist(
                        fontSize: AppFontSize.subtitle,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldColor,
                      ),
                    ),
                    Text(
                      '\$${a.totalUsd}',
                      style: AppTypography.geist(
                        fontSize: AppFontSize.titleSmall,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _card(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  color: AppColors.goldColor,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Promo Code',
                    style: AppTypography.geist(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Add Code',
                  style: AppTypography.geist(
                    fontSize: AppFontSize.label,
                    fontWeight: FontWeight.w600,
                    color: AppColors.goldColor,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.goldColor,
                  size: 18.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Column(
              children: [
                _methodTile(
                  selected:
                      controller.method.value == PassengerPaymentMethod.card,
                  onTap: controller.selectCard,
                  icon: Icons.credit_card,
                  title: 'Credit Card',
                  subtitle: 'VISA ${a.cardMask}',
                  trailing: 'Change',
                  onTrailing: controller.onChangeCard,
                ),
                SizedBox(height: 10.h),
                _methodTile(
                  selected:
                      controller.method.value == PassengerPaymentMethod.wallet,
                  onTap: controller.selectWallet,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Wallet',
                  subtitle:
                      'Balance: \$${a.walletBalanceUsd.toStringAsFixed(2)}',
                  showChevron: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, color: AppColors.goldColor, size: 14.sp),
              SizedBox(width: 8.w),
              Container(
                width: 0.7.sw,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: AppTypography.geist(
                      fontSize: AppFontSize.overline,
                      color: AppColors.bodySecondary.withValues(alpha: 0.7),
                      height: 1.35,
                    ),
                    children: [
                      const TextSpan(text: 'Your '),
                      TextSpan(
                        text: 'payment is securely',
                        style: AppTypography.geist(
                          fontSize: AppFontSize.overline,
                          color: AppColors.bodySecondary.withValues(alpha: 0.9),
                          height: 1.35,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                      const TextSpan(
                        text: " encrypted. You won't be charged ",
                      ),
                      TextSpan(
                        text: 'until your ride is confirmed.',
                        style: AppTypography.geist(
                          fontSize: AppFontSize.overline,
                          color: AppColors.bodySecondary.withValues(alpha: 0.9),
                          height: 1.35,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            
              ],
            ),
          ),
          SizedBox(height: 20.h),
          AppPrimaryButton(
            label: 'Confirm & Pay \$${a.totalUsd}',
            onPressed: controller.onPay,
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.paymentSummaryCard,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: child,
    );
  }

  Widget _routeTimeline({
    required String pickupTitle,
    required String pickupSubtitle,
    required String destinationTitle,
    required String destinationSubtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.goldColor, width: 1.8),
              ),
            ),
            Container(
              width: 1.5,
              height: 36.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColors.goldColor.withValues(alpha: 0.55),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: CustomPaint(
                painter: _DashedLinePainter(
                  color: AppColors.goldColor.withValues(alpha: 0.55),
                ),
              ),
            ),
            Icon(
              Icons.location_on,
              color: AppColors.goldColor,
              size: 16.sp,
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pickupTitle,
                style: AppTypography.geist(
                  fontSize: AppFontSize.bodySmall,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                pickupSubtitle,
                style: AppTypography.geist(
                  fontSize: AppFontSize.overline,
                  color: AppColors.bodySecondary.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                destinationTitle,
                style: AppTypography.geist(
                  fontSize: AppFontSize.bodySmall,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                destinationSubtitle,
                style: AppTypography.geist(
                  fontSize: AppFontSize.overline,
                  color: AppColors.bodySecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _meta({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.goldColor, size: 18.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTypography.geist(
            fontSize: AppFontSize.micro,
            color: AppColors.bodySecondary.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTypography.geist(
            fontSize: AppFontSize.overline,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _metaDivider() {
    return Container(
      width: 1,
      height: 42.h,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _fareRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.geist(
            fontSize: AppFontSize.bodySmall,
            color: AppColors.bodySecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.geist(
            fontSize: AppFontSize.bodySmall,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _methodTile({
    required bool selected,
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
    VoidCallback? onTrailing,
    bool showChevron = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.paymentSummaryCard,
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            border: Border.all(
              color: selected
                  ? AppColors.goldColor
                  : Colors.white.withValues(alpha: 0.08),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(icon, color: AppColors.goldColor, size: 22.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.geist(
                          fontSize: AppFontSize.body,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: AppTypography.geist(
                          fontSize: AppFontSize.caption,
                          color: AppColors.bodySecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null)
                  GestureDetector(
                    onTap: onTrailing,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          trailing,
                          style: AppTypography.geist(
                            fontSize: AppFontSize.label,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldColor,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.goldColor,
                          size: 18.sp,
                        ),
                      ],
                    ),
                  )
                else if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.35),
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const double dashHeight = 3;
    const double dashSpace = 3;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
