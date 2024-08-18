import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/screens/views/customization_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/displayed_fav_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Shows a customization dialog with a tutorial and options for customizing the display of selected places.
///
/// [context] - The BuildContext used to display the dialog.
/// [selectedPlaces] - A list of selected `PlacesModel` items to display in the customization widget.
///
/// The dialog contains:
/// - A `TopBarWidget` for the title and tutorial guide.
/// - A `CustomizationWidget` to handle place customization.
/// - A tutorial coach mark that highlights different UI elements with explanations.

void showCustomizationDialog(
    BuildContext context, final List<PlacesModel> selectedPlaces) async {
  Provider.of<DisplayedListProvider>(context, listen: false)
      .setDisplayedList(List<PlacesModel>.from(selectedPlaces));
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer2<ColorProvider, FontsProvider>(builder:
          (BuildContext context, ColorProvider colorVal, FontsProvider fontVal,
              Widget? child) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            List<TargetFocus> customTargets = [];
            customTargets.add(TargetFocus(
                identify: GlobalKeys.showcaseKeyCustomizationDragDrop,
                keyTarget: GlobalKeys.showcaseKeyCustomizationDragDrop,
                shape: ShapeLightFocus.RRect,
                radius: 10,
                contents: [
                  TargetContent(
                      align: ContentAlign.left,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.tutorialCustomization_title1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                          ],
                        ),
                      ))
                ]));
            customTargets.add(TargetFocus(
                identify: GlobalKeys.showcaseKeyCustomizationMap,
                keyTarget: GlobalKeys.showcaseKeyCustomizationMap,
                shape: ShapeLightFocus.RRect,
                radius: 10,
                contents: [
                  TargetContent(
                      align: ContentAlign.bottom,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.tutorialCustomization_title2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                          ],
                        ),
                      ))
                ]));
            customTargets.add(TargetFocus(
                identify: GlobalKeys.showcaseKeyCustomizationCreate,
                keyTarget: GlobalKeys.showcaseKeyCustomizationCreate,
                shape: ShapeLightFocus.RRect,
                radius: 10,
                contents: [
                  TargetContent(
                      align: ContentAlign.bottom,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.tutorialCustomization_title3,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                            Text(
                                AppLocalizations.of(context)!.tutorialCustomization_desc3,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ))
                          ],
                        ),
                      ))
                ]));
            customTargets.add(TargetFocus(
                identify: GlobalKeys.showcaseKeyCustomizationReset,
                keyTarget: GlobalKeys.showcaseKeyCustomizationReset,
                shape: ShapeLightFocus.RRect,
                radius: 10,
                contents: [
                  TargetContent(
                      align: ContentAlign.bottom,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.tutorialCustomization_title4,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                            Text(
                                AppLocalizations.of(context)!.tutorialCustomization_desc4,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ))
                          ],
                        ),
                      ))
                ]));
            customTargets.add(TargetFocus(
                identify: GlobalKeys.showcaseKeyCustomizationCurrentTour,
                keyTarget: GlobalKeys.showcaseKeyCustomizationCurrentTour,
                shape: ShapeLightFocus.RRect,
                radius: 10,
                contents: [
                  TargetContent(
                      align: ContentAlign.top,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.tutorialCustomization_title5,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                            Text(
                              AppLocalizations.of(context)!.tutorialCustomization_desc5,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ))
                          ],
                        ),
                      ))
                ]));
            customTargets.add(TargetFocus(
                identify: GlobalKeys.showcaseKeyCustomizationAddFav,
                keyTarget: GlobalKeys.showcaseKeyCustomizationAddFav,
                shape: ShapeLightFocus.RRect,
                radius: 10,
                contents: [
                  TargetContent(
                      align: ContentAlign.top,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.tutorialCustomization_title6,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                          ],
                        ),
                      ))
                ]));

//////////////////////////////////////////////////////////////////////////////////////////////
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
              title: Column(
                children: [
                  TopBarWidget(
                    grad1: SettingsSharedPref.getTheme() == 'light'
                        ? colorVal.colors.buttonColors
                        : colorVal.colors.gradient1,
                    grad2: SettingsSharedPref.getTheme() == 'light'
                        ? colorVal.colors.buttonColors
                        : colorVal.colors.gradient2,
                    grad3: SettingsSharedPref.getTheme() == 'light'
                        ? colorVal.colors.buttonColors
                        : colorVal.colors.gradient3,
                    grad4: SettingsSharedPref.getTheme() == 'light'
                        ? colorVal.colors.buttonColors
                        : colorVal.colors.gradient4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Center(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              TutorialCoachMark(
                                targets: customTargets, 
                                colorShadow: Colors.black,
                                alignSkip: Alignment.bottomRight,
                                textSkip: AppLocalizations.of(context)!.defaults_skip,
                                useSafeArea: true,
                                textStyleSkip: TextStyle(
                                    color: Colors.white, fontSize: 30),
                                paddingFocus: 10,
                                opacityShadow: 0.8,
                                onClickTarget: (target) {
                                  print(target);
                                },
                                onClickTargetWithTapPosition:
                                    (target, tapDetails) {
                                  print("target: $target");
                                  print(
                                      "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
                                },
                                onClickOverlay: (target) {
                                  print(target);
                                },
                                onSkip: () {
                                  print("skip");
                                  return true;
                                },
                                onFinish: () {
                                  print("finish");
                                },
                                // );
                              )..show(context: context);
                            },
                            child: Icon(Icons.lightbulb,
                                color: LgAppColors.lgColor3,
                                size: fontVal.fonts.headingSize),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .customapptour_title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        SettingsSharedPref.getTheme() == 'dark'
                                            ? fontVal.fonts.primaryFontColor
                                            : fontVal.fonts.secondaryFontColor,
                                    fontSize: fontVal.fonts.headingSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontType),
                              ),
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(CupertinoIcons.xmark_circle_fill),
                            color: LgAppColors.lgColor2,
                            iconSize: fontVal.fonts.headingSize,
                            onPressed: () async {
                              DisplayedListProvider dlp =
                                  Provider.of<DisplayedListProvider>(context,
                                      listen: false);
                              dlp.setTourPlaces([]);

                              dlp.setDisplayedList(
                                  List<PlacesModel>.from(selectedPlaces));
                              dlp.setTourPlaces([]);
                              GoogleMapProvider gmp =
                                  Provider.of<GoogleMapProvider>(context,
                                      listen: false);
                              gmp.allowSync = true;
                              gmp.clearMarkers();
                              gmp.clearPolylines();
                              gmp.clearCustomMarkers();
                              gmp.clearPolylinesMap();

                              final sshData = Provider.of<SSHprovider>(context,
                                  listen: false);

                              Connectionprovider connection =
                                  Provider.of<Connectionprovider>(context,
                                      listen: false);

                              if (sshData.client != null &&
                                  connection.isLgConnected) {
                                await LgService(sshData).clearKml();
                              }

                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              content: CustomizationWidget(
                chosenPlaces: selectedPlaces,
                firstLat: selectedPlaces[0].latitude,
                firstLong: selectedPlaces[0].longitude,
              ),
            );
          },
        );
      });
    },
  );
}
