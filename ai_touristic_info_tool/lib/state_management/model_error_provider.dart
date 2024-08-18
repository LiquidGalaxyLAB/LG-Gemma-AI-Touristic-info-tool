import 'package:flutter/material.dart';

/// This is a Provider class of [ModelErrorProvider] that extends [ChangeNotifier]
/// It has the following:
/// *  [_isError] to check if there is an error
/// *  [_hasStarted] to check if the process has started
/// *  [_isCanceled] to check if the process has been canceled
/// It has setters and getters with notifyListeners

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
