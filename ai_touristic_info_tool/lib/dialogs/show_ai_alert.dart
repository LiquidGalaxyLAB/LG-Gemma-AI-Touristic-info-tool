import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Displays an alert dialog with dynamic styling based on current theme settings.
///
/// This function shows an `AlertDialog` with customizable styles for the background color,
/// text size, font, and colors, which are fetched from `ColorProvider` and `FontsProvider`.
/// The dialog content is localized using `AppLocalizations` to ensure it adapts to the user's language.
///
/// The dialog includes:
/// - A title with bold, large text.
/// - Content text that is styled with varying font sizes and weights.
/// - An action button to close the dialog.
///
/// [context] is the BuildContext used to locate the `ColorProvider` and `FontsProvider`.
/// 

Future<void> showAIAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider colorVal,
            FontsProvider fontVal, Widget? child) {
          return AlertDialog(
            backgroundColor: colorVal.colors.innerBackground,
            title: Center(
              child: Text(
                AppLocalizations.of(context)!.aiHallucination_text1,
                style: TextStyle(
                    fontSize: fontVal.fonts.headingSize,
                    color: LgAppColors.lgColor2,
                    fontFamily: fontType,
                    fontWeight: FontWeight.bold),
              ),
            ),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        AppLocalizations.of(context)!.aiHallucination_text2,
                    style: TextStyle(
                        color: fontVal.fonts.primaryFontColor,
                        fontSize: fontVal.fonts.textSize + 4,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontType),
                  ),
                  TextSpan(
                    text:
                        AppLocalizations.of(context)!.aiHallucination_text3,
                    style: TextStyle(
                        fontSize: fontVal.fonts.textSize,
                        color: fontVal.fonts.primaryFontColor,
                        fontFamily: fontType),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.defaults_understand,
                      style: TextStyle(
                          fontSize: fontVal.fonts.textSize,
                          color: LgAppColors.lgColor4))),
            ],
          );
        },
      );
    },
  );
}
