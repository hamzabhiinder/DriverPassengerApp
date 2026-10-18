import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/ride_request_model.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class DriverTripsController extends GetxController {
  final RxList<RideRequestModel> rxTrips = <RideRequestModel>[].obs;
  final RxString rxFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchDriverTrips(uid).listen(rxTrips.assignAll);
  }

  List<RideRequestModel> get filteredTrips {
    if (rxFilter.value == 'all') {
      return rxTrips;
    }
    return rxTrips
        .where((RideRequestModel ride) => ride.status == rxFilter.value)
        .toList();
  }
}

class DriverTripsView extends GetView<DriverTripsController> {
  const DriverTripsView({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      children: [
        if (embedded)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trips',
                style: AppTypography.geist(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        SizedBox(
          height: 40.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              _chip('all', 'All'),
              _chip('completed', 'Completed'),
              _chip('accepted', 'Active'),
              _chip('declined', 'Declined'),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final List<RideRequestModel> trips = controller.filteredTrips;
            if (trips.isEmpty) {
              return Center(
                child: Text(
                  'No trips yet. Go online to receive requests.',
                  style: AppTypography.geist(
                    fontSize: 13,
                    color: AppColors.bodySecondary,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: trips.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (BuildContext context, int index) {
                final RideRequestModel trip = trips[index];
                return Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              trip.displayBookingCode,
                              style: AppTypography.geist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.goldColor,
                              ),
                            ),
                          ),
                          Text(
                            trip.status.toUpperCase(),
                            style: AppTypography.geist(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        trip.passengerName,
                        style: AppTypography.geist(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${trip.pickupLabel} → ${trip.destinationLabel}',
                        style: AppTypography.geist(
                          fontSize: 12,
                          color: AppColors.bodySecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '\$${trip.fareUsd.toStringAsFixed(2)}',
                        style: AppTypography.geist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
    if (embedded) {
      return ColoredBox(color: AppColors.background, child: content);
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
          'Trips',
          style: AppTypography.geist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: content,
    );
  }

  Widget _chip(String value, String label) {
    return Obx(() {
      final bool selected = controller.rxFilter.value == value;
      return Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => controller.rxFilter.value = value,
          selectedColor: AppColors.goldColor,
          labelStyle: AppTypography.geist(
            fontSize: 12,
            color: selected ? Colors.black : Colors.white,
          ),
          backgroundColor: const Color(0xFF1A1A1A),
        ),
      );
    });
  }
}
