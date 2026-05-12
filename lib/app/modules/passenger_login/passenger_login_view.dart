import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gold_gradient_cta_button.dart';
import 'passenger_login_controller.dart';
import 'widgets/black_line_logo.dart';

class PassengerLoginView extends GetView<PassengerLoginController> {
  const PassengerLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 24 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const BlackLineLogo(),
              const SizedBox(height: 48),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackgroundBright,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your phone number to continue',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
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
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColors.onSurface,
                    size: 22,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
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
