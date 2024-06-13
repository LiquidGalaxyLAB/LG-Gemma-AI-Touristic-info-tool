
import 'package:geocoding/geocoding.dart';

Future<LatLng> getCoordinates(String address) async {
  List<Location> locations = await locationFromAddress(address);
  Location location = locations.first;
  return LatLng(location.latitude, location.longitude);
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}