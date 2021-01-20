import 'dart:convert';

import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

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

  static Future<List<Supermarket>> getSupermarkets(LatLng location) async {
    var body = '''[out:json][timeout:25];
(
  node["shop"="supermarket"](${location.latitude - .1},${location.longitude - .1},${location.latitude + .1},${location.longitude + .1});
  way["shop"="supermarket"](${location.latitude - .1},${location.longitude - .1},${location.latitude + .1},${location.longitude + .1});
  relation["shop"="supermarket"](${location.latitude - .1},${location.longitude - .1},${location.latitude + .1},${location.longitude + .1});
);
out body;
>;
out skel qt;''';
    var response = await http.post('https://overpass-api.de/api/interpreter',
        body: body);
    //print(response.body);
    var json = jsonDecode(response.body);
    List<Supermarket> supermarkets = [];
    for (var el in json['elements']) {
      if (el['tags'] != null) {
        if (el['tags']['name'] != null && el['lat'] != null && el['lon'] != null) {
          supermarkets.add(Supermarket(el['tags']['name'], LatLng(el['lat'], el['lon'])));
        }
      }
    }
    return supermarkets;
  }
}

class Supermarket {
  LatLng location;
  String name;
  Supermarket(this.name, this.location);
}
