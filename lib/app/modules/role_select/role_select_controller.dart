import 'package:get/get.dart';

import '../../data/models/user_role.dart';
import '../../data/services/role_service.dart';
import '../../routes/app_routes.dart';

class RoleSelectController extends GetxController {
  final RoleService _roleService = Get.find<RoleService>();

  Future<void> pickDriver() async {
    Get.offAllNamed<void>(AppRoutes.driverLogin);
  }

  Future<void> pickPassenger() async {
    Get.offAllNamed<void>(AppRoutes.passengerLogin);
  }
}
