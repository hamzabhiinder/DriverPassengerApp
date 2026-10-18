import 'dart:async';

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

class PassengerWalletController extends GetxController {
  final RxDouble rxBalance = 0.0.obs;
  final RxList<Map<String, dynamic>> rxPayments = <Map<String, dynamic>>[].obs;
  final RxBool rxIsToppingUp = false.obs;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _balanceSub;
  StreamSubscription<List<Map<String, dynamic>>>? _paymentsSub;

  String? get _uid => Get.find<FirebaseAuthService>().currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    _balanceSub = Get.find<FirestoreService>().watchPassengerDoc(uid).listen(
      (DocumentSnapshot<Map<String, dynamic>> doc) {
        rxBalance.value =
            (doc.data()?['walletBalanceUsd'] as num?)?.toDouble() ?? 0;
      },
      onError: (Object error) => Get.log('Wallet balance watch skipped: $error'),
    );
    _paymentsSub = Get.find<FirestoreService>().watchPayments(uid).listen(
      rxPayments.assignAll,
      onError: (Object error) => Get.log('Wallet payments watch skipped: $error'),
    );
  }

  @override
  void onClose() {
    _balanceSub?.cancel();
    _paymentsSub?.cancel();
    super.onClose();
  }

  Future<void> topUp(double amount) async {
    final String? uid = _uid;
    if (uid == null || rxIsToppingUp.value) {
      return;
    }
    rxIsToppingUp.value = true;
    try {
      await Get.find<FirestoreService>().topUpWallet(uid, amount);
      Get.snackbar(
        'Wallet',
        '\$${amount.toStringAsFixed(0)} added successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB88E2F),
        colorText: Colors.black,
      );
    } finally {
      rxIsToppingUp.value = false;
    }
  }
}

class PassengerWalletView extends GetView<PassengerWalletController> {
  const PassengerWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Wallet',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB88E2F), Color(0xFF8C6239)],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available balance',
                      style: AppTypography.geist(fontSize: 13, color: Colors.black87),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '\$${controller.rxBalance.value.toStringAsFixed(2)}',
                      style: AppTypography.castoro(
                        fontSize: 34,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Add \$50',
                    onPressed: () => controller.topUp(50),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppPrimaryButton(
                    label: 'Add \$100',
                    onPressed: () => controller.topUp(100),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transactions',
                style: AppTypography.geist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.rxPayments.isEmpty) {
                return Center(
                  child: Text(
                    'No payments yet.',
                    style: AppTypography.geist(
                      fontSize: 13,
                      color: AppColors.bodySecondary,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.rxPayments.length,
                separatorBuilder: (_, _) => SizedBox(height: 8.h),
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> item = controller.rxPayments[index];
                  final double amount =
                      (item['amountUsd'] as num?)?.toDouble() ?? 0;
                  final bool isTopUp = item['method'] == 'wallet_topup';
                  return ListTile(
                    tileColor: const Color(0xFF141414),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    title: Text(
                      isTopUp ? 'Wallet top-up' : '${item['method']}'.toUpperCase(),
                      style: AppTypography.geist(fontSize: 14, color: Colors.white),
                    ),
                    subtitle: Text(
                      '${item['status']}',
                      style: AppTypography.geist(
                        fontSize: 12,
                        color: AppColors.bodySecondary,
                      ),
                    ),
                    trailing: Text(
                      '${isTopUp ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                      style: AppTypography.geist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isTopUp ? Colors.greenAccent : AppColors.goldColor,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
