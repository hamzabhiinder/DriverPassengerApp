import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../core/constants/google_maps_config.dart';

class DirectionsResult {
  const DirectionsResult({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
  });

  final List<LatLng> points;
  final double distanceKm;
  final int durationMinutes;
}

class DirectionsService extends GetxService {
  Future<DirectionsResult?> fetchRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final DirectionsResult? google = await _fetchGoogle(origin, destination);
    if (google != null) {
      return google;
    }
    return _fetchOsrm(origin, destination);
  }

  Future<LatLng?> geocode(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      <String, String>{
        'address': trimmed,
        'key': GoogleMapsConfig.apiKey,
      },
    );
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = body['results'] as List<dynamic>? ?? <dynamic>[];
      if (results.isEmpty) {
        return null;
      }
      final Map<String, dynamic> location =
          ((results.first as Map)['geometry'] as Map)['location'] as Map<String, dynamic>;
      return LatLng(
        (location['lat'] as num).toDouble(),
        (location['lng'] as num).toDouble(),
      );
    } on Object {
      return null;
    }
  }

  Future<String?> reverseGeocode(LatLng point) async {
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      <String, String>{
        'latlng': '${point.latitude},${point.longitude}',
        'key': GoogleMapsConfig.apiKey,
      },
    );
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = body['results'] as List<dynamic>? ?? <dynamic>[];
      if (results.isEmpty) {
        return null;
      }
      return (results.first as Map)['formatted_address'] as String?;
    } on Object {
      return null;
    }
  }

  Future<DirectionsResult?> _fetchGoogle(LatLng origin, LatLng destination) async {
    final Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/directions/json',
      <String, String>{
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': 'driving',
        'key': GoogleMapsConfig.apiKey,
      },
    );
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (body['status'] != 'OK') {
        return null;
      }
      final List<dynamic> routes = body['routes'] as List<dynamic>? ?? <dynamic>[];
      if (routes.isEmpty) {
        return null;
      }
      final Map<String, dynamic> route = routes.first as Map<String, dynamic>;
      final String encoded =
          (route['overview_polyline'] as Map)['points'] as String? ?? '';
      final List<dynamic> legs = route['legs'] as List<dynamic>? ?? <dynamic>[];
      double meters = 0;
      double seconds = 0;
      if (legs.isNotEmpty) {
        final Map<String, dynamic> leg = legs.first as Map<String, dynamic>;
        meters = ((leg['distance'] as Map?)?['value'] as num?)?.toDouble() ?? 0;
        seconds = ((leg['duration'] as Map?)?['value'] as num?)?.toDouble() ?? 0;
      }
      return DirectionsResult(
        points: _decodePolyline(encoded),
        distanceKm: meters / 1000,
        durationMinutes: (seconds / 60).round().clamp(1, 999),
      );
    } on Object {
      return null;
    }
  }

  Future<DirectionsResult?> _fetchOsrm(LatLng origin, LatLng destination) async {
    final Uri uri = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${origin.longitude},${origin.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson',
    );
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> routes = body['routes'] as List<dynamic>? ?? <dynamic>[];
      if (routes.isEmpty) {
        return null;
      }
      final Map<String, dynamic> route = routes.first as Map<String, dynamic>;
      final List<dynamic> coords =
          ((route['geometry'] as Map?)?['coordinates'] as List<dynamic>?) ??
              <dynamic>[];
      final List<LatLng> points = coords.map((dynamic item) {
        final List<dynamic> pair = item as List<dynamic>;
        return LatLng(
          (pair[1] as num).toDouble(),
          (pair[0] as num).toDouble(),
        );
      }).toList();
      final double meters = (route['distance'] as num?)?.toDouble() ?? 0;
      final double seconds = (route['duration'] as num?)?.toDouble() ?? 0;
      return DirectionsResult(
        points: points,
        distanceKm: meters / 1000,
        durationMinutes: (seconds / 60).round().clamp(1, 999),
      );
    } on Object {
      return null;
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;
    while (index < encoded.length) {
      int result = 0;
      int shift = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;
      result = 0;
      shift = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;
      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }
}
