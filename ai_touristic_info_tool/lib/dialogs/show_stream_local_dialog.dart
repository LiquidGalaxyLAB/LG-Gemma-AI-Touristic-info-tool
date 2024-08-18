import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/screens/views/process_container_local_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Shows a dialog with a streaming process for generating AI data.
///
/// This function displays an `AlertDialog` that shows the progress of
/// streaming data based on the provided query, city, and country. The dialog
/// appearance is customized based on the current color and font providers.
/// It also handles displaying error messages if needed.
///
/// [context] - The BuildContext used to show the dialog.
/// [query] - The search query for the data generation process.
/// [city] - The city parameter for the data generation process.
/// [country] - The country parameter for the data generation process.
///
/// The dialog displays a title that varies based on whether an error is present
/// and includes a `ProcessContainerWidget` that shows the current status of
/// the streaming process.

void showStreamingDialog(
    BuildContext context, String query, String city, String country) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider colorVal,
            FontsProvider fontVal, Widget? child) {
          return AlertDialog(
              backgroundColor: colorVal.colors.innerBackground,
              shadowColor: FontAppColors.secondaryFont,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
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
                  AppLocalizations.of(context)!.aiGeneration_generationScreenTitle : AppLocalizations.of(context)!.defaults_error,
                      style: TextStyle(
                        color: !value.isError
                            ? fontVal.fonts.primaryFontColor
                            : LgAppColors.lgColor2,
                        fontSize: fontVal.fonts.headingSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontType,
                      )),
                );
              }),
              content: ProcessContainerWidget(
                query: query,
                city: city,
                country: country,
              ));
        },
      );
    },
  );
}