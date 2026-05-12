import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Image.asset('assets/images/logo.png', width: 150),
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 24 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 44,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onBackgroundBright,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your phone number to continue',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 24,
                  fontWeight: FontWeight.w200,
                  color: AppColors.bodySecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
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
                    padding: const EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.phone_outlined,
                      color: AppColors.onSurface,
                      size: 22,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(color: AppColors.outline),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GoldGradientCtaButton(
                label: 'Send OTP',
                onPressed: controller.sendOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
