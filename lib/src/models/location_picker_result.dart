import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerResult {
  final LatLng target;
  final Placemark placemark;
  LocationPickerResult({required this.target, required this.placemark});
}
