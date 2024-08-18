import 'package:ai_touristic_info_tool/models/places_model.dart';

/// Class that defines the `SavedToursModel` entity, which contains its properties and methods.
class SavedToursModel {
  /// Property that defines the `query`.
  String query;

  /// Property that defines the `places`.
  List<PlacesModel> places;

  /// Property that defines the `country`.
  String country;

  /// Property that defines the `city`.
  String city;

  /// Property that defines the `isGenerated`.
  bool isGenerated;

  SavedToursModel({
    required this.query,
    required this.places,
    this.country = '',
    this.city = '',
    required this.isGenerated,
  });

  /// Returns a [Map] from the current [SavedToursModel].
  Map<String, dynamic> toJson() => {
        'query': query,
        'places': places.map((place) => place.toJson()).toList(),
        'country': country,
        'city': city,
        'isGenerated': isGenerated,
      };

  /// Returns a [SavedToursModel] from the given [json].
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

}
