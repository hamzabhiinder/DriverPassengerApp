import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_payment_summary_controller.dart';

class PassengerPaymentSummaryScreen
    extends GetView<PassengerPaymentSummaryController> {
  const PassengerPaymentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              const _PaymentSuccessMark(),
              SizedBox(height: 24.h),
              _PaymentSummaryCard(controller: controller),
              SizedBox(height: 20.h),
              Obx(
                () => _PaymentMethodBlock(
                  controller: controller,
                  selectedMethod: controller.method.value,
                ),
              ),
              SizedBox(height: 12.h),
              GoldGradientCtaButton(
                label: 'Pay \$${controller.args.totalUsd}',
                onPressed: controller.onPay,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentSuccessMark extends StatelessWidget {
  const _PaymentSuccessMark();

  @override
  Widget build(BuildContext context) {
    final ringSpecs = [200.0, 168.0, 136.0, 108.0];

    return SizedBox(
      height: 220.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (final d in ringSpecs)
            IgnorePointer(
              child: Container(
                width: d.w,
                height: d.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
              ),
            ),
          AvatarGlow(
            animate: true,
            repeat: true,
            glowShape: BoxShape.circle,
            glowColor: AppColors.goldMid.withValues(alpha: 0.5),
            glowCount: 2,
            glowRadiusFactor: 1.22,
            duration: const Duration(milliseconds: 2400),
            curve: Curves.easeInOutCubic,
            child: SizedBox(
              width: 88.w,
              height: 88.w,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldRing,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x664A3D0A),
                      blurRadius: 26.r,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.background,
                    size: 52.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  const _PaymentSummaryCard({required this.controller});

  final PassengerPaymentSummaryController controller;

  @override
  Widget build(BuildContext context) {
    final a = controller.args;
    TextStyle label() => AppTypography.geist(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.bodySecondary,
    );
    TextStyle value() => AppTypography.geist(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.onBackgroundBright,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.paymentSummaryCard,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Payment Summary',
              style: AppTypography.geist(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.onBackgroundBright,
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Base Fare', style: label()),
                Text('\$${a.baseFareUsd}', style: value()),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service Fee', style: label()),
                Text('\$${a.serviceFeeUsd}', style: value()),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              height: 1,
              color: AppColors.goldRing.withValues(alpha: 0.75),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTypography.geist(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackgroundBright,
                  ),
                ),
                Text(
                  '\$${a.totalUsd}',
                  style: AppTypography.geist(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldRing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodBlock extends StatelessWidget {
  const _PaymentMethodBlock({
    required this.controller,
    required this.selectedMethod,
  });

  final PassengerPaymentSummaryController controller;
  final PassengerPaymentMethod selectedMethod;

  @override
  Widget build(BuildContext context) {
    final m = selectedMethod;
    final a = controller.args;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PaymentMethodTile(
          selected: m == PassengerPaymentMethod.card,
          onTap: controller.selectCard,
          leading: Image.asset(
            'assets/icons/card_icon.png',
            width: 28.w,
            height: 28.w,
          ),
          title: 'Credit Card',
          subtitle: a.cardMask,
          trailing: m == PassengerPaymentMethod.card
              ? TextButton(
                  onPressed: controller.onChangeCard,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.goldRing,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Change',
                    style: AppTypography.geist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldRing,
                    ),
                  ),
                )
              : null,
        ),
        SizedBox(height: 12.h),
        _PaymentMethodTile(
          selected: m == PassengerPaymentMethod.wallet,
          onTap: controller.selectWallet,
          leading: Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.goldRing,
            size: 28.sp,
          ),
          title: 'Wallet',
          subtitle: 'Balance: \$${a.walletBalanceUsd.toStringAsFixed(2)}',
          trailing: null,
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.selected,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.paymentSummaryCard,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: selected ? AppColors.goldRing : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                SizedBox(width: 36.w, child: Center(child: leading)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.geist(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onBackgroundBright,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: AppTypography.geist(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.bodySecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
