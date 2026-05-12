import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class PassengerLoginController extends GetxController {
  final phoneController = TextEditingController();

  List<TextEditingController>? _otpControllers;
  List<FocusNode>? _focusNodes;

  List<TextEditingController> get otpControllers {
    _otpControllers ??= List.generate(4, (_) => TextEditingController());
    return _otpControllers!;
  }

  List<FocusNode> get focusNodes {
    _focusNodes ??= List.generate(4, (_) => FocusNode());
    return _focusNodes!;
  }

  void sendOtp() {
    final raw = phoneController.text.trim();
    if (raw.isEmpty) {
      Get.snackbar(
        'Phone number',
        'Enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    if (_otpControllers != null) {
      for (final c in _otpControllers!) {
        c.clear();
      }
    }
    // TODO: integrate OTP API; navigate after success.
    // Keep login route under OTP so this controller is not disposed (offAllNamed would dispose it).
    Get.toNamed<void>(AppRoutes.passengerOtpScreen);
  }

  void verify() {
    final otp = otpControllers.map((e) => e.text).join();
    debugPrint('Verifying OTP: $otp');
    Get.offAllNamed<void>(AppRoutes.passengerHome);
  }

  void changeNumber() {
    Get.back();
  }

  @override
  void onClose() {
    phoneController.dispose();
    final otp = _otpControllers;
    if (otp != null) {
      for (final c in otp) {
        c.dispose();
      }
    }
    final nodes = _focusNodes;
    if (nodes != null) {
      for (final n in nodes) {
        n.dispose();
      }
    }
    super.onClose();
  }
}
