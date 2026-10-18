abstract final class GoogleMapsConfig {
  static const String apiKey = 'AIzaSyCvhWQ9ln_3Wv8NGoHQfrUeSP_kVX2qoMw';
  static const String userAgentPackageName = 'com.app.blacklines';
  /// Google raster tiles used by flutter_map map screens.
  static const String tileUrlTemplate =
      'https://mt{s}.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}';
  static const List<String> tileSubdomains = <String>['0', '1', '2', '3'];
}
