import 'package:flutter/material.dart';

class ModelErrorProvider extends ChangeNotifier {
  bool _isError = false;
  bool _hasStarted = false;
  bool _isCanceled = false;

  bool get isError => _isError;
  bool get hasStarted => _hasStarted;
  bool get isCanceled => _isCanceled;

  set isCanceled(bool value) {
    _isCanceled = value;
    notifyListeners();
  }

  set hasStarted(bool value) {
    _hasStarted = value;
    notifyListeners();
  }

  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }
}
