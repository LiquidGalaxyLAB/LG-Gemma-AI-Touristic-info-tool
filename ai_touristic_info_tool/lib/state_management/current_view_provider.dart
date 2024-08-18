

import 'package:flutter/material.dart';
  
  /// This is a Provider class of [CurrentViewProvider] that extends [ChangeNotifier]
  /// It has the following:
  /// *  [_currentView] to check the current view
  /// It has setters and getters
  
class CurrentViewProvider extends ChangeNotifier {
  String _currentView = 'home';

  String get currentView => _currentView;

  set currentView(String view) {
    _currentView = view;
    notifyListeners();
  }
}
