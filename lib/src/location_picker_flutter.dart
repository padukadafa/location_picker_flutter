import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker_flutter/location_picker_flutter.dart';
import 'package:location_picker_flutter/src/models/location_picker_result.dart';

class LocationPickerFlutter extends StatelessWidget {
  const LocationPickerFlutter({super.key});

  static Future<LocationPickerResult?> pickLocation(
    BuildContext context, {
    LatLng? initialLocation,
  }) async {
    final result = await Navigator.of(context).push<LocationPickerResult?>(
      MaterialPageRoute(
        builder: (_) => LocationPicker(
          initialLocation: initialLocation,
        ),
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LocationPicker();
  }
}
