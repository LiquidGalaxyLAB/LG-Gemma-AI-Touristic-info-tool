import 'package:flutter/material.dart';

/// This is a Provider class of [SearchProvider] that extends [ChangeNotifier]
/// It has the following:
/// *  [_showMap] to check if the map is displayed
/// *  [_searchPoiSelected] to check the selected point of interest
/// *  [_searchPoiCountry] to check the country of the selected point of interest
/// *  [_searchPoiCity] to check the city of the selected point of interest
/// *  [_webSearchResults] to check the web search results
/// *  [_youtubeSearchResults] to check the youtube search results
/// *  [_isLoading] to check if the process is loading
/// *  [_poiLat] to check the latitude of the point of interest
/// *  [_poiLong] to check the longitude of the point of interest
/// It has setters and getters with notifyListeners
class SearchProvider with ChangeNotifier {
  bool _showMap = true;
  String _searchPoiSelected = '';
  String _searchPoiCountry = '';
  String _searchPoiCity = '';
  List<String> _webSearchResults = [];
  List<String> _youtubeSearchResults = [];
  bool _isLoading = false;
  double _poiLat=0;
  double _poiLong=0;

  bool get showMap => _showMap;
  String get searchPoiSelected => _searchPoiSelected;
  String get searchPoiCountry => _searchPoiCountry;
  String get searchPoiCity => _searchPoiCity;
  List<String> get webSearchResults => _webSearchResults;
  List<String> get youtubeSearchResults => _youtubeSearchResults;
  bool get isLoading => _isLoading;
  double get poiLat => _poiLat;
  double get poiLong => _poiLong;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set searchPoiCountry(String value) {
    _searchPoiCountry = value;
    notifyListeners();
  }

  set searchPoiCity(String value) {
    _searchPoiCity = value;
    notifyListeners();
  }

  set webSearchResults(List<String> value) {
    _webSearchResults = value;
    notifyListeners();
  }

  set youtubeSearchResults(List<String> value) {
    _youtubeSearchResults = value;
    notifyListeners();
  }

  set searchPoiSelected(String value) {
    _searchPoiSelected = value;
    notifyListeners();
  }

  set showMap(bool value) {
    _showMap = value;
    notifyListeners();
  }

  set poiLat(double value) {
    _poiLat = value;
    notifyListeners();
  }

  set poiLong(double value) {
    _poiLong = value;
    notifyListeners();
  }
}
