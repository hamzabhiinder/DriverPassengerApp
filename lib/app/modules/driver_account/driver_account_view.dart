import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/driver_profile_model.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/session_service.dart';
import '../../routes/app_routes.dart';

class DriverAccountController extends GetxController {
  final Rxn<DriverProfileModel> rxProfile = Rxn<DriverProfileModel>();

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>()
        .watchDriverProfile(uid)
        .listen((DriverProfileModel? profile) {
      rxProfile.value = profile;
    });
  }

  Future<void> signOut() async {
    await Get.find<SessionService>().logout();
  }
}

class DriverAccountView extends GetView<DriverAccountController> {
  const DriverAccountView({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final Widget body = Obx(() {
      final DriverProfileModel? profile = controller.rxProfile.value;
      final String email =
          Get.find<FirebaseAuthService>().currentUser?.email ?? '';
      return ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          if (embedded) ...[
            Text(
              'Account',
              style: AppTypography.geist(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          Center(
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.person, color: AppColors.goldColor, size: 40.sp),
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: Text(
              profile?.displayName ?? 'Driver',
              style: AppTypography.castoro(fontSize: 24, color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              email,
              style: AppTypography.geist(
                fontSize: 13,
                color: AppColors.bodySecondary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: AppColors.goldColor, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  (profile?.rating ?? 5).toStringAsFixed(2),
                  style: AppTypography.geist(
                    fontSize: 14,
                    color: AppColors.goldColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          _infoTile('Vehicle', profile?.vehicleLabel ?? 'BlackX Chauffeur'),
          _infoTile('Phone', profile?.phone ?? 'Not set'),
          _infoTile(
            'Status',
            profile?.isOnline == true ? 'Online' : 'Offline',
          ),
          _infoTile(
            'Acceptance rate',
            '${(profile?.acceptanceRate ?? 100).toStringAsFixed(0)}%',
          ),
          SizedBox(height: 12.h),
          OutlinedButton(
            onPressed: () => Get.toNamed(AppRoutes.driverSettings),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.goldColor,
              side: BorderSide(color: AppColors.goldColor),
              minimumSize: Size(double.infinity, 44.h),
            ),
            child: const Text('Open settings'),
          ),
          SizedBox(height: 8.h),
          OutlinedButton(
            onPressed: () => Get.toNamed(AppRoutes.driverVehicle),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.goldColor,
              side: BorderSide(color: AppColors.goldColor),
              minimumSize: Size(double.infinity, 44.h),
            ),
            child: const Text('Manage vehicle'),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: controller.signOut,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48.h),
            ),
            child: const Text('Log Out'),
          ),
        ],
      );
    });
    if (embedded) {
      return ColoredBox(color: AppColors.background, child: body);
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back, color: AppColors.goldColor, size: 22.sp),
        ),
        title: Text(
          'Account',
          style: AppTypography.geist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: body,
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.geist(
                fontSize: 13,
                color: AppColors.bodySecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
