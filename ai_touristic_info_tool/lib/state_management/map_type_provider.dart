import 'package:flutter/material.dart';

/// This is a Provider class of [MapTypeProvider] that extends [ChangeNotifier]
/// It has the following:
/// *  [_currentView] to check the current view
/// It has setters and getters with notifyListeners
class MapTypeProvider extends ChangeNotifier {
  String _currentView = 'satellite';

  String get currentView => _currentView;

  set currentView(String view) {
    _currentView = view;
    notifyListeners();
  }
}
