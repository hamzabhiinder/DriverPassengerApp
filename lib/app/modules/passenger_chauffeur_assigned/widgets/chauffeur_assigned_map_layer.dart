import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../../passenger_where_to/controller/passenger_where_to_controller.dart';
import '../controller/passenger_chauffeur_assigned_controller.dart';

/// Dark map + nearby grey cars + centered pickup glow (same region as where-to).
class ChauffeurAssignedMapLayer
    extends GetView<PassengerChauffeurAssignedController> {
  const ChauffeurAssignedMapLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final center = PassengerWhereToController.mapInitialCenter;

    final cars = <LatLng>[
      LatLng(center.latitude + 0.0038, center.longitude + 0.0028),
      LatLng(center.latitude - 0.0045, center.longitude + 0.0015),
      LatLng(center.latitude + 0.0020, center.longitude - 0.0042),
      LatLng(center.latitude - 0.0030, center.longitude - 0.0035),
      LatLng(center.latitude + 0.0055, center.longitude - 0.0010),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
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
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.driver_passenger_app.app',
            ),
            MarkerLayer(
              markers: [
                for (var i = 0; i < cars.length; i++)
                  Marker(
                    point: cars[i],
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: -0.2 + (i * 0.18),
                      child: Icon(
                        Icons.directions_car_rounded,
                        color: Colors.grey.shade400.withValues(alpha: 0.75),
                        size: 26,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.08),
                    AppColors.background.withValues(alpha: 0.28),
                    AppColors.background.withValues(alpha: 0.48),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),

        IgnorePointer(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldMid.withValues(alpha: 0.35),
                    blurRadius: 36,
                    spreadRadius: 8,
                  ),
                  BoxShadow(
                    color: AppColors.goldRing.withValues(alpha: 0.22),
                    blurRadius: 52,
                    spreadRadius: 12,
                  ),
                ],
              ),
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldMid,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
