import 'package:get/get.dart';

import '../../data/models/user_role.dart';
import '../../data/services/role_service.dart';
import '../../routes/app_routes.dart';

class RoleSelectController extends GetxController {
  final RoleService _roleService = Get.find<RoleService>();

  final rxSelectedRole = Rxn<String>();

  Future<void> pickDriver() async {
    rxSelectedRole.value = 'driver';
    await _roleService.setRole(UserRole.driver);
    Get.offAllNamed<void>(AppRoutes.driverLogin);
  }

  Future<void> pickPassenger() async {
    rxSelectedRole.value = 'passenger';
    await _roleService.setRole(UserRole.passenger);
    Get.offAllNamed<void>(AppRoutes.passengerLogin);
  }
}
