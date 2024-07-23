import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:flutter/material.dart';

class DynamicAppColors {
  Color gradient1;
  Color gradient2;
  Color gradient3;
  Color gradient4;
  Color buttonColors;
  Color accentColor;
  Color innerBackground;
  Color shadow;
  Color midShadow;
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
      grad1 = Color.fromARGB(255, 34, 34, 34); // Pure Black
      grad2 = Color.fromARGB(255, 34, 34, 34); // Dark Grey
      grad3 = Color.fromARGB(255, 68, 68, 68); // Medium Grey
      grad4 = Color.fromARGB(255, 102, 102, 102); // Light Grey
      innerBg = Color.fromARGB(255, 26, 26, 26);
      buttons = Color.fromARGB(255, 85, 85, 85);
    } else if (SettingsSharedPref.getTheme() == 'light') {
      grad1 = Color(0xFFF9F9F8);
      grad2 = Color(0xFFF2F3F2);
      grad3 = Color(0xFFECECEB);
      grad4 = Color(0xFFE5E6E4);

      // grad4 = Color.fromARGB(255, 230, 230, 230); // Pure White
      // grad3 = Color.fromARGB(255, 204, 204, 204); // Very Light Grey
      // grad2 = Color.fromARGB(255, 204, 204, 204); // Light Grey
      // grad1 = Color.fromARGB(255, 179, 179, 179); // Lighter Grey

      innerBg = Colors.white;
      buttons = buttonColor;
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
      darkShd = lightenColor(buttons, 0.4); // Light shadow
      medShd = lightenColor(buttons, 0.6); // Medium shadow
      shd = lightenColor(buttons, 0.8); // Dark shadow
    }
    return DynamicAppColors(
      gradient4: grad4,
      gradient3: grad3,
      gradient2: grad2,
      gradient1: grad1,
      buttonColors: buttons,
      accentColor: Color.fromARGB(120, 252, 171, 21),
      innerBackground: innerBg,
      // shadow: lightenColor(buttons, 0.8),
      // midShadow: lightenColor(buttons, 0.6),
      // darkShadow: lightenColor(buttons, 0.4),
      shadow: shd,
      midShadow: medShd,
      darkShadow: darkShd,
    );
  }

  void updateColors(Color buttonColor) {
    Color grad1;
    Color grad2;
    Color grad3;
    Color grad4;
    Color innerBg;
    Color buttons;
    if (SettingsSharedPref.getTheme() == 'dark') {
      grad1 = Color.fromARGB(255, 34, 34, 34); // Pure Black
      grad2 = Color.fromARGB(255, 34, 34, 34); // Dark Grey
      grad3 = Color.fromARGB(255, 68, 68, 68); // Medium Grey
      grad4 = Color.fromARGB(255, 102, 102, 102); // Light Grey
      innerBg = Color.fromARGB(255, 26, 26, 26);
      buttons = Color.fromARGB(255, 85, 85, 85);
    } else if (SettingsSharedPref.getTheme() == 'light') {
      grad1 = Color(0xFFF9F9F8);
      grad2 = Color(0xFFF2F3F2);
      grad3 = Color(0xFFECECEB);
      grad4 = Color(0xFFE5E6E4);

      // grad4 = Color.fromARGB(255, 230, 230, 230); // Pure White
      // grad3 = Color.fromARGB(255, 204, 204, 204); // Very Light Grey
      // grad2 = Color.fromARGB(255, 204, 204, 204); // Light Grey
      // grad1 = Color.fromARGB(255, 179, 179, 179); // Lighter Grey

      innerBg = Colors.white;
      buttons = buttonColor;
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

// Calculates a brighter shadow color based on the button color and the reference shadow color
// Lightens the color by a given factor
Color lightenColor(Color color, double factor) {
  return Color.fromARGB(
    color.alpha,
    (color.red + (255 - color.red) * factor).clamp(0, 255).toInt(),
    (color.green + (255 - color.green) * factor).clamp(0, 255).toInt(),
    (color.blue + (255 - color.blue) * factor).clamp(0, 255).toInt(),
  );
}

// Adjusts the color brightness by multiplying RGB values by the factor
Color adjustColor(Color color, double factor) {
  return Color.fromRGBO(
    (color.red * factor).clamp(0, 255).toInt(),
    (color.green * factor).clamp(0, 255).toInt(),
    (color.blue * factor).clamp(0, 255).toInt(),
    color.opacity,
  );
}
