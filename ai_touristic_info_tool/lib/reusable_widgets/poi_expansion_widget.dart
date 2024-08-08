import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/api.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/langchain_service.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PoiExpansionWidget extends StatefulWidget {
  const PoiExpansionWidget(
      {super.key,
      required this.placeModel,
      required this.index,
      required this.query});

  final PlacesModel placeModel;
  final int index;
  final String query;

  @override
  State<PoiExpansionWidget> createState() => _PoiExpansionWidgetState();
}

class _PoiExpansionWidgetState extends State<PoiExpansionWidget> {
  // double _currentProgress = 0.0;
  // final double _totalDuration = 1.2 * 10; // Example total duration

  bool play = true;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _checkIsFav();
  }

  Future<void> _checkIsFav() async {
    bool doesExist = await FavoritesSharedPref()
        .isPlaceExist(widget.placeModel.name, widget.placeModel.country ?? '');
    if (doesExist) {
      setState(() {
        _isFav = true;
      });
    } else {
      setState(() {
        _isFav = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FontsProvider>(
      builder: (BuildContext context, FontsProvider fontVal, Widget? child) {
        return ExpansionTile(
          title: Text(
            textAlign: TextAlign.justify,
            '${widget.index + 1}. ${widget.placeModel.name}',
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                // color: FontAppColors.primaryFont,
                color: fontVal.fonts.primaryFontColor,
                // fontSize: textSize,
                fontSize: fontVal.fonts.textSize,
                fontFamily: fontType,
                fontWeight: FontWeight.bold),
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: FontAppColors.secondaryFont,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Consumer<ColorProvider>(
                builder:
                    (BuildContext context, ColorProvider value, Widget? child) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: FontAppColors.primaryFont, width: 3),
                      // color: PrimaryAppColors.gradient4,
                      color: value.colors.gradient4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.6),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  textAlign: TextAlign.justify,
                                  widget.placeModel.name,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      // fontSize: textSize,
                                      fontSize: fontVal.fonts.textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        LatLng newLocation = LatLng(
                                            widget.placeModel.latitude,
                                            widget.placeModel.longitude);
                                        final mapProvider =
                                            Provider.of<GoogleMapProvider>(
                                                context,
                                                listen: false);
                                        mapProvider.setBitmapDescriptor(
                                            "assets/images/placemark_pin.png");
                                        mapProvider.addMarker(
                                            context, widget.placeModel,
                                            removeAll: true);
                                        mapProvider.updateZoom(18.4746);
                                        mapProvider.updateBearing(90);
                                        mapProvider.updateTilt(45);
                                        mapProvider.flyToLocation(newLocation);

                                        mapProvider.currentlySelectedPin =
                                            widget.placeModel;
                                        mapProvider.pinPillPosition = 10;

                                        await Future.delayed(
                                            const Duration(seconds: 3));

                                        final sshData =
                                            Provider.of<SSHprovider>(context,
                                                listen: false);

                                        Connectionprovider connection =
                                            Provider.of<Connectionprovider>(
                                                context,
                                                listen: false);

                                        ///checking the connection status first
                                        if (sshData.client != null &&
                                            connection.isLgConnected) {
                                          await buildPlacePlacemark(
                                              widget.placeModel,
                                              widget.index + 1,
                                              widget.query,
                                              context);
                                        }
                                      },
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          decoration: BoxDecoration(
                                            // color: PrimaryAppColors.gradient1,
                                            color: value.colors.gradient1,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                  Icons
                                                      .airplanemode_active_outlined,
                                                  color: SettingsSharedPref
                                                              .getTheme() ==
                                                          'light'
                                                      ? Colors.black
                                                      : FontAppColors
                                                          .secondaryFont,
                                                  size: textSize + 10),
                                              Flexible(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Fly to',
                                                    style: TextStyle(
                                                        // color: FontAppColors
                                                        //     .secondaryFont,
                                                        // fontSize: textSize - 4,
                                                        fontSize: fontVal.fonts
                                                                .textSize -
                                                            4,
                                                        color: SettingsSharedPref
                                                                    .getTheme() ==
                                                                'default'
                                                            ? fontVal.fonts
                                                                .secondaryFontColor
                                                            : fontVal.fonts
                                                                .primaryFontColor,
                                                        fontFamily: fontType,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final srch =
                                            Provider.of<SearchProvider>(context,
                                                listen: false);
                                        Connectionprovider connection =
                                            Provider.of<Connectionprovider>(
                                                context,
                                                listen: false);
                                        //Local:
                                        // if (!connection.isAiConnected) {
                                        //   dialogBuilder(
                                        //       context,
                                        //       'NOT connected to AI Server!!\nPlease Connect!',
                                        //       true,
                                        //       'OK',
                                        //       null,
                                        //       null);
                                        // } else {
                                        srch.isLoading = true;
                                        srch.showMap = false;
                                        srch.searchPoiSelected =
                                            widget.placeModel.name;
                                        List<String> _futureYoutubeUrls =
                                            await Api().fetchYoutubeUrls(
                                                query: widget.placeModel.name);

                                        //Local:
                                        // List<String> _futureUrls = await Api()
                                        //     .fetchWebUrls(
                                        //         widget.placeModel.name);

                                        //Gemini:
                                        Map<String, dynamic> _geminiWebResults =
                                            await LangchainService()
                                                .generatewebLinks(
                                                    widget.placeModel.name);
                                        List<dynamic> _futureUrlsDynamic =
                                            _geminiWebResults['links'];
                                        List<String> _futureUrls = [];
                                        for (var link in _futureUrlsDynamic) {
                                          _futureUrls.add(link.toString());
                                        }
                                        /////////////////////////////////////////

                                        final sshData =
                                            Provider.of<SSHprovider>(context,
                                                listen: false);

                                        ///checking the connection status first
                                        if (sshData.client != null &&
                                            connection.isLgConnected) {
                                          List<String> links =
                                              _futureUrls + _futureYoutubeUrls;
                                          await buildAllLinksBalloon(
                                              widget.placeModel.name,
                                              widget.placeModel.city,
                                              widget.placeModel.country,
                                              widget.placeModel.latitude,
                                              widget.placeModel.longitude,
                                              links,
                                              context);
                                        }

                                        srch.webSearchResults = _futureUrls;
                                        srch.youtubeSearchResults =
                                            _futureYoutubeUrls;
                                        srch.isLoading = false;
                                        srch.poiLat =
                                            widget.placeModel.latitude;
                                        srch.poiLong =
                                            widget.placeModel.longitude;
                                        srch.searchPoiCountry =
                                            widget.placeModel.country ??
                                                'Worldwide';
                                        srch.searchPoiCity =
                                            widget.placeModel.city ?? '';
                                        //Local: }
                                      },
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          decoration: BoxDecoration(
                                            // color: PrimaryAppColors.gradient1,
                                            color: value.colors.gradient1,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(Icons.info,
                                                  color: SettingsSharedPref
                                                              .getTheme() ==
                                                          'light'
                                                      ? Colors.black
                                                      : FontAppColors
                                                          .secondaryFont,
                                                  size: textSize + 10),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      decoration: BoxDecoration(
                                        color: FontAppColors.secondaryFont,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                  onTap: () async {
                                                    final sshData = Provider.of<
                                                            SSHprovider>(
                                                        context,
                                                        listen: false);

                                                    Connectionprovider
                                                        connection = Provider
                                                            .of<Connectionprovider>(
                                                                context,
                                                                listen: false);

                                                    ///checking the connection status first
                                                    if (sshData.client !=
                                                            null &&
                                                        connection
                                                            .isLgConnected) {
                                                      if (play) {
                                                        await LgService(sshData)
                                                            .startTour('Orbit');
                                                      } else {
                                                        await LgService(sshData)
                                                            .stopTour();
                                                      }
                                                      setState(() {
                                                        play = !play;
                                                      });
                                                    } else {
                                                      dialogBuilder(
                                                          context,
                                                          'NOT connected to LG !! \n Please Connect to LG',
                                                          true,
                                                          'OK',
                                                          null,
                                                          null);
                                                    }
                                                  },
                                                  child: play
                                                      ? const Icon(
                                                          Icons
                                                              .play_circle_outlined,
                                                          //stop_circle_outlined
                                                          color: FontAppColors
                                                              .primaryFont,
                                                          size: textSize + 10)
                                                      : const Icon(
                                                          Icons
                                                              .stop_circle_outlined,
                                                          color: FontAppColors
                                                              .primaryFont,
                                                          size: textSize + 10)),
                                            ],
                                          ),
                                          Flexible(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Orbit',
                                                style: TextStyle(
                                                  color:
                                                      FontAppColors.primaryFont,

                                                  // fontSize: textSize - 2,
                                                  fontSize:
                                                      fontVal.fonts.textSize -
                                                          2,
                                                  fontFamily: fontType,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Tooltip(
                                      message: _isFav
                                          ? 'Added to favorites'
                                          : 'Removed from favorites',
                                      triggerMode: TooltipTriggerMode.tap,
                                      onTriggered: () async {
                                        if (await FavoritesSharedPref()
                                            .isPlaceExist(
                                                widget.placeModel.name,
                                                widget.placeModel.country ??
                                                    '')) {
                                          await FavoritesSharedPref()
                                              .removePlace(
                                                  widget.placeModel.name,
                                                  widget.placeModel.country ??
                                                      '');
                                          setState(() {
                                            _isFav = false;
                                          });
                                        } else {
                                          await FavoritesSharedPref()
                                              .addPlace(widget.placeModel);
                                          setState(() {
                                            _isFav = true;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        _isFav
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart,
                                        color: LgAppColors.lgColor2,
                                        size: fontVal.fonts.textSize + 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}



                    // Divider(
                    //   color: FontAppColors.primaryFont,
                    //   thickness: 0.5,
                    // ),

                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.02,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () async {
                    //         final sshData = Provider.of<SSHprovider>(context,
                    //             listen: false);

                    //         Connectionprovider connection =
                    //             Provider.of<Connectionprovider>(context,
                    //                 listen: false);

                    //         ///checking the connection status first
                    //         if (sshData.client != null &&
                    //             connection.isLgConnected) {
                    //           await LgService(sshData).startTour('Orbit');
                    //         } else {
                    //           dialogBuilder(
                    //               context,
                    //               'NOT connected to LG !! \n Please Connect to LG',
                    //               true,
                    //               'OK',
                    //               null,
                    //               null);
                    //         }
                    //       },
                    //       child: const Icon(Icons.loop_outlined,
                    //           color: FontAppColors.primaryFont,
                    //           size: textSize + 20),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () async {
                    //         final sshData = Provider.of<SSHprovider>(context,
                    //             listen: false);

                    //         Connectionprovider connection =
                    //             Provider.of<Connectionprovider>(context,
                    //                 listen: false);

                    //         ///checking the connection status first
                    //         if (sshData.client != null &&
                    //             connection.isLgConnected) {
                    //           await LgService(sshData).stopTour();
                    //           // }
                    //         } else {
                    //           dialogBuilder(
                    //               context,
                    //               'NOT connected to LG !! \n Please Connect to LG',
                    //               true,
                    //               'OK',
                    //               null,
                    //               null);
                    //         }
                    //       },
                    //       child: const Icon(Icons.stop_outlined,
                    //           color: FontAppColors.primaryFont,
                    //           size: textSize + 20),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.02,
                    // ),