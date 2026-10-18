import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/demo_credentials.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';

class PassengerLoginController extends GetxController {
  final phoneController = TextEditingController(text: DemoCredentials.riderPhone);
  final RxBool rxIsLoading = false.obs;

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
    final String raw = phoneController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
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
      for (final TextEditingController c in _otpControllers!) {
        c.clear();
      }
    }
    Get.toNamed<void>(AppRoutes.passengerOtpScreen);
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      Get.snackbar(
        'Demo OTP',
        'Use code ${DemoCredentials.riderOtp}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB88E2F),
        colorText: Colors.black,
        margin: const EdgeInsets.all(16),
      );
    });
  }

  Future<void> verify() async {
    if (rxIsLoading.value) {
      return;
    }
    final String otp = otpControllers.map((TextEditingController e) => e.text).join();
    if (otp != DemoCredentials.riderOtp) {
      Get.snackbar(
        'Invalid code',
        'Demo OTP is ${DemoCredentials.riderOtp}',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    rxIsLoading.value = true;
    try {
      final FirebaseAuthService auth = Get.find<FirebaseAuthService>();
      final credential = await auth.signInWithEmailPassword(
        DemoCredentials.riderEmail,
        DemoCredentials.riderPassword,
      );
      if (credential == null) {
        return;
      }
      final String passengerId = credential.user!.uid;
      final String phone = phoneController.text.trim();
      bool hasProfile = false;
      try {
        await Get.find<FirestoreService>().ensurePassengerProfile(
          passengerId: passengerId,
          displayName: 'BlackX Rider',
          phone: phone,
        );
        final snapshot =
            await Get.find<FirestoreService>().getPassengerDoc(passengerId);
        final String? name = snapshot.data()?['displayName'] as String?;
        hasProfile = name != null && name.trim().isNotEmpty && name != 'Rider';
      } on Object catch (error) {
        debugPrint('Passenger profile sync skipped: $error');
      }
      if (hasProfile) {
        Get.offAllNamed<void>(AppRoutes.passengerWhereTo);
        return;
      }
      Get.offAllNamed<void>(
        AppRoutes.passengerCreateProfile,
        arguments: <String, dynamic>{'phone': phone},
      );
    } on Object catch (error) {
      Get.snackbar(
        'Login failed',
        '$error',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      rxIsLoading.value = false;
    }
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
