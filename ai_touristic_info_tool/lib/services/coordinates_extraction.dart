
import 'package:geocoding/geocoding.dart';

Future<MyLatLng> getCoordinates(String address) async {
  List<Location> locations = await locationFromAddress(address);
  Location location = locations.first;
  return MyLatLng(location.latitude, location.longitude);
}

class MyLatLng {
  final double latitude;
  final double longitude;

  MyLatLng(this.latitude, this.longitude);
}