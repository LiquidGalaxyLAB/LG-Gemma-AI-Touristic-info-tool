import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/customization_widget.dart';
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
                              // "Drag the places you want to visit from here",
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
                              // "Drop them here",
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
                              // "Create your Custom tour",
                              AppLocalizations.of(context)!.tutorialCustomization_title3,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                            Text(
                                // 'A button will appear after you create your tour to visualize it!',
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
                              // "Reset your tour",
                              AppLocalizations.of(context)!.tutorialCustomization_title4,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                            Text(
                                // 'This will clear all the places you have added to your tour',
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
                              // "You can track your current tour here",
                              AppLocalizations.of(context)!.tutorialCustomization_title5,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30.0),
                            ),
                            Text(
                              // 'Slide right or left to view all the tour',
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
                              // "Save your customized tour",
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
                                targets: customTargets, // List<TargetFocus>
                                colorShadow: Colors.black,
                                alignSkip: Alignment.bottomRight,
                                // textSkip: "SKIP",
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
                                // 'Customize your own tour!',
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
