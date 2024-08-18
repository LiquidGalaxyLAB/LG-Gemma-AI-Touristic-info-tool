import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBalloonGoogleMaps extends StatelessWidget {
  final double pinPillPosition;
  final PlacesModel poi;
  final String query;
  const CustomBalloonGoogleMaps({
    super.key,
    required this.pinPillPosition,
    required this.poi,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    String countryCode = countryMap[poi.country] ?? 'None';
    String countryFlagImg;

    if (countryCode != 'None') {
      String cc = countryCode.toLowerCase();
      countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";
    } else {
      countryFlagImg = '';
    }
    return AnimatedPositioned(
      top: pinPillPosition,
      right: MediaQuery.of(context).size.width * 0.4,
      left: 0,
      duration: const Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Consumer2<ColorProvider, FontsProvider>(
          builder: (BuildContext context, ColorProvider value,
              FontsProvider fontsval, Widget? child) {
            return Container(
              margin: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      value.colors.gradient1,
                      value.colors.gradient2,
                      value.colors.gradient3,
                      value.colors.gradient4,
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset.zero,
                        color: Colors.grey.withOpacity(0.5))
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Center(
                      child: Text(
                        '${poi.id}. ${poi.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SettingsSharedPref.getTheme() == 'default'
                              ? fontsval.fonts.secondaryFontColor
                              : fontsval.fonts.primaryFontColor,
                          fontSize: fontsval.fonts.textSize + 5,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontType,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Center(
                      child: Text(
                        '${poi.city}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SettingsSharedPref.getTheme() == 'default'
                              ? fontsval.fonts.secondaryFontColor
                              : fontsval.fonts.primaryFontColor,
                          fontSize: fontsval.fonts.textSize + 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontType,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Center(
                      child: Text(
                        '${poi.country}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SettingsSharedPref.getTheme() == 'default'
                              ? fontsval.fonts.secondaryFontColor
                              : fontsval.fonts.primaryFontColor,
                          fontSize: fontsval.fonts.textSize + 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontType,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    if (countryFlagImg != '')
                      Center(
                        child: Image.network(
                          countryFlagImg,
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        '${poi.description}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: SettingsSharedPref.getTheme() == 'default'
                              ? fontsval.fonts.secondaryFontColor
                              : fontsval.fonts.primaryFontColor,
                          fontSize: fontsval.fonts.textSize,
                          fontFamily: fontType,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //divider:
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Divider(
                        color: SettingsSharedPref.getTheme() == 'default'
                            ? fontsval.fonts.secondaryFontColor
                            : fontsval.fonts.primaryFontColor,
                        thickness: 2,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Address: ',
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: poi.address,
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Avg. Ratings: ',
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${poi.ratings}',
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Pricing: ',
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${poi.price ?? ''} ',
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Amenities: ',
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${poi.amenities ?? ''}',
                              style: TextStyle(
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? fontsval.fonts.secondaryFontColor
                                        : fontsval.fonts.primaryFontColor,
                                fontSize: fontsval.fonts.textSize,
                                fontFamily: fontType,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
