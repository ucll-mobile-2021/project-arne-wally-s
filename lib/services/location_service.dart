import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class LocationService {
  static Future<LatLng> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LatLng(50.879144, 4.700834);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return LatLng(50.879144, 4.700834);
      }
    }

    _locationData = await location.getLocation();
    return LatLng(_locationData.latitude, _locationData.longitude);
  }
}