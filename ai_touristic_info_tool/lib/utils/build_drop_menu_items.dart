import 'package:flutter/material.dart';

/// a function for building the menu item in a dropdown menu with a customized `fontSize` and  `item`
DropdownMenuItem<String> buildMenuItem(String item, double fontSize) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style:  TextStyle(fontSize: fontSize),
    ));

