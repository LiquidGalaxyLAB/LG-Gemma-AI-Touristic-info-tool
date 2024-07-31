import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:flutter/material.dart';

class DisplayedListProvider extends ChangeNotifier {
  List<PlacesModel> _displayedList = [];
  List<PlacesModel> _tourPlaces = [];

  List<PlacesModel> get displayedList => _displayedList;
  List<PlacesModel> get tourPlaces => _tourPlaces;

  void setDisplayedList(List<PlacesModel> list) {
    _displayedList = list;
    notifyListeners();
  }

  void addPlace(PlacesModel place) {
    _displayedList.add(place);
    notifyListeners();
  }

  void removePlace(PlacesModel place) {
    _displayedList.remove(place);
    notifyListeners();
  }

  void setTourPlaces(List<PlacesModel> list) {
    _tourPlaces = list;
    notifyListeners();
  }

  void addTourPlace(PlacesModel place) {
    _tourPlaces.add(place);
    notifyListeners();
  }

  void removeTourPlace(PlacesModel place) {
    _tourPlaces.remove(place);
    notifyListeners();
  }
}
