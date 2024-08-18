import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/dynamic_colors_model.dart';
import 'package:flutter/material.dart';

/// This class is used to manage the colors of the app.
/// It has the following:
/// *  [_color] to check the color of the app
/// *  [_theme] to check the theme of the app
/// It has setters and getters
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
