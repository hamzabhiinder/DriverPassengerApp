import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/session_service.dart';
import '../../routes/app_routes.dart';

class PassengerAccountController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final RxBool notifyRideUpdates = true.obs;
  final RxBool notifyPromos = true.obs;
  final RxDouble rxWallet = 0.0.obs;
  final RxDouble rxRating = 5.0.obs;
  bool _didBindFields = false;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSub;

  String? get _uid => Get.find<FirebaseAuthService>().currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    _profileSub = Get.find<FirestoreService>().watchPassengerDoc(uid).listen(
      _applyDoc,
      onError: (Object error) => Get.log('Account watch skipped: $error'),
    );
  }

  void _applyDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    if (!_didBindFields) {
      nameController.text = data['displayName'] as String? ?? '';
      phoneController.text = data['phone'] as String? ?? '';
      _didBindFields = true;
    }
    notifyRideUpdates.value = data['notifyRideUpdates'] as bool? ?? true;
    notifyPromos.value = data['notifyPromos'] as bool? ?? true;
    rxWallet.value = (data['walletBalanceUsd'] as num?)?.toDouble() ?? 0;
    rxRating.value = (data['rating'] as num?)?.toDouble() ?? 5;
  }

  Future<void> save() async {
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    final String name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Required', 'Enter your name.');
      return;
    }
    await Get.find<FirestoreService>().updatePassengerFields(
      uid,
      <String, dynamic>{
        'displayName': name,
        'phone': phoneController.text.trim(),
        'notifyRideUpdates': notifyRideUpdates.value,
        'notifyPromos': notifyPromos.value,
      },
    );
    Get.snackbar(
      'Saved',
      'Account settings updated.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }

  Future<void> signOut() async {
    await Get.find<SessionService>().logout();
  }

  @override
  void onClose() {
    _profileSub?.cancel();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

class PassengerAccountView extends GetView<PassengerAccountController> {
  const PassengerAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Account settings',
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Obx(
            () => Text(
              'Wallet \$${controller.rxWallet.value.toStringAsFixed(2)} · Rating ${controller.rxRating.value.toStringAsFixed(2)}',
              style: AppTypography.geist(fontSize: 13, color: AppColors.goldColor),
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: controller.nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _decoration('Display name'),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller.phoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: _decoration('Phone number'),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => SwitchListTile(
              value: controller.notifyRideUpdates.value,
              onChanged: (bool value) => controller.notifyRideUpdates.value = value,
              activeThumbColor: AppColors.goldColor,
              title: Text(
                'Ride updates',
                style: AppTypography.geist(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          Obx(
            () => SwitchListTile(
              value: controller.notifyPromos.value,
              onChanged: (bool value) => controller.notifyPromos.value = value,
              activeThumbColor: AppColors.goldColor,
              title: Text(
                'Promotions',
                style: AppTypography.geist(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          AppPrimaryButton(label: 'Save settings', onPressed: controller.save),
          SizedBox(height: 16.h),
          _link('Wallet', AppRoutes.passengerWallet),
          _link('My cards', AppRoutes.passengerCards),
          _link('Saved places', AppRoutes.passengerSavedPlaces),
          _link('Support', AppRoutes.passengerSupport),
          _link('Terms & conditions', AppRoutes.passengerTerms),
          SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: controller.signOut,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              minimumSize: Size(double.infinity, 48.h),
            ),
            child: const Text('Logout account'),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.bodySecondary),
      filled: true,
      fillColor: const Color(0xFF141414),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _link(String label, String route) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: AppTypography.geist(fontSize: 14, color: Colors.white),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.goldColor),
      onTap: () => Get.toNamed(route),
    );
  }
}
