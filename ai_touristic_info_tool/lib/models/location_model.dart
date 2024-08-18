
/// Class that defines the `Location` entity, which contains its properties and
/// methods.
class LocationModel {
  /// Property that defines the `country`.
  String country;

  /// Property that defines the `city`.
  String city;

  /// Property that defines the `latitude`.
  double latitude;

  /// Property that defines the `longitude`.
  double longitude;

  LocationModel({
    required this.country,
    required this.city,
    required this.latitude,
    required this.longitude,
  });
}