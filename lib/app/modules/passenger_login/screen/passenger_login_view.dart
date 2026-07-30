import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/black_x_brand_header.dart';
import '../../../core/widgets/glowing_divider.dart';
import '../controller/passenger_login_controller.dart';

class PassengerLoginView extends GetView<PassengerLoginController> {
  const PassengerLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double topInset = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hero Escalade — upper half, biased right (matches mockup)
          Positioned(
            top: topInset + 70.h,
            right: -200.w,
            left: 40.w,
            height: 0.38.sh,
            child: Image.asset(
              'assets/images/escalade.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
          // Fade hero into black so form content stays readable
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.15),
                    AppColors.background.withValues(alpha: 0.55),
                    AppColors.background.withValues(alpha: 0.92),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.28, 0.48, 0.62],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h + bottomInset),
              child: Column(
                children: [
                  SizedBox(height: 4.h),
                  const BlackXBrandHeader(
                    logoHeight: 210,
                    compact: true,
                  ),
                  const Spacer(flex: 2),
                  Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: AppTypography.display(
                      
                      color: AppColors.onBackgroundBright,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const GlowingDivider(),
                  SizedBox(height: 14.h),
                  Text(
                    'Enter your phone number to continue',
                    textAlign: TextAlign.center,
                    style: AppTypography.label(
                      
                      color: AppColors.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  _buildPhoneField(),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: AppColors.goldColor,
                            size: 24.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Icon(
                              Icons.lock,
                              color: AppColors.goldColor,
                              size: 10.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          "We'll send you a one-time PIN code to securely sign you in.",
                          style: AppTypography.label(
                          
                            color: AppColors.bodySecondary.withValues(alpha: 0.6),
                            // height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  _buildContinueButton(),
                  const Spacer(flex: 2),
                  _buildSupportFooter(),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return AppInputField(
      controller: controller.phoneController,
      hint: '(555) 123-4567',
      keyboardType: TextInputType.phone,
      isPill: true,
      prefix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.phone_outlined,
            color: AppColors.goldColor,
            size: AppSizes.inputIconSize,
          ),
          const SizedBox(width: 10),
          Text(
            '+1',
            style: AppTypography.subtitle(color: Colors.white),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.goldColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 20,
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return AppPrimaryButton(
      label: 'Continue',
      onPressed: controller.sendOtp,
    );
  }

  Widget _buildSupportFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.goldColor.withValues(alpha: 0.55),
              width: 1.2.w,
            ),
          ),
          child: Icon(
            Icons.headset_mic_outlined,
            color: AppColors.goldColor,
            size: 18.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help?',
              style: AppTypography.geist(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppColors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Row(
              children: [
                Text(
                  'Contact Support',
                  style: AppTypography.geist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.goldColor,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.goldColor,
                  size: 16.sp,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
