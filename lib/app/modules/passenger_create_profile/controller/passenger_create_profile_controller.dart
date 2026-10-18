import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/firebase_auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/push_notification_service.dart';
import '../../../routes/app_routes.dart';

class PassengerCreateProfileController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final RxBool rxIsLoading = false.obs;

  Future<void> continueToApp() {
    return _saveProfile();
  }

  Future<void> continueWithGoogle() async {
    if (rxIsLoading.value) {
      return;
    }
    rxIsLoading.value = true;
    try {
      final UserCredential? credential =
          await Get.find<FirebaseAuthService>().signInWithGoogle();
      if (credential?.user != null) {
        final User user = credential!.user!;
        final List<String> parts = (user.displayName ?? 'Google Rider')
            .trim()
            .split(RegExp(r'\s+'));
        firstNameController.text = parts.isNotEmpty ? parts.first : 'Google';
        lastNameController.text =
            parts.length > 1 ? parts.sublist(1).join(' ') : 'Rider';
        await _saveProfile(providerName: user.displayName ?? 'Google Rider');
        return;
      }
      await _saveProfile(providerName: 'Google Rider');
    } finally {
      rxIsLoading.value = false;
    }
  }

  Future<void> continueWithApple() async {
    await _saveProfile(providerName: 'Apple Rider');
  }

  Future<void> _saveProfile({String? providerName}) async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String typedName = '$firstName $lastName'.trim();
    final String displayName =
        typedName.isEmpty ? (providerName ?? '') : typedName;
    if (displayName.isEmpty) {
      Get.snackbar(
        'Profile',
        'Enter your name to continue.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    final FirebaseAuthService auth = Get.find<FirebaseAuthService>();
    if (auth.currentUser == null) {
      final UserCredential? credential = await auth.signInAnonymously();
      if (credential == null) {
        return;
      }
    }
    final String passengerId = auth.currentUser!.uid;
    final Object? raw = Get.arguments;
    final String phone = raw is Map ? raw['phone'] as String? ?? '' : '';
    final FirestoreService firestore = Get.find<FirestoreService>();
    await firestore.ensurePassengerProfile(
      passengerId: passengerId,
      displayName: displayName,
      phone: phone,
    );
    await firestore.updatePassengerFields(
      passengerId,
      <String, dynamic>{
        'displayName': displayName,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      },
    );
    if (Get.isRegistered<PushNotificationService>()) {
      await Get.find<PushNotificationService>().refreshForCurrentUser();
    }
    Get.offAllNamed<void>(AppRoutes.passengerWhereTo);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }
}
