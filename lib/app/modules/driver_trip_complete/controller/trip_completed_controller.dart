import 'package:get/get.dart';

class TripCompletedController extends GetxController {
  final rxTodayTrips = '13'.obs;
  final rxTodayEarned = '\$545'.obs;
  final rxTodayOnlineHours = '9.2h'.obs;

  void continueDriving() {
    Get.back(); 
  }
}
