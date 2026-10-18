import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'firebase_auth_service.dart';
import 'firestore_service.dart';

class PushNotificationService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final RxString rxLastMessage = ''.obs;

  Future<PushNotificationService> init() async {
    try {
      final NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return this;
      }
      FirebaseMessaging.onMessage.listen(_onForeground);
      FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);
      await _saveToken();
      _messaging.onTokenRefresh.listen((String token) async {
        await _persistToken(token);
      });
    } on Object catch (error) {
      debugPrint('Push init skipped: $error');
    }
    return this;
  }

  Future<void> _saveToken() async {
    try {
      final String? token = await _messaging.getToken();
      if (token != null) {
        await _persistToken(token);
      }
    } on Object catch (error) {
      debugPrint('FCM token skipped: $error');
    }
  }

  Future<void> _persistToken(String token) async {
    if (!Get.isRegistered<FirebaseAuthService>() ||
        !Get.isRegistered<FirestoreService>()) {
      return;
    }
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    await Get.find<FirestoreService>().saveFcmToken(uid, token);
  }

  void _onForeground(RemoteMessage message) {
    final String title = message.notification?.title ?? 'BlackX';
    final String body = message.notification?.body ?? '';
    rxLastMessage.value = '$title · $body';
    Get.snackbar(title, body.isEmpty ? 'New update' : body);
  }

  void _onOpened(RemoteMessage message) {
    final String? rideId = message.data['rideId'];
    if (rideId == null || rideId.isEmpty) {
      return;
    }
    Get.toNamed('/passenger/chauffeur-assigned', arguments: <String, dynamic>{
      'rideId': rideId,
    });
  }

  Future<void> refreshForCurrentUser() => _saveToken();
}
