import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'firebase_auth_service.dart';
import 'role_service.dart';

class SessionService extends GetxService {
  /// Clears UI routes first so Firestore listeners dispose, then signs out.
  Future<void> logout() async {
    Get.offAllNamed<void>(AppRoutes.roleSelect);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      if (Get.isRegistered<FirebaseAuthService>()) {
        await Get.find<FirebaseAuthService>().signOut();
      }
    } on Object catch (error) {
      Get.log('Sign-out skipped: $error');
    }
    try {
      if (Get.isRegistered<RoleService>()) {
        await Get.find<RoleService>().clearRole();
      }
    } on Object catch (error) {
      Get.log('Clear role skipped: $error');
    }
  }
}
