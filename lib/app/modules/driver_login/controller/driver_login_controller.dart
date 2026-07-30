import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class DriverLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final rxIsPasswordVisible = false.obs;
  final rxIsLoading = false.obs;
  final rxRememberMe = false.obs;

  void togglePasswordVisibility() {
    rxIsPasswordVisible.value = !rxIsPasswordVisible.value;
  }

  void toggleRememberMe() {
    rxRememberMe.value = !rxRememberMe.value;
  }

  void signIn() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter both email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    rxIsLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      rxIsLoading.value = false;
      Get.offNamed(AppRoutes.driverHome);
    });
  }

  void changeNumber() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
