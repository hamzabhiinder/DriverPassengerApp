import 'package:get/get.dart';

import '../controller/passenger_chauffeur_assigned_controller.dart';

class PassengerChauffeurAssignedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerChauffeurAssignedController>(
      PassengerChauffeurAssignedController.new,
    );
  }
}
