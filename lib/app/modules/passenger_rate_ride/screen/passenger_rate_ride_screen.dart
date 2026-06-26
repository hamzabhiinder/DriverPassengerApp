import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gold_gradient_cta_button.dart';
import '../controller/passenger_rate_ride_controller.dart';

class PassengerRateRideScreen extends GetView<PassengerRateRideController> {
  const PassengerRateRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    const _AvatarHeader(),
                    SizedBox(height: 22.h),
                    Text(
                      'Rate Your Experience',
                      textAlign: TextAlign.center,
                      style: AppTypography.castoro(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onBackgroundBright,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'How was your ride with ${controller.args.chauffeurName}?',
                      textAlign: TextAlign.center,
                      style: AppTypography.geist(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: AppColors.onBackgroundBright,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Obx(() {
                      final rating = controller.rating.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          final filled = i < rating;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => controller.setRating(i + 1),
                              child: Icon(
                                filled
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 40.sp,
                                color: filled
                                    ? AppColors.goldRing
                                    : AppColors.outline,
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                    SizedBox(height: 32.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Additional Feedback (optional)',
                        style: AppTypography.geist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onBackgroundBright,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: controller.feedbackController,
                      maxLines: 5,
                      style: AppTypography.geist(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onBackgroundBright,
                      ),
                      cursorColor: AppColors.goldMid,
                      decoration: InputDecoration(
                        hintText: 'Tell us about your experience....',
                        hintStyle: AppTypography.geist(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurfaceMuted,
                        ),
                        filled: true,
                        fillColor: AppColors.paymentSummaryCard,
                        contentPadding: EdgeInsets.all(16.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: AppColors.outline.withValues(alpha: 0.9),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: AppColors.outline.withValues(alpha: 0.9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: const BorderSide(
                            color: AppColors.goldRing,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Obx(() {
                      final selected =
                          Set<String>.from(controller.selectedTags);
                      return Wrap(
                        spacing: 8.w,
                        runSpacing: 10.h,
                        alignment: WrapAlignment.start,
                        children: [
                          for (final tag
                              in PassengerRateRideController.quickTags)
                            _FeedbackChip(
                              label: tag,
                              selected: selected.contains(tag),
                              onTap: () => controller.toggleTag(tag),
                            ),
                        ],
                      );
                    }),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 8.h + bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GoldGradientCtaButton(
                    label: 'Submit Rating',
                    onPressed: controller.onSubmitRating,
                  ),
                  SizedBox(height: 14.h),
                  TextButton(
                    onPressed: controller.onSkip,
                    child: Text(
                      'Skip For Now',
                      style: AppTypography.geist(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarHeader extends GetView<PassengerRateRideController> {
  const _AvatarHeader();

  @override
  Widget build(BuildContext context) {
    final size = 88.w;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryContainer,
        border: Border.all(
          color: AppColors.goldMid.withValues(alpha: 0.55),
          width: 1.5,
        ),
      ),
      child: Icon(
        CupertinoIcons.person,
        color: AppColors.goldMid,
        size: size * 0.5,
      ),
    );
  }
}

class _FeedbackChip extends StatelessWidget {
  const _FeedbackChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999.r),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(
              color: selected ? AppColors.goldRing : AppColors.onSurfaceMuted,
              width: selected ? 1.5 : 1,
            ),
            color: selected
                ? AppColors.goldRing.withValues(alpha: 0.12)
                : AppColors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              label,
              style: AppTypography.geist(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.white : AppColors.onSurfaceMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
