import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showAIAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider colorVal,
            FontsProvider fontVal, Widget? child) {
          return AlertDialog(
            // backgroundColor: FontAppColors.secondaryFont,
            backgroundColor: colorVal.colors.innerBackground,
            title: Center(
              child: Text(
                // 'Be aware of AI hallucinations !',
                AppLocalizations.of(context)!.aiHallucination_text1,
                style: TextStyle(
                    // fontSize: headingSize,
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
                        // 'The state of the art of most AI tools as 2024 can give you sometimes incorrect answers, or even the so called Hallucinations:\n\n',
                        AppLocalizations.of(context)!.aiHallucination_text2,
                    style: TextStyle(
                        // color: Colors.black,
                        color: fontVal.fonts.primaryFontColor,
                        // fontSize: textSize + 4,
                        fontSize: fontVal.fonts.textSize + 4,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontType),
                  ),
                  TextSpan(
                    text:
                        // 'AI hallucinations are incorrect or misleading results that AI models generate. These errors can be caused by a variety of factors, including insufficient training data, incorrect assumptions made by the model, or biases in the data used to train the model.\n\nThe Liquid Galaxy project has no control over this, and the contents responsibility is of the owners of the respective Large Language models used',
                        AppLocalizations.of(context)!.aiHallucination_text3,
                    style: TextStyle(
                        // color: Colors.black,
                        // fontSize: textSize,
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
                    // 'I understand',
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
