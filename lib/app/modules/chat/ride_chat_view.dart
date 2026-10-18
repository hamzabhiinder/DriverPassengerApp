import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';

class RideChatArgs {
  const RideChatArgs({
    required this.chatId,
    required this.title,
    this.peerName,
  });

  final String chatId;
  final String title;
  final String? peerName;
}

class RideChatController extends GetxController {
  late final RideChatArgs args;
  final TextEditingController messageController = TextEditingController();
  final RxList<Map<String, dynamic>> rxMessages = <Map<String, dynamic>>[].obs;
  final RxBool rxSending = false.obs;
  StreamSubscription<List<Map<String, dynamic>>>? _messagesSub;

  @override
  void onInit() {
    super.onInit();
    final Object? raw = Get.arguments;
    if (raw is RideChatArgs) {
      args = raw;
    } else if (raw is Map) {
      args = RideChatArgs(
        chatId: raw['chatId'] as String? ?? 'general',
        title: raw['title'] as String? ?? 'Chat',
        peerName: raw['peerName'] as String?,
      );
    } else {
      args = const RideChatArgs(chatId: 'general', title: 'Chat');
    }
    _messagesSub = Get.find<FirestoreService>()
        .watchChatMessages(args.chatId)
        .listen(
          rxMessages.assignAll,
          onError: (Object error) => Get.log('Chat listen skipped: $error'),
        );
  }

  Future<void> send() async {
    final String text = messageController.text.trim();
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (text.isEmpty || uid == null || rxSending.value) {
      return;
    }
    rxSending.value = true;
    try {
      final String name =
          Get.find<FirebaseAuthService>().currentUser?.email?.split('@').first ??
              'User';
      await Get.find<FirestoreService>().sendChatMessage(
        chatId: args.chatId,
        senderId: uid,
        senderName: name,
        text: text,
      );
      messageController.clear();
    } on Object catch (error) {
      Get.snackbar('Chat', '$error');
    } finally {
      rxSending.value = false;
    }
  }

  @override
  void onClose() {
    _messagesSub?.cancel();
    messageController.dispose();
    super.onClose();
  }
}

class RideChatView extends GetView<RideChatController> {
  const RideChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final String? myUid = Get.find<FirebaseAuthService>().currentUser?.uid;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back, color: AppColors.goldColor, size: 22.sp),
        ),
        title: Text(
          controller.args.title,
          style: AppTypography.geist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.rxMessages.isEmpty) {
                return Center(
                  child: Text(
                    'Say hello to start the conversation.',
                    style: AppTypography.geist(
                      fontSize: 13,
                      color: AppColors.bodySecondary,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.rxMessages.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> item = controller.rxMessages[index];
                  final bool isMine = item['senderId'] == myUid;
                  return Align(
                    alignment:
                        isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      constraints: BoxConstraints(maxWidth: 0.72.sw),
                      decoration: BoxDecoration(
                        color: isMine
                            ? AppColors.goldColor
                            : const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${item['text'] ?? ''}',
                        style: AppTypography.geist(
                          fontSize: 14,
                          color: isMine ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: AppColors.hint),
                        filled: true,
                        fillColor: const Color(0xFF141414),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: controller.send,
                    icon: Icon(Icons.send, color: AppColors.goldColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
