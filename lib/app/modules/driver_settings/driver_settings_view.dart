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

class DriverSettingsController extends GetxController {
  final RxBool notifyNewRides = true.obs;
  final RxBool notifyEarnings = true.obs;
  final RxBool shareLiveLocation = true.obs;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchDriverDoc(uid).listen(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
        notifyNewRides.value = data['notifyNewRides'] as bool? ?? true;
        notifyEarnings.value = data['notifyEarnings'] as bool? ?? true;
        shareLiveLocation.value = data['shareLiveLocation'] as bool? ?? true;
        phoneController.text = data['phone'] as String? ?? '';
        nameController.text = data['displayName'] as String? ?? '';
      },
    );
  }

  Future<void> save() async {
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    await Get.find<FirestoreService>().updateDriverFields(
      uid,
      <String, dynamic>{
        'notifyNewRides': notifyNewRides.value,
        'notifyEarnings': notifyEarnings.value,
        'shareLiveLocation': shareLiveLocation.value,
        'phone': phoneController.text.trim(),
        'displayName': nameController.text.trim(),
      },
    );
    Get.snackbar(
      'Saved',
      'Settings updated successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }
}

class DriverSettingsView extends GetView<DriverSettingsController> {
  const DriverSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Settings',
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
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
          SizedBox(height: 12.h),
          Obx(
            () => SwitchListTile(
              value: controller.notifyNewRides.value,
              onChanged: (bool v) => controller.notifyNewRides.value = v,
              activeThumbColor: AppColors.goldColor,
              title: Text(
                'New ride alerts',
                style: AppTypography.geist(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          Obx(
            () => SwitchListTile(
              value: controller.notifyEarnings.value,
              onChanged: (bool v) => controller.notifyEarnings.value = v,
              activeThumbColor: AppColors.goldColor,
              title: Text(
                'Earnings alerts',
                style: AppTypography.geist(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          Obx(
            () => SwitchListTile(
              value: controller.shareLiveLocation.value,
              onChanged: (bool v) => controller.shareLiveLocation.value = v,
              activeThumbColor: AppColors.goldColor,
              title: Text(
                'Share live location when online',
                style: AppTypography.geist(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          AppPrimaryButton(label: 'Save settings', onPressed: controller.save),
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
}
