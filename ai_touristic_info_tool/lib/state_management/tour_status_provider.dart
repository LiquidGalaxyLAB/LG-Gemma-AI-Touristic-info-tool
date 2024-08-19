import 'package:flutter/material.dart';


///This is a Provider]class of [Connectionprovider] that extends [ChangeNotifier]
///It has the following:
///  *  [_isLgConnected] to check the connection status
/// It has setters and getters


class TourStatusprovider extends ChangeNotifier {

  bool _isTourOn = false;

  set isTourOn(bool value) {
    _isTourOn = value;
    notifyListeners();
  }
  
  bool get isTourOn => _isTourOn;


}