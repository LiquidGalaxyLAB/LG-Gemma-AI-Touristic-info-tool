import 'package:flutter/material.dart';


///This is a Provider]class of [Connectionprovider] that extends [ChangeNotifier]
///It has the following:
///  *  [_isLgConnected] to check the connection status
/// It has setters and getters


class Connectionprovider extends ChangeNotifier {

  bool _isLgConnected = false;

  set isLgConnected(bool value) {
    _isLgConnected = value;
    notifyListeners();
  }
  
  bool get isLgConnected => _isLgConnected;


  bool _isAiConnected = false;

  set isAiConnected(bool value) {
    _isAiConnected = value;
    notifyListeners();
  }
  
  bool get isAiConnected => _isAiConnected;

}