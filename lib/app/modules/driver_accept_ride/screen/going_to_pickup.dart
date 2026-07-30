import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../controller/going_to_pickup_controller.dart';

class GoingToPickupView extends StatelessWidget {
  const GoingToPickupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GoingToPickupController());
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: controller.pickupLocation,
                initialZoom: 15.0,
                minZoom: 3.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.blackx.driver',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.pickupLocation,
                      width: 60.w,
                      height: 60.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC59341).withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD479),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: 48.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF121212).withOpacity(0.95),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.04),
                  width: 1.w,
                ),
              ),
              child: Obx(() {
                final state = controller.rxTripState.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDynamicStepper(state),
                    SizedBox(height: 12.h),
                    Text(
                      _getStepperStatusText(state),
                      style: AppTypography.geist(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0C0C0C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 16.r,
                    spreadRadius: 4.r,
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                24.w,
                12.h,
                24.w,
                24.h + bottomInset,
              ),
              child: Obx(() {
                final state = controller.rxTripState.value;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 48.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: const Color(0xFFC59341),
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sarah Johnson',
                                style: AppTypography.geist(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.goldColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999.r),
                                  border: Border.all(
                                    color: AppColors.goldColor.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  'BLACKX VIP MEMBER',
                                  style: AppTypography.geist(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.goldColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildIconButton(
                          Icons.phone_outlined,
                          onTap: controller.callCustomer,
                        ),
                        SizedBox(width: 12.w),
                        _buildIconButton(
                          Icons.sms_outlined,
                          onTap: controller.messageCustomer,
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
                    Divider(color: Colors.white.withOpacity(0.06), height: 1),
                    SizedBox(height: 12.h),

                    _buildSpecDetailRow(
                      _getDynamicLabel(state),
                      '12280 Westheimer Rd #5',
                    ),
                    _buildSpecDetailRow('Distance', '1.8 km — 5 min away'),
                    _buildSpecDetailRow('Earnings', '\$120.00', isGoldValue: true),
                    if (state == TripState.goingToPickup ||
                        state == TripState.waitingForPassenger) ...[
                      SizedBox(height: 8.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Trip Notes',
                          style: AppTypography.geist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '• Hotel pickup at Grand Hyatt\n• Client has 2 checked bags\n• Meet at valet entrance',
                        style: AppTypography.geist(
                          fontSize: 11,
                          color: AppColors.bodySecondary,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Text(
                            'Gate Code: ',
                            style: AppTypography.geist(
                              fontSize: 12,
                              color: AppColors.bodySecondary,
                            ),
                          ),
                          Text(
                            '4321',
                            style: AppTypography.geist(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.goldColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (state == TripState.passengerOnboard) ...[
                      SizedBox(height: 8.h),
                      Text(
                        'Drop-Off Notes\n• Please drop off at the front entrance\n• Client prefers quiet environment',
                        style: AppTypography.geist(
                          fontSize: 11,
                          color: AppColors.bodySecondary,
                          height: 1.35,
                        ),
                      ),
                    ],

                    SizedBox(height: 20.h),

                    _buildDynamicActionButton(
                      text: _getDynamicButtonText(state),
                      onTap: controller.handlePrimaryAction,
                    ),

                    if (state == TripState.goingToPickup) ...[
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSecondaryButton(
                              'Open Navigation',
                              onTap: controller.openGPS,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildSecondaryButton(
                              'Call Customer',
                              onTap: controller.callCustomer,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (state == TripState.waitingForPassenger) ...[
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSecondaryButton(
                              'Notify Passenger',
                              onTap: controller.messageCustomer,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildSecondaryButton(
                              'Report No-Show',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicStepper(TripState state) {
    int activeCount = 1;
    if (state == TripState.waitingForPassenger) activeCount = 2;
    if (state == TripState.passengerOnboard) activeCount = 3;
    if (state == TripState.arrivedAtDestination) activeCount = 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle('1', isActive: activeCount >= 1),
        _buildStepDivider(isActive: activeCount >= 2),
        _buildStepCircle('2', isActive: activeCount >= 2),
        _buildStepDivider(isActive: activeCount >= 3),
        _buildStepCircle('3', isActive: activeCount >= 3),
        _buildStepDivider(isActive: activeCount >= 4),
        _buildStepCircle('4', isActive: activeCount >= 4),
      ],
    );
  }

  Widget _buildStepCircle(String step, {required bool isActive}) {
    return Container(
      width: 28.w,
      height: 28.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFB88E2F) : const Color(0xFF232323),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        step,
        style: AppTypography.geist(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.black : const Color(0xFFA0A0A0),
        ),
      ),
    );
  }

  Widget _buildStepDivider({required bool isActive}) {
    return Container(
      width: 36.w,
      height: 1.2.h,
      color: isActive ? const Color(0xFFB88E2F) : const Color(0xFF232323),
    );
  }

  Widget _buildIconButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: const BoxDecoration(
          color: Color(0xFF141414),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFFFFD479), size: 20.sp),
      ),
    );
  }

  Widget _buildSpecDetailRow(
    String label,
    String value, {
    bool isGoldValue = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.geist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.bodySecondary.withOpacity(0.5),
            ),
          ),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isGoldValue ? const Color(0xFFC59341) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicActionButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return AppPrimaryButton(
      label: text,
      onPressed: onTap,
      height: AppSizes.buttonHeightLarge,
    );
  }

  Widget _buildSecondaryButton(String text, {required VoidCallback onTap}) {
    return AppSecondaryButton(
      label: text,
      onPressed: onTap,
      isPill: true,
    );
  }

  String _getStepperStatusText(TripState state) {
    switch (state) {
      case TripState.goingToPickup:
        return 'En Route to Pickup';
      case TripState.waitingForPassenger:
        return 'Waiting for Passenger';
      case TripState.passengerOnboard:
        return 'Trip in Progress';
      case TripState.arrivedAtDestination:
        return 'Trip Complete';
    }
  }

  String _getDynamicLabel(TripState state) {
    switch (state) {
      case TripState.goingToPickup:
      case TripState.waitingForPassenger:
        return 'Pickup Location';
      case TripState.passengerOnboard:
        return 'Destination';
      case TripState.arrivedAtDestination:
        return 'Location';
    }
  }

  String _getDynamicButtonText(TripState state) {
    switch (state) {
      case TripState.goingToPickup:
        return "I've Arrived";
      case TripState.waitingForPassenger:
        return 'Passenger Onboard';
      case TripState.passengerOnboard:
        return 'Complete Trip';
      case TripState.arrivedAtDestination:
        return 'Return to Dashboard';
    }
  }
}
