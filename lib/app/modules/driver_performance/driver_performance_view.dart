import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/models/driver_profile_model.dart';
import '../../data/models/ride_request_model.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class DriverPerformanceController extends GetxController {
  final Rxn<DriverProfileModel> rxProfile = Rxn<DriverProfileModel>();
  final RxList<RideRequestModel> rxTrips = <RideRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    final FirestoreService firestore = Get.find<FirestoreService>();
    firestore.watchDriverProfile(uid).listen((DriverProfileModel? p) {
      rxProfile.value = p;
    });
    firestore.watchDriverTrips(uid).listen(rxTrips.assignAll);
  }

  int get completedCount =>
      rxTrips.where((RideRequestModel r) => r.status == 'completed').length;

  int get declinedCount =>
      rxTrips.where((RideRequestModel r) => r.status == 'declined').length;

  double get acceptanceRate {
    final int total = completedCount + declinedCount;
    if (total == 0) {
      return rxProfile.value?.acceptanceRate ?? 100;
    }
    return (completedCount / total) * 100;
  }
}

class DriverPerformanceView extends GetView<DriverPerformanceController> {
  const DriverPerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Performance',
      body: Obx(() {
        final DriverProfileModel? profile = controller.rxProfile.value;
        return ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _metric('Rating', (profile?.rating ?? 5).toStringAsFixed(2)),
            _metric(
              'Acceptance rate',
              '${controller.acceptanceRate.toStringAsFixed(0)}%',
            ),
            _metric('Completed trips', '${controller.completedCount}'),
            _metric('Declined trips', '${controller.declinedCount}'),
            _metric(
              'Hours online today',
              (profile?.hoursOnlineToday ?? 0).toStringAsFixed(1),
            ),
            _metric(
              "Today's earnings",
              '\$${(profile?.earningsTodayUsd ?? 0).toStringAsFixed(2)}',
            ),
          ],
        );
      }),
    );
  }

  Widget _metric(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.geist(fontSize: 14, color: AppColors.bodySecondary),
            ),
          ),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.goldColor,
            ),
          ),
        ],
      ),
    );
  }
}
