import 'dart:convert';

import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/models/saved_tours_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

///`FavoritesSharedPref` to presist data in the app locally
/// A utility class for managing and persisting favorites data locally using `shared_preferences`.
class FavoritesSharedPref {
  static SharedPreferences? _prefs;
  static const String _keySavedTours = 'tours';
  static const String _keySavedPlaces = 'placesList';

  /// Initializes the SharedPreferences instance for local data storage.
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  /// Saving a list of places
  Future<void> savePlacesList(List<PlacesModel> places) async {
    List<String> jsonStringList =
        places.map((place) => jsonEncode(place.toJson())).toList();
    await _prefs?.setStringList(_keySavedPlaces, jsonStringList);
  }


  /// Get the list of places
  Future<List<PlacesModel>> getPlacesList() async {
    List<String>? jsonStringList = _prefs?.getStringList(_keySavedPlaces);
    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => PlacesModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

  /// Add a PlaceModel to the list
  Future<void> addPlace(PlacesModel place) async {
    final places = await getPlacesList();
    places.add(place);
    await savePlacesList(places);
  }

  /// Remove a PlaceModel from the list
  Future<void> removePlace(String name, String country) async {
    final places = await getPlacesList();
    places.removeWhere(
        (place) => (place.name == name && place.country == country));
    await savePlacesList(places);
  }

  /// Check if a place is in the list
  Future<bool> isPlaceExist(String name, String country) async {
    final places = await getPlacesList();
    return places
        .any((place) => (place.name == name && place.country == country));
  }

  /// Clear the PlacesModel list
  Future<void> clearPlacesList() async {
    await _prefs?.remove(_keySavedPlaces);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// Saving a list of tours
  Future<void> saveToursList(List<SavedToursModel> tours) async {
    List<String> jsonStringList =
        tours.map((tour) => jsonEncode(tour.toJson())).toList();
    await _prefs?.setStringList(_keySavedTours, jsonStringList);
  }

  /// Get the list of tours
  Future<List<SavedToursModel>> getToursList() async {
    List<String>? jsonStringList = _prefs?.getStringList(_keySavedTours);
    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => SavedToursModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

  /// Add a SavedToursModel to the list
  Future<void> addTour(SavedToursModel tour) async {
    final tours = await getToursList();
    tours.add(tour);
    await saveToursList(tours);
  }

  /// Remove a SavedToursModel from the list
  Future<void> removeTour(String tourName) async {
    final tours = await getToursList();
    tours.removeWhere((tour) => tour.query == tourName);
    await saveToursList(tours);
  }

  /// Check if a tour is in the list
  Future<bool> isTourExist(String tourName) async {
    final tours = await getToursList();
    return tours.any((tour) => tour.query == tourName);
  }

  /// Clear the SavedToursModel list
  Future<void> clearToursList() async {
    await _prefs?.remove(_keySavedTours);
  }
}
