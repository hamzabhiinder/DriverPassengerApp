import 'package:get/get.dart';

import '../../data/models/user_role.dart';
import '../../data/services/role_service.dart';
import '../../routes/app_routes.dart';

class RoleSelectController extends GetxController {
  final RoleService _roleService = Get.find<RoleService>();

  Future<void> pickDriver() async {
    await _roleService.setRole(UserRole.driver);
    Get.offAllNamed<void>(AppRoutes.driverHome);
  }

  Future<void> pickPassenger() async {
    await _roleService.setRole(UserRole.passenger);
    Get.offAllNamed<void>(AppRoutes.passengerLogin);
  }
}
