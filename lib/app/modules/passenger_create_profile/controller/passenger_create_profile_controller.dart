import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class PassengerCreateProfileController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  void continueToApp() {
    Get.offAllNamed<void>(AppRoutes.passengerWhereTo);
  }

  void continueWithGoogle() {
    continueToApp();
  }

  void continueWithApple() {
    continueToApp();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
