import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_login_controller.dart';

class PassengerOtpScreenView extends GetView<PassengerLoginController> {
  const PassengerOtpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final boxSize = (1.sw / 6).clamp(48.0, 65.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150.w,
                ),
              ),
              const Spacer(),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 40,
                  color: AppColors.onBackgroundBright,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Enter your phone number\nto continue',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 18,
                  color: AppColors.bodySecondary,
                  fontWeight: FontWeight.w300,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _OtpBox(index: index, size: boxSize),
                ),
              ),
              SizedBox(height: 32.h),
              GoldGradientCtaButton(
                label: 'Verify & Continue',
                onPressed: controller.verify,
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: controller.changeNumber,
                child: Text(
                  'Change Number',
                  style: AppTypography.geist(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.goldRing,
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends GetView<PassengerLoginController> {
  const _OtpBox({required this.index, required this.size});

  final int index;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTypography.geist(
            color: AppColors.onBackgroundBright,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 10.h),
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              controller.focusNodes[index + 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
