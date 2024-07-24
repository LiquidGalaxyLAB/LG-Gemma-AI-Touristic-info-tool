import 'package:ai_touristic_info_tool/models/places_model.dart';

class SavedToursModel {
  String query;
  List<PlacesModel> places;
  String country;
  String city;
  bool isGenerated;

  SavedToursModel({
    required this.query,
    required this.places,
    this.country = '',
    this.city = '',
    required this.isGenerated,
  });

  // Convert a Tour into a JSON Map
  Map<String, dynamic> toJson() => {
        'query': query,
        'places': places.map((place) => place.toJson()).toList(),
        'country': country,
        'city': city,
        'isGenerated': isGenerated,
      };

  // Convert a JSON into a Tour Object
  factory SavedToursModel.fromJson(Map<String, dynamic> json) {
    return SavedToursModel(
      query: json['query'],
      places: List<PlacesModel>.from(
        json['places']?.map((place) => PlacesModel.fromJson(place)),
      ),
      country: json['country'],
      city: json['city'],
      isGenerated: json['isGenerated'],
    );
  }

  // // Encode to JSON string
  // String encodeToJson() => json.encode(toJson());

  // // Decode from JSON string
  // factory SavedToursModel.decodeFromJson(String source) =>
  //     SavedToursModel.fromJson(json.decode(source));
}
