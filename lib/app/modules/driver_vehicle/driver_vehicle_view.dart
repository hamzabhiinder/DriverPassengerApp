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

class DriverVehicleController extends GetxController {
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

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
        makeController.text = data['vehicleMake'] as String? ?? '';
        modelController.text = data['vehicleModel'] as String? ?? '';
        plateController.text = data['vehiclePlate'] as String? ?? '';
        colorController.text = data['vehicleColor'] as String? ?? '';
        yearController.text = '${data['vehicleYear'] ?? ''}';
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
        'vehicleMake': makeController.text.trim(),
        'vehicleModel': modelController.text.trim(),
        'vehiclePlate': plateController.text.trim(),
        'vehicleColor': colorController.text.trim(),
        'vehicleYear': int.tryParse(yearController.text.trim()) ?? 2024,
        'vehicleLabel':
            '${makeController.text.trim()} ${modelController.text.trim()}'.trim(),
      },
    );
    Get.snackbar(
      'Vehicle saved',
      'Your vehicle details are up to date.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }

  @override
  void onClose() {
    makeController.dispose();
    modelController.dispose();
    plateController.dispose();
    colorController.dispose();
    yearController.dispose();
    super.onClose();
  }
}

class DriverVehicleView extends GetView<DriverVehicleController> {
  const DriverVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Vehicle',
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _field(controller.makeController, 'Make'),
          _field(controller.modelController, 'Model'),
          _field(controller.plateController, 'Plate number'),
          _field(controller.colorController, 'Color'),
          _field(controller.yearController, 'Year', keyboard: TextInputType.number),
          SizedBox(height: 16.h),
          AppPrimaryButton(label: 'Save vehicle', onPressed: controller.save),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.bodySecondary),
          filled: true,
          fillColor: const Color(0xFF141414),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
