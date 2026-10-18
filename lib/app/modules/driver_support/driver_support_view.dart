import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class DriverSupportController extends GetxController {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final RxString rxCategory = 'General'.obs;
  final RxList<Map<String, dynamic>> rxTickets = <Map<String, dynamic>>[].obs;
  final RxBool rxIsSubmitting = false.obs;

  final List<String> categories = <String>[
    'General',
    'Payments',
    'Trip issue',
    'Account',
    'Documents',
  ];

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchSupportTickets(uid).listen(rxTickets.assignAll);
  }

  Future<void> submitTicket() async {
    final String subject = subjectController.text.trim();
    final String message = messageController.text.trim();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null || subject.isEmpty || message.isEmpty) {
      Get.snackbar('Required', 'Please enter subject and message.');
      return;
    }
    rxIsSubmitting.value = true;
    try {
      await Get.find<FirestoreService>().createSupportTicket(
        userId: uid,
        subject: subject,
        message: message,
        category: rxCategory.value,
      );
      subjectController.clear();
      messageController.clear();
      Get.snackbar(
        'Ticket submitted',
        'Our support team will reply shortly.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB88E2F),
        colorText: Colors.black,
      );
    } finally {
      rxIsSubmitting.value = false;
    }
  }

  Future<void> callSupport() async {
    final Uri uri = Uri(scheme: 'tel', path: '+97140000000');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> emailSupport() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: 'support@blackx.app',
      query: 'subject=Driver Support',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}

class DriverSupportView extends GetView<DriverSupportController> {
  const DriverSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Support',
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.callSupport,
                  icon: Icon(Icons.phone, color: AppColors.goldColor, size: 18.sp),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.goldColor,
                    side: BorderSide(color: AppColors.goldColor),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: controller.emailSupport,
                  icon: Icon(Icons.email_outlined, color: AppColors.goldColor, size: 18.sp),
                  label: const Text('Email'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.goldColor,
                    side: BorderSide(color: AppColors.goldColor),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'New ticket',
            style: AppTypography.geist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.rxCategory.value,
              dropdownColor: const Color(0xFF1A1A1A),
              decoration: _inputDecoration('Category'),
              items: controller.categories
                  .map(
                    (String c) => DropdownMenuItem<String>(
                      value: c,
                      child: Text(c, style: const TextStyle(color: Colors.white)),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  controller.rxCategory.value = value;
                }
              },
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller.subjectController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Subject'),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller.messageController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Describe your issue'),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => AppPrimaryButton(
              label: controller.rxIsSubmitting.value ? 'Submitting...' : 'Submit ticket',
              onPressed:
                  controller.rxIsSubmitting.value ? null : controller.submitTicket,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Your tickets',
            style: AppTypography.geist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(() {
            if (controller.rxTickets.isEmpty) {
              return Text(
                'No tickets yet.',
                style: AppTypography.geist(
                  fontSize: 13,
                  color: AppColors.bodySecondary,
                ),
              );
            }
            return Column(
              children: controller.rxTickets.map((Map<String, dynamic> ticket) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${ticket['subject']}',
                              style: AppTypography.geist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '${ticket['status']}'.toUpperCase(),
                            style: AppTypography.geist(
                              fontSize: 11,
                              color: AppColors.goldColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${ticket['category']} · ${ticket['message']}',
                        style: AppTypography.geist(
                          fontSize: 12,
                          color: AppColors.bodySecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.bodySecondary),
      filled: true,
      fillColor: const Color(0xFF141414),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    );
  }
}
