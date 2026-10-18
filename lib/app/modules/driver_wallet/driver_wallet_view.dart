import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class DriverWalletController extends GetxController {
  final RxDouble rxBalance = 0.0.obs;
  final RxDouble rxPending = 0.0.obs;
  final RxString rxMethod = 'Bank transfer'.obs;
  final RxBool rxBusy = false.obs;

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchDriverDoc(uid).listen(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
        rxBalance.value = (data['walletBalanceUsd'] as num?)?.toDouble() ?? 0;
        rxPending.value = (data['pendingPayoutUsd'] as num?)?.toDouble() ?? 0;
        rxMethod.value = data['payoutMethod'] as String? ?? 'Bank transfer';
      },
    );
  }

  Future<void> requestPayout() async {
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null || rxPending.value <= 0) {
      Get.snackbar('Payout', 'No pending balance available.');
      return;
    }
    rxBusy.value = true;
    try {
      await Get.find<FirestoreService>().requestPayout(uid, rxPending.value);
      Get.snackbar(
        'Payout requested',
        'Funds will arrive in 1–2 business days.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB88E2F),
        colorText: Colors.black,
      );
    } finally {
      rxBusy.value = false;
    }
  }
}

class DriverWalletView extends GetView<DriverWalletController> {
  const DriverWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Wallet & Payouts',
      body: Obx(() {
        return ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB88E2F), Color(0xFF966C2D)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available balance',
                    style: AppTypography.geist(fontSize: 13, color: Colors.black87),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '\$${controller.rxBalance.value.toStringAsFixed(2)}',
                    style: AppTypography.castoro(fontSize: 34, color: Colors.black),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Pending payout: \$${controller.rxPending.value.toStringAsFixed(2)}',
                    style: AppTypography.geist(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _tile('Payout method', controller.rxMethod.value),
            _tile('Processing time', '1–2 business days'),
            _tile('Currency', 'USD'),
            SizedBox(height: 16.h),
            AppPrimaryButton(
              label: controller.rxBusy.value ? 'Processing...' : 'Request payout',
              onPressed: controller.rxBusy.value ? null : controller.requestPayout,
            ),
          ],
        );
      }),
    );
  }

  Widget _tile(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.geist(fontSize: 13, color: AppColors.bodySecondary),
            ),
          ),
          Text(
            value,
            style: AppTypography.geist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
