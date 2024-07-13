import 'package:flutter/material.dart';
import 'package:location_picker_flutter/location_picker_flutter.dart';

class LocationPickerFlutter extends StatelessWidget {
  const LocationPickerFlutter({super.key});

  static Future<void> pickLocation(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LocationPicker(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LocationPicker();
  }
}
