import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart';
import '../controller/passenger_where_to_controller.dart';

class PassengerWhereToMapLayer extends GetView<PassengerWhereToController> {
  const PassengerWhereToMapLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final center = PassengerWhereToController.mapInitialCenter;
    final carA = LatLng(center.latitude + 0.004, center.longitude + 0.003);
    final carB = LatLng(center.latitude - 0.005, center.longitude - 0.004);

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
                Marker(
                  point: carA,
                  width: 45,
                  height: 45,
                  child: Transform.rotate(
                    angle: -0.35,
                    child: Icon(
                      Icons.directions_car_rounded,
                      // Car icon ko light grey ya goldish white rakhein
                      color: Colors.white.withOpacity(0.8),
                      size: 30,
                    ),
                  ),
                ),
                Marker(
                  point: carB,
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: 0.45,
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: AppColors.onBackgroundBright,
                      size: 28,
                      shadows: [
                        Shadow(color: AppColors.background, blurRadius: 4),
                      ],
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
                    AppColors.background.withValues(
                      alpha: 0.1,
                    ), // 0.35 se 0.1 kar dein
                    AppColors.background.withValues(
                      alpha: 0.3,
                    ), // 0.55 se 0.3 kar dein
                    AppColors.background.withValues(
                      alpha: 0.5,
                    ), // 0.72 se 0.5 kar dein
                  ],
                  stops: const [0.0, 0.52, 1.0],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 8,
          bottom: 8,
          child: IgnorePointer(
            child: Text(
              '© OpenStreetMap contributors',
              style: TextStyle(
                color: AppColors.onSurfaceMuted.withValues(alpha: 0.65),
                fontSize: 10,
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldMid.withValues(alpha: 0.55),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.goldRing.withValues(alpha: 0.35),
                        blurRadius: 40,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.goldMid,
                    size: 46,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
