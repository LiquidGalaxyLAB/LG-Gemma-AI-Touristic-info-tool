import 'dart:math';

import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:flutter/material.dart';

/// Class that defines the `App colors` entity, which contains its properties and
/// methods.
class DynamicAppColors {
  /// Property that defines the `gradient1` color.
  Color gradient1;

  /// Property that defines the `gradient2` color.
  Color gradient2;

  /// Property that defines the `gradient3` color.
  Color gradient3;

  /// Property that defines the `gradient4` color.
  Color gradient4;

  /// Property that defines the `buttonColors` color.
  Color buttonColors;

  /// Property that defines the `accentColor` color.
  Color accentColor;

  /// Property that defines the `innerBackground` color.
  Color innerBackground;

  /// Property that defines the `shadow` color.
  Color shadow;

  /// Property that defines the `midShadow` color.
  Color midShadow;

  /// Property that defines the `darkShadow` color.
  Color darkShadow;

  DynamicAppColors({
    required this.gradient1,
    required this.gradient2,
    required this.gradient3,
    required this.gradient4,
    required this.buttonColors,
    required this.accentColor,
    required this.innerBackground,
    required this.shadow,
    required this.midShadow,
    required this.darkShadow,
  });

  /// Returns a [DynamicAppColors] from the given [buttonColor].
  factory DynamicAppColors.fromButtonColor(Color buttonColor) {
    Color grad1;
    Color grad2;
    Color grad3;
    Color grad4;
    Color innerBg;
    Color buttons;
    Color shd;
    Color medShd;
    Color darkShd;
    if (SettingsSharedPref.getTheme() == 'dark') {
      grad1 = Color.fromARGB(255, 34, 34, 34); 
      grad2 = Color.fromARGB(255, 34, 34, 34);
      grad3 = Color.fromARGB(255, 68, 68, 68); 
      grad4 = Color.fromARGB(255, 102, 102, 102);
      innerBg = Color.fromARGB(255, 26, 26, 26);
      buttons = Color.fromARGB(255, 85, 85, 85);
    } else if (SettingsSharedPref.getTheme() == 'light') {
      grad1 = Color(0xFFF9F9F8);
      grad2 = Color(0xFFF2F3F2);
      grad3 = Color(0xFFECECEB);
      grad4 = Color(0xFFE5E6E4);


      innerBg = Colors.white;
      if (isNearWhite(buttonColor)) {
        buttons = Color.fromARGB(255, 210, 208, 208);
      } else {
        buttons = buttonColor;
      }
      // buttons = buttonColor;
    } else {
      grad1 = adjustColor(buttonColor, 0.4);
      grad2 = adjustColor(buttonColor, 0.6);
      grad3 = adjustColor(buttonColor, 0.8);
      grad4 = adjustColor(buttonColor, 1.0);
      innerBg = Colors.white;
      buttons = buttonColor;
    }

    if (SettingsSharedPref.getTheme() == 'light') {
      darkShd = Colors.white;
      medShd = Colors.white;
      shd = Colors.white;
    } else {
      darkShd = lightenColor(buttons, 0.4); 
      medShd = lightenColor(buttons, 0.6); 
      shd = lightenColor(buttons, 0.8); 
    }
    return DynamicAppColors(
      gradient4: grad4,
      gradient3: grad3,
      gradient2: grad2,
      gradient1: grad1,
      buttonColors: buttons,
      accentColor: Color.fromARGB(120, 252, 171, 21),
      innerBackground: innerBg,
      shadow: shd,
      midShadow: medShd,
      darkShadow: darkShd,
    );
  }

  /// Updates the colors based on the given [buttonColor].
  void updateColors(Color buttonColor) {
    Color grad1;
    Color grad2;
    Color grad3;
    Color grad4;
    Color innerBg;
    Color buttons;
    if (SettingsSharedPref.getTheme() == 'dark') {
      grad1 = Color.fromARGB(255, 34, 34, 34); 
      grad2 = Color.fromARGB(255, 34, 34, 34); 
      grad3 = Color.fromARGB(255, 68, 68, 68); 
      grad4 = Color.fromARGB(255, 102, 102, 102); 
      innerBg = Color.fromARGB(255, 26, 26, 26);
      buttons = Color.fromARGB(255, 85, 85, 85);
    } else if (SettingsSharedPref.getTheme() == 'light') {
      grad1 = Color(0xFFF9F9F8);
      grad2 = Color(0xFFF2F3F2);
      grad3 = Color(0xFFECECEB);
      grad4 = Color(0xFFE5E6E4);

      innerBg = Colors.white;
      if (isNearWhite(buttonColor)) {
        buttons = Color.fromARGB(255, 210, 208, 208);
      } else {
        buttons = buttonColor;
      }
      // buttons = buttonColor;
    } else {
      grad1 = adjustColor(buttonColor, 0.4);
      grad2 = adjustColor(buttonColor, 0.6);
      grad3 = adjustColor(buttonColor, 0.8);
      grad4 = adjustColor(buttonColor, 1.0);
      innerBg = Colors.white;
      buttons = buttonColor;
    }

    gradient4 = grad4;
    gradient3 = grad3;
    gradient2 = grad2;
    gradient1 = grad1;
    innerBackground = innerBg;
    buttonColors = buttons;

    if (SettingsSharedPref.getTheme() == 'light') {
      darkShadow = Colors.white;
      midShadow = Colors.white;
      shadow = Colors.white;
    } else {
      darkShadow = lightenColor(buttons, 0.4); // Light shadow
      midShadow = lightenColor(buttons, 0.6); // Medium shadow
      shadow = lightenColor(buttons, 0.8); // Dark shadow
    }
  }
}

/// Lightens the color by multiplying RGB values by the factor
/// The factor should be between 0 and 1
Color lightenColor(Color color, double factor) {
  return Color.fromARGB(
    color.alpha,
    (color.red + (255 - color.red) * factor).clamp(0, 255).toInt(),
    (color.green + (255 - color.green) * factor).clamp(0, 255).toInt(),
    (color.blue + (255 - color.blue) * factor).clamp(0, 255).toInt(),
  );
}

/// Adjusts the color by multiplying RGB values by the factor
Color adjustColor(Color color, double factor) {
  return Color.fromRGBO(
    (color.red * factor).clamp(0, 255).toInt(),
    (color.green * factor).clamp(0, 255).toInt(),
    (color.blue * factor).clamp(0, 255).toInt(),
    color.opacity,
  );
}

/// Checks if the color is near white
bool isNearWhite(Color color, {double threshold = 100.0}) {
  // Calculate the Euclidean distance from white
  double distance = sqrt(
    pow(color.red - 255, 2) +
        pow(color.green - 255, 2) +
        pow(color.blue - 255, 2),
  );
  return distance < threshold;
}
