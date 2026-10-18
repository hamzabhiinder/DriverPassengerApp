import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_map_tile_layer.dart';
import '../controller/passenger_where_to_controller.dart';

class PassengerWhereToMapLayer extends GetView<PassengerWhereToController> {
  const PassengerWhereToMapLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Obx(() {
          final LatLng center =
              controller.rxUserLocation.value ??
              PassengerWhereToController.mapInitialCenter;
          final List<LatLng> route = controller.rxRoutePoints.toList();
          return FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: PassengerWhereToController.mapInitialZoom,
              minZoom: 4,
              maxZoom: 19,
              backgroundColor: AppColors.background,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              const AppMapTileLayer(),
              if (route.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route,
                      strokeWidth: 4.5,
                      color: AppColors.goldMid,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (controller.rxUserLocation.value != null)
                    Marker(
                      point: controller.rxUserLocation.value!,
                      width: 44,
                      height: 44,
                      child: const Icon(
                        Icons.my_location,
                        color: AppColors.goldMid,
                        size: 28,
                      ),
                    ),
                  if (controller.rxDestinationLocation.value != null)
                    Marker(
                      point: controller.rxDestinationLocation.value!,
                      width: 44,
                      height: 44,
                      child: const Icon(
                        Icons.place,
                        color: Colors.white,
                        size: 32,
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
                    AppColors.background.withValues(alpha: 0.1),
                    AppColors.background.withValues(alpha: 0.3),
                    AppColors.background.withValues(alpha: 0.5),
                  ],
                  stops: const [0.0, 0.52, 1.0],
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
            top: 72,
            left: 16,
            right: 16,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Text(
                    controller.rxEtaLabel.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
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
