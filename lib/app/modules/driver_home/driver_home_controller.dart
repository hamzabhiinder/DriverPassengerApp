import 'package:get/get.dart';

import '../../data/services/role_service.dart';
import '../../routes/app_routes.dart';

class DriverHomeController extends GetxController {
  final RoleService _roleService = Get.find<RoleService>();

  Future<void> switchRole() async {
    await _roleService.clearRole();
    Get.offAllNamed<void>(AppRoutes.roleSelect);
  }
}
