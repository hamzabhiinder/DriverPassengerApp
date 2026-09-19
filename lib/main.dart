import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'app/core/theme/app_colors.dart';
import 'app/data/services/role_service.dart';

import 'app/data/services/firebase_auth_service.dart';
import 'app/data/services/firestore_service.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
  
  await Get.putAsync<RoleService>(() => RoleService().init(), permanent: true);
  
  // Initialize Firebase services
  Get.put(FirebaseAuthService(), permanent: true);
  Get.put(FirestoreService(), permanent: true);
  
  runApp(const DriverPassengerApp());
}
