import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker_flutter/location_picker_flutter.dart';
import 'package:location_picker_flutter/src/services/location_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String? googleMapStyle;
  late GoogleMapController mapController;
  DateTime? currentDate;
  String? street;
  String? locationDetail;
  LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((r) async {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        setState(() {
          googleMapStyle = GoogleMapsTheme.dark;
        });
      } else {
        setState(() {
          googleMapStyle = GoogleMapsTheme.light;
        });
      }
      final dispatcher = SchedulerBinding.instance.platformDispatcher;

      dispatcher.onPlatformBrightnessChanged = () {
        if (MediaQuery.of(context).platformBrightness != Brightness.dark) {
          setState(() {
            googleMapStyle = GoogleMapsTheme.dark;
          });
        } else {
          setState(() {
            googleMapStyle = GoogleMapsTheme.light;
          });
        }
      };
      List<Placemark> placemarks =
          await placemarkFromCoordinates(-5.3630526, 105.3094932);
      setState(() {
        street = placemarks.first.street;
        locationDetail =
            "$street, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-5.3630526, 105.3094932),
                zoom: 16,
              ),
              style: googleMapStyle,
              trafficEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (c) {
                mapController = c;
              },
              onCameraMove: (cameraPosition) async {
                setState(() {
                  street = null;
                  locationDetail = null;
                });
                final initDate = DateTime.now();
                currentDate = initDate;
                await Future.delayed(const Duration(milliseconds: 500));
                if (currentDate == initDate) {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude);
                  setState(() {
                    street = placemarks.first.street;
                    locationDetail =
                        "$street, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}";
                  });
                }
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceBright,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: locationDetail == null ? 0 : 18,
                  ),
                  const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 36,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: locationDetail == null ? 18 : 0,
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    height: 56,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceBright,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async {
                        final currentLocation =
                            await locationService.getCurrentLocation();
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                currentLocation.latitude ?? 0,
                                currentLocation.longitude ?? 0,
                              ),
                              zoom: 18,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_searching),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceBright,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Skeletonizer(
                      enabled: locationDetail == null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          ListTile(
                            title: Text(street ?? BoneMock.city),
                            subtitle: Text(
                              locationDetail ?? BoneMock.address,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Next"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
