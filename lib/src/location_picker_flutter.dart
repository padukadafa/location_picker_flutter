import 'package:flutter/material.dart';
import 'package:location_picker_flutter/location_picker_flutter.dart';
import 'package:location_picker_flutter/src/models/location_picker_result.dart';

class LocationPickerFlutter extends StatelessWidget {
  const LocationPickerFlutter({super.key});

  static Future<LocationPickerResult?> pickLocation(
      BuildContext context) async {
    final result = await Navigator.of(context).push<LocationPickerResult?>(
      MaterialPageRoute(
        builder: (_) => const LocationPicker(),
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return const LocationPicker();
  }
}
