import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_map_tile_layer.dart';
import '../../passenger_where_to/controller/passenger_where_to_controller.dart';
import '../controller/passenger_chauffeur_assigned_controller.dart';

class ChauffeurAssignedMapLayer
    extends GetView<PassengerChauffeurAssignedController> {
  const ChauffeurAssignedMapLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Obx(() {
          final LatLng center = controller.rxDriverLocation.value ??
              controller.rxPickupLocation.value ??
              PassengerWhereToController.mapInitialCenter;
          final List<LatLng> tripRoute = controller.rxTripRoutePoints.toList();
          final List<LatLng> driverRoute = controller.rxDriverRoutePoints.toList();
          return FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13,
              minZoom: 4,
              maxZoom: 19,
              backgroundColor: AppColors.background,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              const AppMapTileLayer(),
              PolylineLayer(
                polylines: [
                  if (tripRoute.length >= 2)
                    Polyline(
                      points: tripRoute,
                      strokeWidth: 5,
                      color: AppColors.goldMid.withValues(alpha: 0.9),
                    ),
                  if (driverRoute.length >= 2)
                    Polyline(
                      points: driverRoute,
                      strokeWidth: 4,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  ...controller.rxNearbyDrivers.map(
                    (LatLng point) => Marker(
                      point: point,
                      width: 34,
                      height: 34,
                      child: Icon(
                        Icons.directions_car_rounded,
                        color: Colors.white.withValues(alpha: 0.75),
                        size: 26,
                      ),
                    ),
                  ),
                  if (controller.rxPickupLocation.value != null)
                    Marker(
                      point: controller.rxPickupLocation.value!,
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: AppColors.goldMid,
                        size: 40,
                      ),
                    ),
                  if (controller.rxDestinationLocation.value != null)
                    Marker(
                      point: controller.rxDestinationLocation.value!,
                      width: 44,
                      height: 44,
                      child: const Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  if (controller.rxDriverLocation.value != null)
                    Marker(
                      point: controller.rxDriverLocation.value!,
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.directions_car_filled,
                        color: AppColors.goldMid,
                        size: 38,
                      ),
                    ),
                ],
              ),
            ],
          );
        }),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.04),
                    AppColors.background.withValues(alpha: 0.1),
                    AppColors.background.withValues(alpha: 0.32),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
        ),
        Obx(() {
          if (controller.rxEtaLabel.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Positioned(
            top: 64,
            left: 16,
            right: 16,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Text(
                    controller.rxEtaLabel.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
