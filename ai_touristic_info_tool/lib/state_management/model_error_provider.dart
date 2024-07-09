import 'package:flutter/material.dart';

class ModelErrorProvider extends ChangeNotifier {
  bool _isError = false;
  bool _hasStarted = false;

  bool get isError => _isError;
  bool get hasStarted => _hasStarted;


  set hasStarted(bool value) {
    _hasStarted = value;
    notifyListeners();
  }

  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }
}
