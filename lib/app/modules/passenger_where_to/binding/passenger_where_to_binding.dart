import 'package:get/get.dart';

import '../controller/passenger_where_to_controller.dart';

class PassengerWhereToBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerWhereToController>(PassengerWhereToController.new);
  }
}
