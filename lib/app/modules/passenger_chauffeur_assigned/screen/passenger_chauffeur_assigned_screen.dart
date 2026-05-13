import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
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
                padding: const EdgeInsets.only(top: 10),
                child: _StatusPill(),
              ),
            ),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.24,
              minChildSize: 0.2,
              maxChildSize: 0.58,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: AppColors.outline,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
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
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  PassengerChauffeurAssignedController
                                      .chauffeurName,
                                  style: AppTypography.geist(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onBackgroundBright,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.vehicleModel,
                                  style: AppTypography.geist(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onBackgroundBright,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star_rounded,
                                        size: 18,
                                        color:
                                            i <
                                                PassengerChauffeurAssignedController
                                                    .ratingFilled
                                            ? AppColors.goldMid
                                            : AppColors.outline,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
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
                                icon: const Icon(
                                  CupertinoIcons.phone_fill,
                                  color: AppColors.goldMid,
                                  size: 22,
                                ),
                                onTap: controller.onCall,
                              ),
                              const SizedBox(width: 8),
                              _CircleIconButton(
                                icon: Image.asset(
                                  'assets/icons/chat_bubble_icon.png',
                                  width: 22,
                                  height: 22,
                                ),
                                onTap: controller.onMessage,
                              ),
                            ],
                          ),
                        ],
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
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldMid,
              ),
            ),
            const SizedBox(width: 10),
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
        fixedSize: const Size(46, 46),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Center(child: icon),
    );
  }
}
