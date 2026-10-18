import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/firebase_auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../routes/app_routes.dart';

class PassengerScheduleController extends GetxController {
  final Rx<DateTime> rxDate = DateTime.now().add(const Duration(hours: 2)).obs;
  final TextEditingController pickupController = TextEditingController(
    text: 'Current Location',
  );
  final TextEditingController destinationController = TextEditingController();

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: rxDate.value,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (date == null) {
      return;
    }
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(rxDate.value),
    );
    if (time == null) {
      return;
    }
    rxDate.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void continueBooking() {
    if (destinationController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Enter a destination.');
      return;
    }
    Get.toNamed(
      AppRoutes.passengerSelectVehicle,
      arguments: <String, dynamic>{
        'pickupLabel': pickupController.text.trim(),
        'destinationLabel': destinationController.text.trim(),
        'scheduledAt': rxDate.value.toIso8601String(),
        'isScheduled': true,
      },
    );
  }

  @override
  void onClose() {
    pickupController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}

class PassengerScheduleView extends GetView<PassengerScheduleController> {
  const PassengerScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Schedule a ride',
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          TextField(
            controller: controller.pickupController,
            style: const TextStyle(color: Colors.white),
            decoration: _decoration('Pickup'),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller.destinationController,
            style: const TextStyle(color: Colors.white),
            decoration: _decoration('Destination'),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => ListTile(
              tileColor: const Color(0xFF141414),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              title: Text(
                'Pickup time',
                style: AppTypography.geist(fontSize: 13, color: AppColors.bodySecondary),
              ),
              subtitle: Text(
                controller.rxDate.value.toLocal().toString().substring(0, 16),
                style: AppTypography.geist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.schedule, color: AppColors.goldColor),
              onTap: () => controller.pickDateTime(context),
            ),
          ),
          SizedBox(height: 20.h),
          AppPrimaryButton(
            label: 'Continue to vehicles',
            onPressed: controller.continueBooking,
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.bodySecondary),
      filled: true,
      fillColor: const Color(0xFF141414),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class PassengerSavedPlacesController extends GetxController {
  final RxList<String> rxPlaces = <String>[].obs;
  final TextEditingController placeController = TextEditingController();
  static const String _prefsKey = 'passenger_saved_places';

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid != null) {
      final snapshot = await Get.find<FirestoreService>().getPassengerDoc(uid);
      final List<dynamic>? remote = snapshot.data()?['savedPlaces'] as List<dynamic>?;
      if (remote != null && remote.isNotEmpty) {
        rxPlaces.assignAll(remote.map((dynamic item) => '$item').toList());
        return;
      }
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> places = prefs.getStringList(_prefsKey) ??
        <String>[
          'Home · Downtown Residence',
          'Work · Business Bay Office',
          'Hotel Emma',
          'San Antonio International Airport',
        ];
    rxPlaces.assignAll(places);
  }

  Future<void> _persist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, rxPlaces.toList());
    final String? uid = Get.find<FirebaseAuthService>().currentUser?.uid;
    if (uid == null) {
      return;
    }
    await Get.find<FirestoreService>().updatePassengerFields(
      uid,
      <String, dynamic>{'savedPlaces': rxPlaces.toList()},
    );
  }

  Future<void> addPlace() async {
    final String value = placeController.text.trim();
    if (value.isEmpty) {
      return;
    }
    rxPlaces.add(value);
    placeController.clear();
    await _persist();
  }

  Future<void> removePlace(int index) async {
    rxPlaces.removeAt(index);
    await _persist();
  }

  void selectPlace(String place) {
    Get.back(result: place);
  }

  @override
  void onClose() {
    placeController.dispose();
    super.onClose();
  }
}

class PassengerSavedPlacesView extends GetView<PassengerSavedPlacesController> {
  const PassengerSavedPlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: 'Saved places',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.placeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add a place',
                      hintStyle: TextStyle(color: AppColors.hint),
                      filled: true,
                      fillColor: const Color(0xFF141414),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: controller.addPlace,
                  icon: Icon(Icons.add_circle, color: AppColors.goldColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.rxPlaces.length,
                separatorBuilder: (_, _) => SizedBox(height: 8.h),
                itemBuilder: (BuildContext context, int index) {
                  final String place = controller.rxPlaces[index];
                  return ListTile(
                    tileColor: const Color(0xFF141414),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    leading: Icon(Icons.place, color: AppColors.goldColor),
                    title: Text(
                      place,
                      style: AppTypography.geist(fontSize: 14, color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () => controller.removePlace(index),
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    ),
                    onTap: () => controller.selectPlace(place),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
