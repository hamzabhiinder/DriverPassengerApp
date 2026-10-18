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

class PassengerCardsController extends GetxController {
  final RxList<Map<String, dynamic>> rxCards = <Map<String, dynamic>>[].obs;
  final TextEditingController brandController = TextEditingController(text: 'Visa');
  final TextEditingController last4Controller = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _cardsSub;

  String? get _uid => Get.find<FirebaseAuthService>().currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    _cardsSub = Get.find<FirestoreService>().watchPassengerDoc(uid).listen(
      _applyCards,
      onError: (Object error) => Get.log('Cards watch skipped: $error'),
    );
  }

  void _applyCards(DocumentSnapshot<Map<String, dynamic>> doc) {
    final List<dynamic> raw =
        doc.data()?['cards'] as List<dynamic>? ?? <dynamic>[];
    rxCards.assignAll(
      raw.map((dynamic item) => Map<String, dynamic>.from(item as Map)).toList(),
    );
  }

  Future<void> _saveCards(List<Map<String, dynamic>> cards) async {
    final String? uid = _uid;
    if (uid == null) {
      return;
    }
    await Get.find<FirestoreService>().updatePassengerFields(
      uid,
      <String, dynamic>{'cards': cards},
    );
  }

  Future<void> addCard() async {
    final String last4 = last4Controller.text.trim();
    final String expiry = expiryController.text.trim();
    if (last4.length != 4 || int.tryParse(last4) == null) {
      Get.snackbar('Card', 'Enter the last 4 digits.');
      return;
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) {
      Get.snackbar('Card', 'Use expiry format MM/YY.');
      return;
    }
    final List<Map<String, dynamic>> next = rxCards
        .map((Map<String, dynamic> card) => <String, dynamic>{...card, 'isDefault': false})
        .toList();
    next.add(<String, dynamic>{
      'brand': brandController.text.trim().isEmpty ? 'Card' : brandController.text.trim(),
      'last4': last4,
      'mask': '**** **** **** $last4',
      'expiry': expiry,
      'isDefault': true,
    });
    await _saveCards(next);
    last4Controller.clear();
    expiryController.clear();
    Get.back();
  }

  Future<void> makeDefault(int index) async {
    final List<Map<String, dynamic>> next = <Map<String, dynamic>>[];
    for (int i = 0; i < rxCards.length; i++) {
      next.add(<String, dynamic>{...rxCards[i], 'isDefault': i == index});
    }
    await _saveCards(next);
  }

  Future<void> removeCard(int index) async {
    final List<Map<String, dynamic>> next = List<Map<String, dynamic>>.from(rxCards);
    final bool wasDefault = next[index]['isDefault'] == true;
    next.removeAt(index);
    if (wasDefault && next.isNotEmpty) {
      next[0] = <String, dynamic>{...next[0], 'isDefault': true};
    }
    await _saveCards(next);
  }

  void openAddSheet() {
    Get.bottomSheet<void>(
      Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: brandController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              TextField(
                controller: last4Controller,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Last 4 digits'),
              ),
              TextField(
                controller: expiryController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Expiry MM/YY'),
              ),
              const SizedBox(height: 16),
              AppPrimaryButton(label: 'Save card', onPressed: addCard),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  void onClose() {
    _cardsSub?.cancel();
    brandController.dispose();
    last4Controller.dispose();
    expiryController.dispose();
    super.onClose();
  }
}

class PassengerCardsView extends GetView<PassengerCardsController> {
  const PassengerCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'My cards',
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.rxCards.isEmpty) {
                return Center(
                  child: Text(
                    'No cards saved.',
                    style: AppTypography.geist(
                      fontSize: 13,
                      color: AppColors.bodySecondary,
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.rxCards.length,
                separatorBuilder: (_, _) => SizedBox(height: 8.h),
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> card = controller.rxCards[index];
                  final bool isDefault = card['isDefault'] == true;
                  return ListTile(
                    tileColor: const Color(0xFF141414),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    leading: Icon(Icons.credit_card, color: AppColors.goldColor),
                    title: Text(
                      '${card['brand']} ${card['mask']}',
                      style: AppTypography.geist(fontSize: 14, color: Colors.white),
                    ),
                    subtitle: Text(
                      isDefault ? 'Default · ${card['expiry']}' : '${card['expiry']}',
                      style: AppTypography.geist(
                        fontSize: 12,
                        color: AppColors.bodySecondary,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isDefault)
                          IconButton(
                            onPressed: () => controller.makeDefault(index),
                            icon: Icon(Icons.check_circle_outline, color: AppColors.goldColor),
                          ),
                        IconButton(
                          onPressed: () => controller.removeCard(index),
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: AppPrimaryButton(
              label: 'Add card',
              onPressed: controller.openAddSheet,
            ),
          ),
        ],
      ),
    );
  }
}
