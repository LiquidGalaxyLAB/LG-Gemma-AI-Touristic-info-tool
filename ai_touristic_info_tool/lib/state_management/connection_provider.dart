import 'package:flutter/material.dart';


///This is a [Provider] class of [Connectionprovider] that extends [ChangeNotifier]
///It has the following:
///  *  [_isConnected] to check the connection status
/// It has setters and getters


class Connectionprovider extends ChangeNotifier {

  bool _isConnected = false;

  set isConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }
  
  bool get isConnected => _isConnected;

}