import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/process_container_gemini_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/process_container_local_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showStreamingGeminiDialog(
    BuildContext context, String query, String city, String country, String apiKey, Locale locale) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider colorVal,
            FontsProvider fontVal, Widget? child) {
          return AlertDialog(
              // backgroundColor: FontAppColors.secondaryFont,
              backgroundColor: colorVal.colors.innerBackground,
              shadowColor: FontAppColors.secondaryFont,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              // insetPadding: EdgeInsets.zero,
              iconPadding: EdgeInsets.zero,
              titlePadding: const EdgeInsets.only(bottom: 20),
              contentPadding: EdgeInsets.zero,
              actionsPadding: const EdgeInsets.only(bottom: 10),
              surfaceTintColor: FontAppColors.secondaryFont,
              title: Consumer<ModelErrorProvider>(builder:
                  (BuildContext context, ModelErrorProvider value,
                      Widget? child) {
                return Center(
                  child: Text(!value.isError ?
                  //  'AI Generation' : 'Error !',
                  AppLocalizations.of(context)!.aiGeneration_generationScreenTitle : AppLocalizations.of(context)!.defaults_error,
                      style: TextStyle(
                        color: !value.isError
                            // ? FontAppColors.primaryFont
                            ? fontVal.fonts.primaryFontColor
                            : LgAppColors.lgColor2,
                        // fontSize: headingSize,
                        fontSize: fontVal.fonts.headingSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontType,
                      )),
                );
              }),
              content: ProcessContainerGemini(
                locale: locale,
                query: query,
                city: city,
                country: country,
                apiKey: apiKey,
              ));
        },
      );
    },
  );
}
