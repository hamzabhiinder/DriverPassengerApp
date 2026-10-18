import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/demo_credentials.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_routes.dart';

class DriverLoginController extends GetxController {
  final emailController = TextEditingController(text: DemoCredentials.driverEmail);
  final passwordController = TextEditingController(text: DemoCredentials.driverPassword);

  final rxIsPasswordVisible = false.obs;
  final rxIsLoading = false.obs;
  final rxRememberMe = false.obs;

  void togglePasswordVisibility() {
    rxIsPasswordVisible.value = !rxIsPasswordVisible.value;
  }

  void toggleRememberMe() {
    rxRememberMe.value = !rxRememberMe.value;
  }

  Future<void> signIn() async {
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
    
    try {
      final authService = Get.find<FirebaseAuthService>();
      final userCredential = await authService.signInWithEmailPassword(email, password);
      
      if (userCredential != null) {
        final FirestoreService firestore = Get.find<FirestoreService>();
        await firestore.ensureDriverProfile(
          driverId: userCredential.user!.uid,
          email: email,
          displayName: email.split('@').first,
        );
        Get.offNamed(AppRoutes.driverHome);
      }
    } catch (e) {
      print('Login error: $e');
    } finally {
      rxIsLoading.value = false;
    }
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
