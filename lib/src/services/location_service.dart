import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  getPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LocationData> getCurrentLocation() async {
    LocationData locationData;
    await getPermission();

    locationData = await location.getLocation();
    return locationData;
  }
}
