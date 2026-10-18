import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/driver_profile_model.dart';
import '../../data/models/ride_request_model.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class DriverEarningsController extends GetxController {
  final Rxn<DriverProfileModel> rxProfile = Rxn<DriverProfileModel>();
  final RxList<RideRequestModel> rxCompleted = <RideRequestModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    final FirestoreService firestore = Get.find<FirestoreService>();
    firestore.watchDriverProfile(uid).listen((DriverProfileModel? profile) {
      rxProfile.value = profile;
    });
    firestore.watchDriverTrips(uid).listen((List<RideRequestModel> trips) {
      rxCompleted.assignAll(
        trips.where((RideRequestModel ride) => ride.status == 'completed'),
      );
    });
  }

  double get weekTotal => rxCompleted.fold<double>(
        0,
        (double sum, RideRequestModel ride) => sum + ride.fareUsd,
      );
}

class DriverEarningsView extends GetView<DriverEarningsController> {
  const DriverEarningsView({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final Widget body = Obx(() {
      final DriverProfileModel? profile = controller.rxProfile.value;
      return ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          if (embedded) ...[
            Text(
              'Earnings',
              style: AppTypography.geist(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFB88E2F), Color(0xFF966C2D)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's earnings",
                  style: AppTypography.geist(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '\$${(profile?.earningsTodayUsd ?? 0).toStringAsFixed(2)}',
                  style: AppTypography.castoro(
                    fontSize: 34,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${profile?.ridesCompleted ?? 0} completed trips  ·  '
                  '${(profile?.hoursOnlineToday ?? 0).toStringAsFixed(1)}h online',
                  style: AppTypography.geist(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Completed trips',
            style: AppTypography.geist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          if (controller.rxCompleted.isEmpty)
            Text(
              'Complete a trip to see earnings breakdown.',
              style: AppTypography.geist(
                fontSize: 13,
                color: AppColors.bodySecondary,
              ),
            )
          else
            ...controller.rxCompleted.map((RideRequestModel ride) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride.passengerName,
                            style: AppTypography.geist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ride.displayBookingCode,
                            style: AppTypography.geist(
                              fontSize: 12,
                              color: AppColors.bodySecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${ride.fareUsd.toStringAsFixed(2)}',
                      style: AppTypography.geist(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
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
          'Earnings',
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
}
