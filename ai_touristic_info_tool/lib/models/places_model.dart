import 'dart:convert';

class PlacesModel {
  int id;
  String name;
  String address;
  String? city;
  String? country;
  String? description;
  double? ratings;
  String? amenities;
  String? price;
  double latitude;
  double longitude;
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

  // Convert a Place into a JSON Map
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

  // Convert a JSON into a Place Object
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

  // // Encode to JSON string
  // String encodeToJson() => json.encode(toJson());

  // // Decode from JSON string
  // factory PlacesModel.decodeFromJson(String source) =>
  //     PlacesModel.fromJson(json.decode(source));
}


