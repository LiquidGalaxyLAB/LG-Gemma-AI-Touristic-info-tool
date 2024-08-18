import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:flutter/material.dart';

/// Class that defines the `DynamicFontsModel` entity, which contains its properties and
/// methods.
class DynamicFontsModel {
  /// Property that defines the `primaryFontColor` color.
  Color primaryFontColor;

  /// Property that defines the `secondaryFontColor` color.
  Color secondaryFontColor;

  /// Property that defines the `titleSize` double.
  double titleSize;

  /// Property that defines the `headingSize` double.
  double headingSize;

  /// Property that defines the `textSize` double.
  double textSize;

  DynamicFontsModel({
    required this.primaryFontColor,
    required this.secondaryFontColor,
    required this.titleSize,
    required this.headingSize,
    required this.textSize,
  });

  /// Returns a [DynamicFontsModel] from the given [inputSize].
  factory DynamicFontsModel.fromFonts(double inputSize) {
    Color primFntColor;
    Color secFntColor;
    double tlSize = inputSize;
    double headSize = tlSize - 5;
    double txtSize = tlSize - 20;

    if (SettingsSharedPref.getTheme() == 'dark'
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

  /// Updates the `font color`.
  void updateFontColor() {
    Color primFntColor;
    Color secFntColor;

    if (SettingsSharedPref.getTheme() == 'dark'
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

  /// Updates the `font size`.
  void updateFonts(double inputSize) {
    Color primFntColor;
    Color secFntColor;
    double tlSize = inputSize;
    double headSize = tlSize - 5;
    double txtSize = tlSize - 20;

    if (SettingsSharedPref.getTheme() == 'dark'
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
