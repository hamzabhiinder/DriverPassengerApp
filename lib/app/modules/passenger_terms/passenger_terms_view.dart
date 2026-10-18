import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class PassengerTermsController extends GetxController {
  final RxBool rxAccepted = false.obs;

  @override
  void onInit() {
    super.onInit();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    Get.find<FirestoreService>().watchPassengerDoc(uid).listen((doc) {
      rxAccepted.value = doc.data()?['termsAcceptedAt'] != null;
    });
  }

  Future<void> accept() async {
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    await Get.find<FirestoreService>().acceptTerms(uid);
    Get.snackbar(
      'Accepted',
      'Terms version 4.51 saved to your account.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB88E2F),
      colorText: Colors.black,
    );
  }
}

class PassengerTermsView extends GetView<PassengerTermsController> {
  const PassengerTermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Terms & conditions',
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: const [
                _TermsBlock(
                  title: 'Bookings',
                  body:
                      'A ride is confirmed after you choose a vehicle and complete payment. Scheduled rides stay on your account until the pickup time, and you can cancel them from Scheduled Rides or Ride History.',
                ),
                _TermsBlock(
                  title: 'Payments',
                  body:
                      'Card and wallet payments are charged in the amount shown before you confirm. Wallet balance is held on your rider account. Default cards can be changed from My Cards.',
                ),
                _TermsBlock(
                  title: 'Chauffeur service',
                  body:
                      'BlackX matches you with a licensed chauffeur when one is available. Live trip status, calling, and in-ride chat are available after a chauffeur is assigned.',
                ),
                _TermsBlock(
                  title: 'Cancellations',
                  body:
                      'You may cancel a requested or scheduled ride before it is completed. Completed rides can be rated from Ride History.',
                ),
                _TermsBlock(
                  title: 'Your account',
                  body:
                      'Keep your name and phone number current in Account Settings. Notifications for ride updates and promotions can be turned off at any time.',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Obx(
              () => AppPrimaryButton(
                label: controller.rxAccepted.value
                    ? 'Terms accepted'
                    : 'I accept these terms',
                onPressed: controller.rxAccepted.value ? null : controller.accept,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsBlock extends StatelessWidget {
  const _TermsBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.geist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.goldColor,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            body,
            style: AppTypography.geist(
              fontSize: 14,
              color: AppColors.bodySecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
