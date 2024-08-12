import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
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
                      Expanded(
                        child: Center(
                          child: Text(
                            // 'Customize your own tour!',
                            AppLocalizations.of(context)!.customapptour_title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: SettingsSharedPref.getTheme() == 'dark'
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

                          final sshData =
                              Provider.of<SSHprovider>(context, listen: false);

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
      });
    },
  );
}
