import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/dynamic_colors_model.dart';
import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  DynamicAppColors _color =
      DynamicAppColors.fromButtonColor(PrimaryAppColors.buttonColors);

  String _theme = SettingsSharedPref.getTheme() ?? 'default';
  DynamicAppColors get colors => _color;
  String get theme => _theme;

  void updateButtonColor(Color chosenColor) {
    _color.updateColors(chosenColor);
    notifyListeners();
  }

  void updateTheme(String chosenTheme) {
    _theme = chosenTheme;
    notifyListeners();
  }
}
