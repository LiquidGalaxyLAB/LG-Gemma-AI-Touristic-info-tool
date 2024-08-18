import 'package:geocoding/geocoding.dart';


/// A service class that provides geocoding functionality, such as converting
/// addresses into coordinates and vice versa.
class GeocodingService {
  /// Converts a given address into geographic coordinates (latitude and longitude).
  ///
  /// Returns a [MyLatLng] object containing the latitude and longitude of the
  /// first location found for the given address. If the address cannot be
  /// geocoded, it returns a [MyLatLng] object with coordinates (0.0, 0.0).
  ///
  /// - Parameter address: The address to be converted into coordinates.
  /// - Returns: A [MyLatLng] object containing the latitude and longitude.
  Future<MyLatLng> getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      Location location = locations.first;
      return MyLatLng(location.latitude, location.longitude);
    } catch (e) {
      print('error geocoding failed to get coordinates: ${e}');
      return MyLatLng(0.0, 0.0);
    }
  }
  
  /// Converts geographic coordinates (latitude and longitude) into a human-readable address.
  ///
  /// Returns a [Map] containing the city, country, and full address corresponding
  /// to the provided latitude and longitude. If the address cannot be determined,
  /// the map values will be `null`.
  ///
  /// - Parameters:
  ///   - lat: The latitude of the location.
  ///   - lng: The longitude of the location.
  /// - Returns: A [Map] with keys 'city', 'country', and 'address', each containing
  ///   a string value or `null` if the address could not be determined.
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
}

class MyLatLng {
  final double latitude;
  final double longitude;

  MyLatLng(this.latitude, this.longitude);
}
