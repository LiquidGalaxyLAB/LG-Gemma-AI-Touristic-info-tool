import 'package:flutter/material.dart';

class MapTypeProvider extends ChangeNotifier {
  String _currentView = 'satellite';

  String get currentView => _currentView;

  set currentView(String view) {
    _currentView = view;
    notifyListeners();
  }
}
