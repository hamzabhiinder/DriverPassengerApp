import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/models/ride_request_model.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../routes/app_routes.dart';

class PassengerScheduledController extends GetxController {
  final RxList<RideRequestModel> rxTrips = <RideRequestModel>[].obs;

  String? get _uid => Get.find<FirebaseAuthService>().currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchPassengerRides(uid).listen((List<RideRequestModel> trips) {
      rxTrips.assignAll(
        trips.where((RideRequestModel ride) => ride.status == 'scheduled'),
      );
    });
  }

  void openScheduler() {
    Get.toNamed(AppRoutes.passengerSchedule);
  }

  Future<void> cancelTrip(RideRequestModel trip) async {
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    await Get.find<FirestoreService>().cancelRide(
      rideId: trip.id,
      passengerId: uid,
    );
  }
}

class PassengerScheduledView extends GetView<PassengerScheduledController> {
  const PassengerScheduledView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Scheduled rides',
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.rxTrips.isEmpty) {
                return Center(
                  child: Text(
                    'No upcoming rides.',
                    style: AppTypography.geist(
                      fontSize: 13,
                      color: AppColors.bodySecondary,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.rxTrips.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (BuildContext context, int index) {
                  final RideRequestModel trip = controller.rxTrips[index];
                  return Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.displayBookingCode,
                          style: AppTypography.geist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '${trip.pickupLabel} → ${trip.destinationLabel}',
                          style: AppTypography.geist(fontSize: 14, color: Colors.white),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          trip.scheduledAt == null
                              ? trip.vehicleCategory
                              : '${trip.vehicleCategory} · ${trip.scheduledAt!.toLocal().toString().substring(0, 16)}',
                          style: AppTypography.geist(
                            fontSize: 12,
                            color: AppColors.bodySecondary,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => controller.cancelTrip(trip),
                            child: Text(
                              'Cancel',
                              style: AppTypography.geist(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: AppPrimaryButton(
              label: 'Schedule a ride',
              onPressed: controller.openScheduler,
            ),
          ),
        ],
      ),
    );
  }
}
