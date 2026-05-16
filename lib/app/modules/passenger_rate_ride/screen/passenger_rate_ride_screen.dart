import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight),
                  _AvatarHeader(),
                  const SizedBox(height: 22),
                  Text(
                    'Rate Your Experience',
                    textAlign: TextAlign.center,
                    style: AppTypography.castoro(
                      fontSize: 28,
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
                  const SizedBox(height: 28),
                  Obx(() {
                    final r = controller.rating.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final filled = i < r;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => controller.setRating(i + 1),
                            child: Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 44,
                              color: filled
                                  ? AppColors.goldRing
                                  : AppColors.outline,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Additional Feedback (optional)',
                        style: AppTypography.geist(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onBackgroundBright,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: TextField(
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
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.outline.withValues(alpha: 0.9),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.outline.withValues(alpha: 0.9),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.goldRing,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(() {
                    final selected = Set<String>.from(controller.selectedTags);
                    return Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: [
                        for (final tag in PassengerRateRideController.quickTags)
                          _FeedbackChip(
                            label: tag,
                            selected: selected.contains(tag),
                            onTap: () => controller.toggleTag(tag),
                          ),
                      ],
                    );
                  }),
                  SizedBox(height: 24 + bottom * 0.25),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 0, 22, 8 + bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GoldGradientCtaButton(
                    label: 'Submit Rating',
                    onPressed: controller.onSubmitRating,
                  ),
                  const SizedBox(height: 14),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryContainer,
        border: Border.all(
          color: AppColors.goldMid.withValues(alpha: 0.55),
          width: 1.5,
        ),
      ),
      child: Icon(CupertinoIcons.person, color: AppColors.goldMid, size: 50),
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
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? AppColors.goldRing : AppColors.onSurfaceMuted,
              width: selected ? 1.5 : 1,
            ),
            color: selected
                ? AppColors.goldRing.withValues(alpha: 0.12)
                : AppColors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
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
