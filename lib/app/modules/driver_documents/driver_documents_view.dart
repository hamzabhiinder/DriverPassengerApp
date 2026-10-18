import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class DriverDocumentsController extends GetxController {
  final RxList<Map<String, dynamic>> rxDocs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchDriverDoc(uid).listen(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        final List<dynamic> raw =
            doc.data()?['documents'] as List<dynamic>? ?? <dynamic>[];
        rxDocs.assignAll(
          raw.map((dynamic e) => Map<String, dynamic>.from(e as Map)).toList(),
        );
      },
    );
  }

  Future<void> markSubmitted(int index) async {
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null || index < 0 || index >= rxDocs.length) {
      return;
    }
    final List<Map<String, dynamic>> updated =
        List<Map<String, dynamic>>.from(rxDocs);
    updated[index] = <String, dynamic>{
      ...updated[index],
      'status': 'pending',
    };
    await Get.find<FirestoreService>().updateDriverFields(
      uid,
      <String, dynamic>{'documents': updated},
    );
    Get.snackbar(
      'Document submitted',
      '${updated[index]['name']} is under review.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }
}

class DriverDocumentsView extends GetView<DriverDocumentsController> {
  const DriverDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Documents',
      body: Obx(() {
        if (controller.rxDocs.isEmpty) {
          return Center(
            child: Text(
              'No documents on file yet.',
              style: AppTypography.geist(
                fontSize: 13,
                color: AppColors.bodySecondary,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.rxDocs.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> doc = controller.rxDocs[index];
            final String status = '${doc['status'] ?? 'pending'}';
            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, color: AppColors.goldColor),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${doc['name']}',
                          style: AppTypography.geist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Expires ${doc['expiresAt'] ?? '—'}',
                          style: AppTypography.geist(
                            fontSize: 12,
                            color: AppColors.bodySecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        status.toUpperCase(),
                        style: AppTypography.geist(
                          fontSize: 11,
                          color: status == 'verified'
                              ? const Color(0xFF4CAF50)
                              : AppColors.goldColor,
                        ),
                      ),
                      if (status != 'verified')
                        TextButton(
                          onPressed: () => controller.markSubmitted(index),
                          child: Text(
                            'Resubmit',
                            style: AppTypography.geist(
                              fontSize: 11,
                              color: AppColors.goldColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
