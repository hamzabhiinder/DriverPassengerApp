import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'app/core/theme/app_colors.dart';
import 'app/data/services/directions_service.dart';
import 'app/data/services/driver_location_service.dart';
import 'app/data/services/firebase_auth_service.dart';
import 'app/data/services/firestore_service.dart';
import 'app/data/services/push_notification_service.dart';
import 'app/data/services/role_service.dart';
import 'app/data/services/session_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Get.putAsync<RoleService>(() => RoleService().init(), permanent: true);
  Get.put(FirebaseAuthService(), permanent: true);
  Get.put(FirestoreService(), permanent: true);
  Get.put(DriverLocationService(), permanent: true);
  Get.put(DirectionsService(), permanent: true);
  Get.put(SessionService(), permanent: true);
  await Get.putAsync<PushNotificationService>(
    () => PushNotificationService().init(),
    permanent: true,
  );

  runApp(const DriverPassengerApp());
}
