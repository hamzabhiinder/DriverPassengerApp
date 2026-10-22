import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/driver_section_scaffold.dart';
import '../../data/services/directions_service.dart';
import '../../data/services/driver_location_service.dart';
import '../../routes/app_routes.dart';

enum PassengerTripKind { airport, hourly, roundTrip }

class PassengerTripOptionsController extends GetxController {
  late final PassengerTripKind tripKind;
  late final String initialPickup;

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController outboundController = TextEditingController();
  final TextEditingController returnDestinationController =
      TextEditingController();
  final TextEditingController flightController = TextEditingController();

  final RxString rxAirportDirection = 'to_airport'.obs;
  final RxBool rxAirportRoundTrip = false.obs;
  final RxInt rxHours = 3.obs;
  final Rx<DateTime> rxPickupAt =
      DateTime.now().add(const Duration(hours: 2)).obs;
  final RxBool rxScheduleEnabled = false.obs;
  final RxBool rxIsSubmitting = false.obs;

  static const String _airportLabel = 'San Antonio International Airport';

  @override
  void onInit() {
    super.onInit();
    final Object? raw = Get.arguments;
    if (raw is Map) {
      tripKind = raw['tripKind'] as PassengerTripKind? ?? PassengerTripKind.airport;
      initialPickup = raw['pickupLabel'] as String? ?? 'Current Location';
    } else {
      tripKind = PassengerTripKind.airport;
      initialPickup = 'Current Location';
    }
    pickupController.text = initialPickup;
    if (tripKind == PassengerTripKind.airport) {
      addressController.text = initialPickup;
    }
    if (tripKind == PassengerTripKind.roundTrip) {
      rxScheduleEnabled.value = true;
    }
  }

  String get title {
    return switch (tripKind) {
      PassengerTripKind.airport => 'Airport transfer',
      PassengerTripKind.hourly => 'Hourly service',
      PassengerTripKind.roundTrip => 'Round trip',
    };
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: rxPickupAt.value,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (date == null || !context.mounted) {
      return;
    }
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(rxPickupAt.value),
    );
    if (time == null) {
      return;
    }
    rxPickupAt.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    rxScheduleEnabled.value = true;
  }

  void setHours(int hours) {
    if (hours < 1 || hours > 24) {
      return;
    }
    rxHours.value = hours;
  }

  void setAirportDirection(String direction) {
    rxAirportDirection.value = direction;
    if (direction == 'to_airport') {
      addressController.text = pickupController.text.trim().isEmpty
          ? initialPickup
          : pickupController.text.trim();
    } else {
      addressController.clear();
    }
  }

  Future<void> continueBooking() async {
    if (rxIsSubmitting.value) {
      return;
    }
    late final String pickup;
    late final String destination;
    late final String tripType;
    final Map<String, dynamic> extras = <String, dynamic>{};

    switch (tripKind) {
      case PassengerTripKind.airport:
        final String other = addressController.text.trim();
        if (other.isEmpty) {
          Get.snackbar(
            'Required',
            rxAirportDirection.value == 'to_airport'
                ? 'Enter your pickup address.'
                : 'Enter your drop-off address.',
          );
          return;
        }
        if (flightController.text.trim().isEmpty) {
          Get.snackbar('Required', 'Enter your flight number.');
          return;
        }
        final bool toAirport = rxAirportDirection.value == 'to_airport';
        pickup = toAirport ? other : _airportLabel;
        destination = toAirport ? _airportLabel : other;
        tripType = rxAirportRoundTrip.value
            ? 'Airport Transfer · Round Trip'
            : 'Airport Transfer · One Way';
        extras['flightNumber'] = flightController.text.trim().toUpperCase();
        extras['airportDirection'] = rxAirportDirection.value;
        extras['isRoundTrip'] = rxAirportRoundTrip.value;
        break;
      case PassengerTripKind.hourly:
        pickup = pickupController.text.trim().isEmpty
            ? 'Current Location'
            : pickupController.text.trim();
        destination =
            'Hourly chauffeur · ${rxHours.value} hour${rxHours.value == 1 ? '' : 's'}';
        tripType = 'Hourly Service';
        extras['hours'] = rxHours.value;
        break;
      case PassengerTripKind.roundTrip:
        pickup = pickupController.text.trim().isEmpty
            ? 'Current Location'
            : pickupController.text.trim();
        destination = outboundController.text.trim();
        final String returnDest = returnDestinationController.text.trim();
        if (destination.isEmpty || returnDest.isEmpty) {
          Get.snackbar(
            'Required',
            'Enter both outbound and return destinations.',
          );
          return;
        }
        if (!rxScheduleEnabled.value) {
          Get.snackbar(
            'Required',
            'Schedule your round-trip pickup time.',
          );
          return;
        }
        tripType = 'Round Trip';
        extras['returnDestination'] = returnDest;
        extras['isRoundTrip'] = true;
        break;
    }

    rxIsSubmitting.value = true;
    double? pickupLat;
    double? pickupLng;
    double? destinationLat;
    double? destinationLng;
    try {
      if (Get.isRegistered<DriverLocationService>()) {
        final point =
            await Get.find<DriverLocationService>().getCurrentLatLng();
        pickupLat = point?.latitude;
        pickupLng = point?.longitude;
      }
      if (Get.isRegistered<DirectionsService>() &&
          tripKind != PassengerTripKind.hourly) {
        final DirectionsService directions = Get.find<DirectionsService>();
        final origin = await directions.geocode(pickup);
        final dest = await directions.geocode(destination);
        pickupLat ??= origin?.latitude;
        pickupLng ??= origin?.longitude;
        destinationLat = dest?.latitude;
        destinationLng = dest?.longitude;
      }
    } finally {
      rxIsSubmitting.value = false;
    }

    Get.toNamed(
      AppRoutes.passengerSelectVehicle,
      arguments: <String, dynamic>{
        'pickupLabel': pickup,
        'destinationLabel': destination,
        'tripType': tripType,
        'pickupLat': pickupLat,
        'pickupLng': pickupLng,
        'destinationLat': destinationLat,
        'destinationLng': destinationLng,
        'isScheduled': rxScheduleEnabled.value,
        if (rxScheduleEnabled.value)
          'scheduledAt': rxPickupAt.value.toIso8601String(),
        ...extras,
      },
    );
  }

  @override
  void onClose() {
    pickupController.dispose();
    addressController.dispose();
    outboundController.dispose();
    returnDestinationController.dispose();
    flightController.dispose();
    super.onClose();
  }
}

class PassengerTripOptionsView extends GetView<PassengerTripOptionsController> {
  const PassengerTripOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DriverSectionScaffold(
      title: controller.title,
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          if (controller.tripKind == PassengerTripKind.airport) ..._airportFields(),
          if (controller.tripKind == PassengerTripKind.hourly) ..._hourlyFields(),
          if (controller.tripKind == PassengerTripKind.roundTrip)
            ..._roundTripFields(),
          SizedBox(height: 12.h),
          Obx(
            () => SwitchListTile(
              value: controller.rxScheduleEnabled.value,
              onChanged: (bool value) =>
                  controller.rxScheduleEnabled.value = value,
              activeThumbColor: AppColors.goldColor,
              title: Text(
                'Schedule for later',
                style: AppTypography.geist(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          Obx(() {
            if (!controller.rxScheduleEnabled.value) {
              return const SizedBox.shrink();
            }
            return ListTile(
              tileColor: const Color(0xFF141414),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              title: Text(
                'Pickup time',
                style: AppTypography.geist(
                  fontSize: 13,
                  color: AppColors.bodySecondary,
                ),
              ),
              subtitle: Text(
                controller.rxPickupAt.value
                    .toLocal()
                    .toString()
                    .substring(0, 16),
                style: AppTypography.geist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.schedule, color: AppColors.goldColor),
              onTap: () => controller.pickDateTime(context),
            );
          }),
          SizedBox(height: 20.h),
          Obx(
            () => AppPrimaryButton(
              label: 'Continue to vehicles',
              isLoading: controller.rxIsSubmitting.value,
              onPressed: controller.continueBooking,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _airportFields() {
    return <Widget>[
      Text(
        'Transfer type',
        style: AppTypography.geist(fontSize: 13, color: AppColors.bodySecondary),
      ),
      SizedBox(height: 8.h),
      Obx(
        () => Row(
          children: [
            Expanded(
              child: _choiceChip(
                selected: controller.rxAirportDirection.value == 'to_airport',
                label: 'To airport',
                onTap: () => controller.setAirportDirection('to_airport'),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _choiceChip(
                selected: controller.rxAirportDirection.value == 'from_airport',
                label: 'From airport',
                onTap: () => controller.setAirportDirection('from_airport'),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 12.h),
      Obx(
        () => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: controller.rxAirportRoundTrip.value,
          onChanged: (bool value) =>
              controller.rxAirportRoundTrip.value = value,
          activeThumbColor: AppColors.goldColor,
          title: Text(
            'One-way or round trip',
            style: AppTypography.geist(fontSize: 14, color: Colors.white),
          ),
          subtitle: Text(
            controller.rxAirportRoundTrip.value ? 'Round trip' : 'One way',
            style: AppTypography.geist(
              fontSize: 12,
              color: AppColors.bodySecondary,
            ),
          ),
        ),
      ),
      SizedBox(height: 4.h),
      Obx(
        () => TextField(
          controller: controller.addressController,
          style: const TextStyle(color: Colors.white),
          decoration: _decoration(
            controller.rxAirportDirection.value == 'to_airport'
                ? 'Pickup address'
                : 'Drop-off address',
          ),
        ),
      ),
      SizedBox(height: 10.h),
      TextField(
        controller: controller.flightController,
        style: const TextStyle(color: Colors.white),
        textCapitalization: TextCapitalization.characters,
        decoration: _decoration('Flight number (e.g. AA1234)'),
      ),
    ];
  }

  List<Widget> _hourlyFields() {
    return <Widget>[
      TextField(
        controller: controller.pickupController,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration('Pickup location'),
      ),
      SizedBox(height: 14.h),
      Text(
        'How many hours?',
        style: AppTypography.geist(fontSize: 13, color: AppColors.bodySecondary),
      ),
      SizedBox(height: 8.h),
      Obx(
        () => Row(
          children: [
            IconButton(
              onPressed: () =>
                  controller.setHours(controller.rxHours.value - 1),
              icon: Icon(
                Icons.remove_circle_outline,
                color: AppColors.goldColor,
              ),
            ),
            Expanded(
              child: Text(
                '${controller.rxHours.value} hour${controller.rxHours.value == 1 ? '' : 's'}',
                textAlign: TextAlign.center,
                style: AppTypography.geist(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: () =>
                  controller.setHours(controller.rxHours.value + 1),
              icon: Icon(Icons.add_circle_outline, color: AppColors.goldColor),
            ),
          ],
        ),
      ),
      SizedBox(height: 8.h),
      Wrap(
        spacing: 8.w,
        children: <int>[2, 3, 4, 6, 8].map((int hours) {
          return Obx(
            () => ChoiceChip(
              label: Text('$hours h'),
              selected: controller.rxHours.value == hours,
              onSelected: (_) => controller.setHours(hours),
              selectedColor: AppColors.goldColor,
              labelStyle: AppTypography.geist(
                fontSize: 12,
                color: controller.rxHours.value == hours
                    ? Colors.black
                    : Colors.white,
              ),
              backgroundColor: const Color(0xFF141414),
            ),
          );
        }).toList(),
      ),
    ];
  }

  List<Widget> _roundTripFields() {
    return <Widget>[
      TextField(
        controller: controller.pickupController,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration('Pickup'),
      ),
      SizedBox(height: 10.h),
      TextField(
        controller: controller.outboundController,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration('Outbound destination'),
      ),
      SizedBox(height: 10.h),
      TextField(
        controller: controller.returnDestinationController,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration('Return destination'),
      ),
    ];
  }

  Widget _choiceChip({
    required bool selected,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.goldColor : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.geist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
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
