import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_chauffeur_assigned_controller.dart';
import '../widgets/chauffeur_assigned_map_layer.dart';

class PassengerChauffeurAssignedScreen
    extends GetView<PassengerChauffeurAssignedController> {
  const PassengerChauffeurAssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ChauffeurAssignedMapLayer(),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: _StatusPill(),
              ),
            ),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.2,
              maxChildSize: 0.58,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 24.h),
                    children: [
                      Center(
                        child: Container(
                          width: 44.w,
                          height: 4.h,
                          margin: EdgeInsets.only(bottom: 18.h),
                          decoration: BoxDecoration(
                            color: AppColors.outline,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryContainer,
                              border: Border.all(
                                color: AppColors.goldMid.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            child: Icon(
                              CupertinoIcons.person,
                              color: AppColors.goldMid,
                              size: 30.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.chauffeurName,
                                  style: AppTypography.geist(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onBackgroundBright,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  controller.vehicleModel,
                                  style: AppTypography.geist(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onBackgroundBright,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star_rounded,
                                        size: 18.sp,
                                        color: i <
                                                PassengerChauffeurAssignedController
                                                    .ratingFilled
                                            ? AppColors.goldMid
                                            : AppColors.outline,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      PassengerChauffeurAssignedController
                                          .plate,
                                      style: AppTypography.geist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurfaceMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              _CircleIconButton(
                                icon: Icon(
                                  CupertinoIcons.phone_fill,
                                  color: AppColors.goldMid,
                                  size: 22.sp,
                                ),
                                onTap: controller.onCall,
                              ),
                              SizedBox(width: 8.w),
                              _CircleIconButton(
                                icon: Image.asset(
                                  'assets/icons/chat_bubble_icon.png',
                                  width: 22.w,
                                  height: 22.w,
                                ),
                                onTap: controller.onMessage,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 22.h),
                      GoldGradientCtaButton(
                        label: 'Ride complete',
                        onPressed: controller.onRideComplete,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.outline),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldMid,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Chauffeur Assigned',
              style: AppTypography.geist(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onBackgroundBright,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        shape: const CircleBorder(),
        fixedSize: Size(46.w, 46.w),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Center(child: icon),
    );
  }
}
