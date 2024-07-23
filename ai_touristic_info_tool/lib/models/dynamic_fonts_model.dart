import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:flutter/material.dart';

class DynamicFontsModel {
  Color primaryFontColor;
  Color secondaryFontColor;
  double titleSize;
  double headingSize;
  double textSize;

  DynamicFontsModel({
    required this.primaryFontColor,
    required this.secondaryFontColor,
    required this.titleSize,
    required this.headingSize,
    required this.textSize,
  });

  factory DynamicFontsModel.fromFonts(double inputSize) {
    Color primFntColor;
    Color secFntColor;
    double tlSize = inputSize;
    double headSize = tlSize - 5;
    double txtSize = tlSize - 20;
    // primFntColor = Colors.black;
    // secFntColor = Colors.white;

    if (SettingsSharedPref.getTheme() == 'dark'
        // ||
        // SettingsSharedPref.getTheme() == 'default'
        ) {
      primFntColor = Colors.white;
      secFntColor = Colors.black;
    } else {
      primFntColor = Colors.black;
      secFntColor = Colors.white;
    }
    return DynamicFontsModel(
      primaryFontColor: primFntColor,
      secondaryFontColor: secFntColor,
      titleSize: tlSize,
      headingSize: headSize,
      textSize: txtSize,
    );
  }

  void updateFontColor() {
    Color primFntColor;
    Color secFntColor;

    if (SettingsSharedPref.getTheme() == 'dark'
        // ||
        //     SettingsSharedPref.getTheme() == 'default'
        ) {
      primFntColor = Colors.white;
      secFntColor = Colors.black;
    } else {
      primFntColor = Colors.black;
      secFntColor = Colors.white;
    }
    primaryFontColor = primFntColor;
    secondaryFontColor = secFntColor;
  }

  void updateFonts(double inputSize) {
    Color primFntColor;
    Color secFntColor;
    double tlSize = inputSize;
    double headSize = tlSize - 5;
    double txtSize = tlSize - 20;

    // primFntColor = Colors.black;
    // secFntColor = Colors.white;

    if (SettingsSharedPref.getTheme() == 'dark'
        // ||
        //     SettingsSharedPref.getTheme() == 'default'
        ) {
      primFntColor = Colors.white;
      secFntColor = Colors.black;
    } else {
      primFntColor = Colors.black;
      secFntColor = Colors.white;
    }
    print('inside update fonts');

    primaryFontColor = primFntColor;
    secondaryFontColor = secFntColor;
    titleSize = tlSize;
    headingSize = headSize;
    textSize = txtSize;
  }
}
