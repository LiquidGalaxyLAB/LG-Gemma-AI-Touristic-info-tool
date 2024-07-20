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
    return DynamicAppColors(
      gradient4: adjustColor(buttonColor, 1.0),
      gradient3: adjustColor(buttonColor, 0.8),
      gradient2: adjustColor(buttonColor, 0.6),
      gradient1: adjustColor(buttonColor, 0.4),
      buttonColors: buttonColor,
      accentColor: Color.fromARGB(120, 252, 171, 21),
      innerBackground: Colors.white,
      shadow: lightenColor(buttonColor, 0.8),
      midShadow: lightenColor(buttonColor, 0.6),
      darkShadow: lightenColor(buttonColor, 0.4),
    );
  }

  void updateColors(Color buttonColor) {
    gradient4 = adjustColor(buttonColor, 1.0);
    gradient3 = adjustColor(buttonColor, 0.8);
    gradient2 = adjustColor(buttonColor, 0.6);
    gradient1 = adjustColor(buttonColor, 0.4);
    buttonColors = buttonColor;
    darkShadow = lightenColor(buttonColor, 0.4); // Light shadow
    midShadow = lightenColor(buttonColor, 0.6); // Medium shadow
    shadow = lightenColor(buttonColor, 0.8); // Dark shadow
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
