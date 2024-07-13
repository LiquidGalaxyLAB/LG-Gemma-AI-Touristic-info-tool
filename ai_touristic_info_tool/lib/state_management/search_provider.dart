import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  bool _showMap = true;
  String _searchPoiSelected = '';
  List<String> _webSearchResults = [];
  List<String> _youtubeSearchResults = [];
  bool _isLoading = false;

  bool get showMap => _showMap;
  String get searchPoiSelected => _searchPoiSelected;
  List<String> get webSearchResults => _webSearchResults;
  List<String> get youtubeSearchResults => _youtubeSearchResults;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
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
}
