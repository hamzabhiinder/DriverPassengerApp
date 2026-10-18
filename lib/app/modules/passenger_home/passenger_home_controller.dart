import 'package:get/get.dart';

import '../../data/services/session_service.dart';
import '../../routes/app_routes.dart';

class PassengerHomeController extends GetxController {

  void openWhereTo() {
    Get.offNamed<void>(AppRoutes.passengerWhereTo);
  }

  void openSchedule() {
    Get.toNamed<void>(AppRoutes.passengerSchedule);
  }

  void openScheduledRides() {
    Get.toNamed<void>(AppRoutes.passengerScheduledRides);
  }

  void openHistory() {
    Get.toNamed<void>(AppRoutes.passengerRideHistory);
  }

  void openNotifications() {
    Get.toNamed<void>(AppRoutes.passengerNotifications);
  }

  void openAccount() {
    Get.toNamed<void>(AppRoutes.passengerAccount);
  }

  void openCards() {
    Get.toNamed<void>(AppRoutes.passengerCards);
  }

  void openSavedPlaces() {
    Get.toNamed<void>(AppRoutes.passengerSavedPlaces);
  }

  void openTerms() {
    Get.toNamed<void>(AppRoutes.passengerTerms);
  }

  void openWallet() {
    Get.toNamed<void>(AppRoutes.passengerWallet);
  }

  void openSupport() {
    Get.toNamed<void>(AppRoutes.passengerSupport);
  }

  Future<void> switchRole() async {
    await Get.find<SessionService>().logout();
  }
}
