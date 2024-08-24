import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/gemma_api_services.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/services/search_services.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/dialog_builder.dart';
import 'package:ai_touristic_info_tool/state_management/tour_status_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      if (mounted) {
        setState(() {
          _isFav = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isFav = false;
        });
      }
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
                color: fontVal.fonts.primaryFontColor,
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
                                      fontSize: fontVal.fonts.textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Consumer<TourStatusprovider>(
                                builder: (BuildContext context,
                                    TourStatusprovider tourStatus,
                                    Widget? child) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (tourStatus.isTourOn) {
                                              dialogBuilder(
                                                  context,
                                                  // 'A tour is currently running.\nStop tour first.',
                                                  AppLocalizations.of(context)!
                                                      .poiExpansion_runningTourError,
                                                  true,
                                                  AppLocalizations.of(context)!
                                                      .defaults_ok,
                                                  () {},
                                                  () {});
                                            } else {
                                              LatLng newLocation = LatLng(
                                                  widget.placeModel.latitude,
                                                  widget.placeModel.longitude);
                                              final mapProvider = Provider.of<
                                                      GoogleMapProvider>(
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
                                              mapProvider
                                                  .flyToLocation(newLocation);

                                              mapProvider.currentlySelectedPin =
                                                  widget.placeModel;
                                              mapProvider.pinPillPosition = 10;

                                              await Future.delayed(
                                                  const Duration(seconds: 3));

                                              final sshData =
                                                  Provider.of<SSHprovider>(
                                                      context,
                                                      listen: false);

                                              Connectionprovider connection =
                                                  Provider.of<
                                                          Connectionprovider>(
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
                                                  0.12,
                                              decoration: BoxDecoration(
                                                color: value.colors.gradient1,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        // 'Fly to',
                                                        AppLocalizations.of(
                                                                context)!
                                                            .poiExpansion_flyTo,
                                                        style: TextStyle(
                                                            fontSize: fontVal
                                                                    .fonts
                                                                    .textSize -
                                                                4,
                                                            color: SettingsSharedPref
                                                                        .getTheme() ==
                                                                    'default'
                                                                ? fontVal.fonts
                                                                    .secondaryFontColor
                                                                : fontVal.fonts
                                                                    .primaryFontColor,
                                                            fontFamily:
                                                                fontType,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                      Consumer<TourStatusprovider>(builder:
                                          (BuildContext context,
                                              TourStatusprovider tourStatus,
                                              Widget? child) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (tourStatus.isTourOn) {
                                                dialogBuilder(
                                                    context,
                                                    // 'A tour is currently running.\nStop tour first.',
                                                    AppLocalizations.of(
                                                            context)!
                                                        .poiExpansion_runningTourError,
                                                    true,
                                                    AppLocalizations.of(
                                                            context)!
                                                        .defaults_ok,
                                                    () {},
                                                    () {});
                                              } else {
                                                final srch =
                                                    Provider.of<SearchProvider>(
                                                        context,
                                                        listen: false);

                                                //Local:
                                                Connectionprovider connection =
                                                    Provider.of<
                                                            Connectionprovider>(
                                                        context,
                                                        listen: false);
                                                if (!connection.isAiConnected) {
                                                  dialogBuilder(
                                                      context,
                                                      'NOT connected to AI Server!!\nPlease Connect!',
                                                      true,
                                                      'OK',
                                                      null,
                                                      null);
                                                } else {
                                                  srch.isLoading = true;
                                                  srch.showMap = false;
                                                  srch.searchPoiSelected =
                                                      widget.placeModel.name;

                                                  ApiKeyModel? apiKeyModel =
                                                      await APIKeySharedPref
                                                          .getDefaultApiKey(
                                                              'Youtube');

                                                  String apiKey;
                                                  List<String>
                                                      _futureYoutubeUrls;
                                                  if (apiKeyModel == null) {
                                                    dialogBuilder(
                                                        context,
                                                        // 'No API key found for Youtube API.\nPlease add an API key in the settings.',
                                                        AppLocalizations.of(
                                                                context)!
                                                            .poiExpansion_noAPIKeyYoutube,
                                                        true,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .defaults_ok,
                                                        () {},
                                                        () {});
                                                    _futureYoutubeUrls = [];
                                                  } else {
                                                    apiKey = apiKeyModel.key;
                                                    _futureYoutubeUrls =
                                                        await SearchServices()
                                                            .fetchYoutubeUrls(
                                                                query: widget
                                                                    .placeModel
                                                                    .name,
                                                                context,
                                                                apiKey);
                                                  }

                                                  //Local:
                                                  List<String> _futureUrls =
                                                      await GemmaApiServices().fetchWebUrlsWithGemma(
                                                          widget
                                                              .placeModel.name, context);

                                                  //Gemini:

                                                  // List<String> _futureUrls =
                                                  //     await SearchServices()
                                                  //         .fetchUrls(
                                                  //             widget.placeModel
                                                  //                 .name,
                                                  //             numResults: 10);
                                                  /////////////////////////////////////////

                                                  // final sshData =
                                                  //     Provider.of<SSHprovider>(context,
                                                  //         listen: false);

                                                  ///checking the connection status first
                                                  // if (sshData.client != null &&
                                                  //     connection.isLgConnected) {
                                                  //   List<String> links =
                                                  //       _futureUrls + _futureYoutubeUrls;
                                                  // await buildAllLinksBalloon(
                                                  //     widget.placeModel.name,
                                                  //     widget.placeModel.city,
                                                  //     widget.placeModel.country,
                                                  //     widget.placeModel.latitude,
                                                  //     widget.placeModel.longitude,
                                                  //     links,
                                                  //     context);
                                                  // }

                                                  srch.webSearchResults =
                                                      _futureUrls;
                                                  srch.youtubeSearchResults =
                                                      _futureYoutubeUrls;
                                                  srch.isLoading = false;
                                                  srch.poiLat = widget
                                                      .placeModel.latitude;
                                                  srch.poiLong = widget
                                                      .placeModel.longitude;
                                                  srch.searchPoiCountry = widget
                                                          .placeModel.country ??
                                                      'Worldwide';
                                                  srch.searchPoiCity =
                                                      widget.placeModel.city ??
                                                          '';
                                                  // Local: put }
                                                }
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
                                                    0.03,
                                                decoration: BoxDecoration(
                                                  color: value.colors.gradient1,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
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
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                              Consumer<TourStatusprovider>(builder:
                                  (BuildContext context,
                                      TourStatusprovider tourStatus,
                                      Widget? child) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (tourStatus.isTourOn) {
                                            dialogBuilder(
                                                context,
                                                // 'A tour is currently running.\nStop tour first.',
                                                AppLocalizations.of(context)!
                                                    .poiExpansion_runningTourError,
                                                true,
                                                AppLocalizations.of(context)!
                                                    .defaults_ok,
                                                () {},
                                                () {});
                                          } else {
                                            final sshData =
                                                Provider.of<SSHprovider>(
                                                    context,
                                                    listen: false);

                                            Connectionprovider connection =
                                                Provider.of<Connectionprovider>(
                                                    context,
                                                    listen: false);

                                            ///checking the connection status first
                                            if (sshData.client != null &&
                                                connection.isLgConnected) {
                                              if (play) {
                                                try {
                                                  await LgService(sshData)
                                                      .startTour('Orbit');
                                                } catch (e) {
                                                  print(e);
                                                }
                                              } else {
                                                try {
                                                  await LgService(sshData)
                                                      .stopTour();
                                                } catch (e) {
                                                  print(e);
                                                }
                                              }
                                              if (mounted) {
                                                setState(() {
                                                  play = !play;
                                                });
                                              }
                                            } else {
                                              dialogBuilder(
                                                  context,
                                                  // 'NOT connected to LG !! \n Please Connect to LG',
                                                  AppLocalizations.of(context)!
                                                      .lgTasks_notConnectedError,
                                                  true,
                                                  // 'OK',
                                                  AppLocalizations.of(context)!
                                                      .defaults_ok,
                                                  null,
                                                  null);
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          decoration: BoxDecoration(
                                            color: FontAppColors.secondaryFont,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              play
                                                  ? const Icon(
                                                      Icons
                                                          .play_circle_outlined,
                                                      color: FontAppColors
                                                          .primaryFont,
                                                      size: titleSize + 10)
                                                  : const Icon(
                                                      Icons
                                                          .stop_circle_outlined,
                                                      color: FontAppColors
                                                          .primaryFont,
                                                      size: titleSize + 10),
                                              Flexible(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    // 'Orbit',
                                                    AppLocalizations.of(
                                                            context)!
                                                        .poiExpansion_orbit,
                                                    style: TextStyle(
                                                      color: FontAppColors
                                                          .primaryFont,
                                                      fontSize: fontVal
                                                              .fonts.textSize -
                                                          2,
                                                      fontFamily: fontType,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tooltip(
                                        message: _isFav
                                            // ? 'Added to favorites'
                                            ? AppLocalizations.of(context)!
                                                .favs_addtofavsmessage
                                            // : 'Removed from favorites',
                                            : AppLocalizations.of(context)!
                                                .favs_removefromfavsmessage,
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
                                            if (mounted) {
                                              setState(() {
                                                _isFav = false;
                                              });
                                            }
                                          } else {
                                            await FavoritesSharedPref()
                                                .addPlace(widget.placeModel);
                                            if (mounted) {
                                              setState(() {
                                                _isFav = true;
                                              });
                                            }
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
                                );
                              }),
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
