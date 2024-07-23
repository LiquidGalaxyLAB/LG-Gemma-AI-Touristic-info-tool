import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/dynamic_fonts_model.dart';
import 'package:flutter/material.dart';

class FontsProvider with ChangeNotifier {
  DynamicFontsModel _fonts =
      DynamicFontsModel.fromFonts(SettingsSharedPref.getTitleFont() ?? 40);

  DynamicFontsModel get fonts => _fonts;

  void updateFont(double chosenSize) {
    _fonts.updateFonts(chosenSize);
    notifyListeners();
  }

  void updateFontColor() {
    _fonts.updateFontColor();
    notifyListeners();
  }
}
