import 'dart:convert';

import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/models/saved_tours_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesSharedPref {
  static SharedPreferences? _prefs;
  static const String _keySavedTours = 'tours';
  static const String _keySavedPlaces = 'placesList';

  /// Initializes the SharedPreferences instance for local data storage.
  // static Future init() async => _prefs = await SharedPreferences.getInstance();
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  //Saving a list of places
  Future<void> savePlacesList(List<PlacesModel> places) async {
    //convert from list of maps(placesmodel) to list of string(json)
    List<String> jsonStringList =
        places.map((place) => jsonEncode(place.toJson())).toList();
    await _prefs?.setStringList(_keySavedPlaces, jsonStringList);
  }

  Future<List<PlacesModel>> getPlacesList() async {
    List<String>? jsonStringList = _prefs?.getStringList(_keySavedPlaces);
    //convert from list of string(json) to list of maps(placesmodel)
    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => PlacesModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

  // Add a PlaceModel to the list
  Future<void> addPlace(PlacesModel place) async {
    final places = await getPlacesList();
    places.add(place);
    await savePlacesList(places);
  }

  // Remove a PlaceModel from the list
  Future<void> removePlace(String name, String country) async {
    final places = await getPlacesList();
    places.removeWhere(
        (place) => (place.name == name && place.country == country));
    await savePlacesList(places);
  }

  // Check if a PlaceModel is in the list
  Future<bool> isPlaceExist(String name, String country) async {
    final places = await getPlacesList();
    return places
        .any((place) => (place.name == name && place.country == country));
  }

  // Clear the PlacesModel list
  Future<void> clearPlacesList() async {
    await _prefs?.remove(_keySavedPlaces);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  //Saving a list of tours
  Future<void> saveToursList(List<SavedToursModel> tours) async {
    //convert from list of maps(toursmodel) to list of string(json)
    List<String> jsonStringList =
        tours.map((tour) => jsonEncode(tour.toJson())).toList();
    await _prefs?.setStringList(_keySavedTours, jsonStringList);
  }

  Future<List<SavedToursModel>> getToursList() async {
    List<String>? jsonStringList = _prefs?.getStringList(_keySavedTours);
    //convert from list of string(json) to list of maps(toursModel)
    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => SavedToursModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

// Add a TourModel to the list
  Future<void> addTour(SavedToursModel tour) async {
    final tours = await getToursList();
    tours.add(tour);
    await saveToursList(tours);
  }

  // Remove a TourModel from the list
  Future<void> removeTour(String tourName) async {
    final tours = await getToursList();
    tours.removeWhere((tour) => tour.query == tourName);
    await saveToursList(tours);
  }

  // Check if a tour is in the list
  Future<bool> isTourExist(String tourName) async {
    final tours = await getToursList();
    return tours.any((tour) => tour.query == tourName);
  }

  // Clear the SavedToursModel list
  Future<void> clearToursList() async {
    await _prefs?.remove(_keySavedTours);
  }
}
