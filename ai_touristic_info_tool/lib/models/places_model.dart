
/// Class that defines the `Places` entity, which contains its properties and
/// methods.
class PlacesModel {
  /// Property that defines the `id`.  
  int id;

  /// Property that defines the `name`.
  String name;

  /// Property that defines the `address`.
  String address;

  /// Property that defines the `city`.
  String? city;

  /// Property that defines the `country`.
  String? country;

  /// Property that defines the `description`.
  String? description;

  /// Property that defines the `ratings`.
  double? ratings;

  /// Property that defines the `amenities`.
  String? amenities;

  /// Property that defines the `price`.
  String? price;

  /// Property that defines the `latitude`.
  double latitude;

  /// Property that defines the `longitude`.
  double longitude;

  /// Property that defines the `sourceLink`.
  String? sourceLink;

  PlacesModel({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.country,
    this.description,
    this.ratings,
    this.amenities,
    this.price,
    required this.latitude,
    required this.longitude,
    this.sourceLink
  });

  /// Returns a [Map] from the current [PlacesModel].
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'city': city,
        'country': country,
        'description': description,
        'ratings': ratings,
        'amenities': amenities,
        'price': price,
        'latitude': latitude,
        'longitude': longitude,
        'sourceLink': sourceLink
      };

  /// Returns a [PlacesModel] from the given [map].
  factory PlacesModel.fromJson(Map<String, dynamic> json) {
    return PlacesModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      description: json['description'],
      ratings: json['ratings'],
      amenities: json['amenities'],
      price: json['price'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      sourceLink: json['sourceLink']
    );
  }
}


