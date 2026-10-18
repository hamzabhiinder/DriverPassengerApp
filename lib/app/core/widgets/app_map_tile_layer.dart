import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../constants/google_maps_config.dart';

class AppMapTileLayer extends StatelessWidget {
  const AppMapTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: GoogleMapsConfig.tileUrlTemplate,
      subdomains: GoogleMapsConfig.tileSubdomains,
      userAgentPackageName: GoogleMapsConfig.userAgentPackageName,
      maxNativeZoom: 20,
    );
  }
}
