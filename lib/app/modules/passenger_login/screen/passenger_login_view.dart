import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_responsive.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_login_controller.dart';

class PassengerLoginView extends GetView<PassengerLoginController> {
  const PassengerLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 120.w,
                height: 120.h,
              ),
              const Spacer(),

              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Enter your phone number\nto continue',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: AppColors.bodySecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32.h),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                autocorrect: false,
                style: AppTypography.geist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primaryContainer,
                  hintText: '+971 50 123 4567',
                  hintStyle: AppTypography.geist(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.hint,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Icon(
                      Icons.phone_outlined,
                      color: AppColors.onSurface,
                      size: 22.sp,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999.r),
                    borderSide: const BorderSide(color: AppColors.outline),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              GoldGradientCtaButton(
                label: 'Send OTP',
                onPressed: controller.sendOtp,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResponsiveDebugStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        'Screen: ${1.sw.toStringAsFixed(0)}×${1.sh.toStringAsFixed(0)} dp  •  '
        'design ${AppResponsive.designSize.width.toInt()}×${AppResponsive.designSize.height.toInt()}',
        textAlign: TextAlign.center,
        style: AppTypography.geist(
          fontSize: 11,
          color: AppColors.onSurfaceMuted,
        ),
      ),
    );
  }
}
