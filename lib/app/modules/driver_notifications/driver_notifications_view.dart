import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class DriverNotificationsController extends GetxController {
  final RxList<Map<String, dynamic>> rxItems = <Map<String, dynamic>>[].obs;

  String? get _uid => Get.find<FirebaseAuthService>().currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchNotifications(uid).listen(rxItems.assignAll);
  }

  Future<void> openItem(Map<String, dynamic> item) async {
    final String id = '${item['id']}';
    await Get.find<FirestoreService>().markNotificationRead(id);
  }

  Future<void> markAllRead() async {
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    await Get.find<FirestoreService>().markAllNotificationsRead(uid);
  }
}

class DriverNotificationsView extends GetView<DriverNotificationsController> {
  const DriverNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Notifications',
      actions: [
        TextButton(
          onPressed: controller.markAllRead,
          child: Text(
            'Mark all read',
            style: AppTypography.geist(fontSize: 12, color: AppColors.goldColor),
          ),
        ),
      ],
      body: Obx(() {
        if (controller.rxItems.isEmpty) {
          return Center(
            child: Text(
              'No notifications yet.',
              style: AppTypography.geist(
                fontSize: 13,
                color: AppColors.bodySecondary,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.rxItems.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> item = controller.rxItems[index];
            final bool isRead = item['isRead'] == true;
            final Timestamp? createdAt = item['createdAt'] as Timestamp?;
            return InkWell(
              onTap: () => controller.openItem(item),
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isRead ? const Color(0xFF121212) : const Color(0xFF1A1710),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isRead
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.goldColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item['title']}',
                            style: AppTypography.geist(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: AppColors.goldColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${item['body']}',
                      style: AppTypography.geist(
                        fontSize: 12,
                        color: AppColors.bodySecondary,
                      ),
                    ),
                    if (createdAt != null) ...[
                      SizedBox(height: 6.h),
                      Text(
                        createdAt.toDate().toLocal().toString().substring(0, 16),
                        style: AppTypography.geist(
                          fontSize: 11,
                          color: AppColors.hint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
