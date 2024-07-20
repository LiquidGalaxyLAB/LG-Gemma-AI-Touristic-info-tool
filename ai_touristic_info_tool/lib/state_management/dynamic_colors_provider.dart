import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/dynamic_colors_model.dart';
import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  DynamicAppColors _color =
      DynamicAppColors.fromButtonColor(PrimaryAppColors.buttonColors);

  DynamicAppColors get colors => _color;

  void updateButtonColor(Color chosenColor) {
    _color.updateColors(chosenColor);
    notifyListeners();
  }
}
