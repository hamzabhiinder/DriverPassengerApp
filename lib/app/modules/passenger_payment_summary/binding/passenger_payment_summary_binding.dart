import 'package:get/get.dart';

import '../controller/passenger_payment_summary_controller.dart';

class PassengerPaymentSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerPaymentSummaryController>(
      PassengerPaymentSummaryController.new,
    );
  }
}
