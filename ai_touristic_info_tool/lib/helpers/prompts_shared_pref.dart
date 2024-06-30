import 'dart:convert';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromptsSharedPref {
  static SharedPreferences? _prefs;

  static const String _keyMap = 'map_places';

  /// Initializes the SharedPreferences instance for local data storage.
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initializeDefaultData();
  }

  /// Initializes default data to be saved in the list initially.
  static Future _initializeDefaultData() async {
    Map<String, List<PlacesModel>> defaultData= defaultDataConst;
    Map<String, List<PlacesModel>> existingData = await getAllPlaces();
    if (existingData.isEmpty) {
      await setAllPlaces(defaultData);
    }
  }

  /// Sets the entire map of places.
  static Future setAllPlaces(Map<String, List<PlacesModel>> data) async {
    final encodedData = data.map((key, places) => MapEntry(
        key, jsonEncode(places.map((place) => place.toJson()).toList())));
    await _prefs?.setString(_keyMap, jsonEncode(encodedData));
  }

  /// Gets the entire map of places.
  static Future<Map<String, List<PlacesModel>>> getAllPlaces() async {
    final String? encodedData = _prefs?.getString(_keyMap);
    if (encodedData != null) {
      final Map<String, dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((key, value) {
        final List<dynamic> placesJson = jsonDecode(value);
        return MapEntry(
            key, placesJson.map((json) => PlacesModel.fromJson(json)).toList());
      });
    } else {
      return {};
    }
  }

  /// Sets the list of places for a specific query.
  static Future setPlaces(String query, List<PlacesModel> places) async {
    Map<String, List<PlacesModel>> data = await getAllPlaces();
    data[query] = places;
    await setAllPlaces(data);
  }

  /// Gets the list of places for a specific query.
  static Future<List<PlacesModel>> getPlaces(String query) async {
    Map<String, List<PlacesModel>> data = await getAllPlaces();
    return data[query] ?? [];
  }

  /// Adds a place to the list for a specific query.
  static Future addPlace(String query, PlacesModel newPlace) async {
    List<PlacesModel> places = await getPlaces(query);
    places.add(newPlace);
    await setPlaces(query, places);
  }

  /// Removes a place from the list for a specific query.
  static Future removePlace(String query, PlacesModel placeToRemove) async {
    List<PlacesModel> places = await getPlaces(query);
    places.removeWhere((place) =>
    place.id == placeToRemove.id &&
        place.name == placeToRemove.name &&
        place.description == placeToRemove.description);
    await setPlaces(query, places);
  }
 /// Clears all stored preferences.
  static Future clearPreferences() async {
    await _prefs?.clear();
  }

}
