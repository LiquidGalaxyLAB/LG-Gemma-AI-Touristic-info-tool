import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

class GeocodingService {
  Future<MyLatLng> getCoordinates(String address) async {
    // List<Location> locations = await locationFromAddress(address);
    // Location location = locations.first;
    // return MyLatLng(location.latitude, location.longitude);
    try {
      List<Location> locations = await locationFromAddress(address);
      Location location = locations.first;
      return MyLatLng(location.latitude, location.longitude);
    } catch (e) {
      print('error geocoding failed to get coordinates: ${e}');
      return MyLatLng(0.0, 0.0);
    }
  }

  Future<Map<String, String?>> getAddressFromLatLng(
      double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String? city = place.locality;
        String? country = place.country;
        String? address =
            '${place.street}, ${place.locality}, ${place.country}';

        return {
          'city': city,
          'country': country,
          'address': address,
        };
      } else {
        return {
          'city': null,
          'country': null,
          'address': null,
        };
      }
    } catch (e) {
      print('Failed to get address: $e');
      return {
        'city': null,
        'country': null,
        'address': null,
      };
      // throw Exception('Failed to get address: $e');
    }
  }

//   Future<bool> handleLocationPermission(BuildContext context) async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Location services are disabled. Please enable the services')));
//     return false;
//   }
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permissions are denied')));
//       return false;
//     }
//   }
//   if (permission == LocationPermission.deniedForever) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Location permissions are permanently denied, we cannot request permissions.')));
//     return false;
//   }
//   return true;
// }
}

class MyLatLng {
  final double latitude;
  final double longitude;

  MyLatLng(this.latitude, this.longitude);
}
