

import 'package:flutter/material.dart';

class CurrentViewProvider extends ChangeNotifier {
  String _currentView = 'home';

  String get currentView => _currentView;

  set currentView(String view) {
    _currentView = view;
    notifyListeners();
  }
}
