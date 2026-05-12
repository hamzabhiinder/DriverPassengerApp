import 'package:driver_passenger_app/app/core/widgets/gold_gradient_cta_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_typography.dart';
import '../controller/passenger_login_controller.dart';

class PassengerOtpScreenView extends GetView<PassengerLoginController> {
  const PassengerOtpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset('assets/images/logo.png', width: 180)),
              const Spacer(),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: AppTypography.castoro(
                  fontSize: 42,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Enter your phone number\nto continue',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 24,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w300,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: 40),
              GoldGradientCtaButton(
                label: 'Verify & Continue',
                onPressed: controller.verify,
              ),
              const SizedBox(height: 25),
              TextButton(
                onPressed: controller.changeNumber,
                child: const Text(
                  'Change Number',
                  style: TextStyle(
                    color: Color(0xFFC39E4D),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

  Widget _buildOtpBox(int index) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 12),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            controller.focusNodes[index + 1].requestFocus();
          }
        },
      ),
    );
  }
}
