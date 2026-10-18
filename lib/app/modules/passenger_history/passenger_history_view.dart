import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/models/ride_request_model.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../routes/app_routes.dart';

class PassengerHistoryController extends GetxController {
  final RxList<RideRequestModel> rxTrips = <RideRequestModel>[].obs;
  final RxString rxFilter = 'all'.obs;

  String? get _uid => Get.find<FirebaseAuthService>().currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchPassengerRides(uid).listen(rxTrips.assignAll);
  }

  List<RideRequestModel> get filteredTrips {
    if (rxFilter.value == 'all') {
      return rxTrips;
    }
    return rxTrips
        .where((RideRequestModel ride) => ride.status == rxFilter.value)
        .toList();
  }

  void openTrip(RideRequestModel trip) {
    if (trip.status == 'completed' && trip.rating == null) {
      Get.toNamed(
        AppRoutes.passengerRateRide,
        arguments: <String, dynamic>{
          'rideId': trip.id,
          'chauffeurName': 'Your chauffeur',
          'baseFareUsd': trip.fareUsd.round(),
        },
      );
      return;
    }
    if (trip.status == 'cancelled' || trip.status == 'declined') {
      return;
    }
    Get.toNamed(
      AppRoutes.passengerChauffeurAssigned,
      arguments: <String, dynamic>{
        'rideId': trip.id,
        'vehicleModel': trip.vehicleCategory,
        'baseFareUsd': trip.fareUsd.round(),
      },
    );
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
    Get.snackbar(
      'Cancelled',
      'This ride was cancelled.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }
}

class PassengerHistoryView extends GetView<PassengerHistoryController> {
  const PassengerHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Ride history',
      body: Column(
        children: [
          SizedBox(
            height: 44.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              children: [
                _chip('all', 'All'),
                _chip('scheduled', 'Scheduled'),
                _chip('pending', 'Requested'),
                _chip('completed', 'Completed'),
                _chip('cancelled', 'Cancelled'),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final List<RideRequestModel> trips = controller.filteredTrips;
              if (trips.isEmpty) {
                return Center(
                  child: Text(
                    'No rides yet.',
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
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (BuildContext context, int index) {
                  return _TripTile(trip: trips[index]);
                },
              );
            }),
          ),
        ],
      ),
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
          backgroundColor: const Color(0xFF141414),
        ),
      );
    });
  }
}

class _TripTile extends GetView<PassengerHistoryController> {
  const _TripTile({required this.trip});

  final RideRequestModel trip;

  @override
  Widget build(BuildContext context) {
    final bool canCancel =
        trip.status == 'pending' || trip.status == 'scheduled' || trip.status == 'accepted';
    return InkWell(
      onTap: () => controller.openTrip(trip),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
                  style: AppTypography.geist(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '${trip.pickupLabel} → ${trip.destinationLabel}',
              style: AppTypography.geist(fontSize: 13, color: Colors.white),
            ),
            SizedBox(height: 6.h),
            Text(
              '${trip.vehicleCategory} · \$${trip.fareUsd.toStringAsFixed(2)}',
              style: AppTypography.geist(
                fontSize: 12,
                color: AppColors.bodySecondary,
              ),
            ),
            if (trip.scheduledAt != null) ...[
              SizedBox(height: 4.h),
              Text(
                'Pickup ${trip.scheduledAt!.toLocal().toString().substring(0, 16)}',
                style: AppTypography.geist(fontSize: 12, color: AppColors.goldColor),
              ),
            ],
            if (canCancel) ...[
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => controller.cancelTrip(trip),
                  child: Text(
                    'Cancel ride',
                    style: AppTypography.geist(fontSize: 12, color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
