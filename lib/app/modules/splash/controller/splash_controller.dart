import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_role.dart';
import '../../../data/services/role_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final RoleService _roleService = Get.find<RoleService>();
 
  final RxBool showPremiumSplash = false.obs;

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runIntroSequence();
    });
  }

  Future<void> _runIntroSequence() async {
    final context = Get.context;
    if (context != null && context.mounted) {
      precacheImage(const AssetImage('assets/images/car_image.png'), context);
    }
    await Future<void>.delayed(const Duration(milliseconds: 900));
    showPremiumSplash.value = true;
  }

  void onStartRide() {
    final role = _roleService.currentRole.value;
    if (role == UserRole.driver) {
      Get.offAllNamed<void>(AppRoutes.driverHome);
    } else if (role == UserRole.passenger) {
      Get.offAllNamed<void>(AppRoutes.passengerLogin);
    } else {
      Get.offAllNamed<void>(AppRoutes.roleSelect);
    }
  }
}
