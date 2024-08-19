import 'dart:io';
import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/kml/KMLModel.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/models/saved_tours_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/poi_expansion_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/search_results_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/services/voices_services.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/dialog_builder.dart';
import 'package:ai_touristic_info_tool/state_management/tour_status_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VisualizationDialog extends StatefulWidget {
  final List<PlacesModel> places;
  final String query;
  final String? city;
  final String? country;
  final VoidCallback onItemRemoved;
  final bool fromFav;
  final double initialLat;
  final double initialLong;
  const VisualizationDialog({
    super.key,
    required this.places,
    required this.query,
    this.city,
    this.country,
    required this.onItemRemoved,
    required this.fromFav,
    required this.initialLat,
    required this.initialLong,
  });

  @override
  State<VisualizationDialog> createState() => _VisualizationDialogState();
}

class _VisualizationDialogState extends State<VisualizationDialog> {
  late bool _isTourOn;
  final _narrationPlayer = AudioPlayer();
  PlayerState _audioPlayerState = PlayerState.stopped;
  bool _isPlaying = false;
  // ignore: unused_field
  bool _isPaused = false;
  bool _isAudioFinishedNarration = true;
  bool _narratedOnce = false;
  bool _isAudioLoading = false;
  bool _isAudioEmptyError = false;
  bool _isAudioPlayError = false;

  File? _audioFile;

  @override
  void initState() {
    super.initState();
    _isTourOn = false;
    _narrationPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
          if (state == PlayerState.playing) {
            _isPlaying = true;
            _isPaused = false;
            _isAudioFinishedNarration = false;
            _isAudioLoading = false;
          } else if (state == PlayerState.paused) {
            _isPlaying = false;
            _isPaused = true;
            _isAudioFinishedNarration = false;
            _isAudioLoading = false;
          } else if (state == PlayerState.completed) {
            _isPlaying = false;
            _isPaused = false;
            _isAudioFinishedNarration = true;
            _isAudioLoading = false;
          }
        });
      }
    });
  }

  void playAudio() async {
    try {
      if (_isAudioEmptyError) {
        //
      } else {
        await _narrationPlayer.play(DeviceFileSource(_audioFile!.path));
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          _isAudioPlayError = true;
        });
      }
    }
  }

  void stopAudio() async {
    await _narrationPlayer.stop();
  }

  void pauseAudio() async {
    await _narrationPlayer.pause();
  }

  void resumeAudio() async {
    await _narrationPlayer.resume();
  }

  void _convertTextToSpeech(String text) async {
    if (mounted) {
      setState(() {
        _narratedOnce = true;
      });
    }

    File? audioFile = await VoicesServicesApi().textToSpeech(text);

    if (audioFile == null) {
      if (mounted) {
        setState(() {
          _isAudioEmptyError = true;
          _isAudioLoading = false;
        });
      }
      dialogBuilder(
          context,
          _isAudioEmptyError
              ? 'Error loading audio. Please try again later.'
              : 'Error playing audio. Please try again later.',
          true,
          AppLocalizations.of(context)!.defaults_ok,
          () {},
          () {});
      return;
    }
    if (mounted) {
      setState(() {
        _audioFile = audioFile;
      });
    }
    playAudio();
  }

  void _handlePlayPause(String text) async {
    if (!_isAudioEmptyError && !_isAudioPlayError) {
      if (_audioPlayerState == PlayerState.playing) {
        if (mounted) {
          setState(() {
            _isAudioLoading = false;
          });
        }
        pauseAudio();
      } else if (_audioPlayerState == PlayerState.paused) {
        if (mounted) {
          setState(() {
            _isAudioLoading = false;
          });
        }
        resumeAudio();
      } else if (_audioPlayerState == PlayerState.stopped ||
          _audioPlayerState == PlayerState.completed) {
        if (_narratedOnce) {
          playAudio();
        } else {
          if (mounted) {
            setState(() {
              _isAudioLoading = true;
            });
          }
          _convertTextToSpeech(text);
          if (mounted) {
            setState(() {
              _narratedOnce = true;
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _narrationPlayer.dispose();
    if (_audioFile != null && _audioFile!.existsSync()) {
      _audioFile!.deleteSync();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Stack(
            alignment: Alignment.center,
            children: [
              Column(
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
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.query,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: SettingsSharedPref.getTheme() ==
                                              'dark'
                                          ? fontVal.fonts.primaryFontColor
                                          : fontVal.fonts.secondaryFontColor,
                                      fontSize: fontVal.fonts.headingSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontType),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FavIcon(
                                  iconSize: fontVal.fonts.textSize + 40,
                                  query: widget.query,
                                  places: widget.places,
                                  city: widget.city ?? '',
                                  country: widget.country ?? '',
                                  onItemRemoved: widget.onItemRemoved,
                                  fromFav: widget.fromFav,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.055,
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LgElevatedButton(
                      // elevatedButtonContent: 'Show POIs',
                      elevatedButtonContent: AppLocalizations.of(context)!
                          .visualizationDialog_Showpois,
                      buttonColor: SettingsSharedPref.getTheme() == 'dark'
                          ? colorVal.colors.midShadow
                          : FontAppColors.secondaryFont,
                      onpressed: () async {
                        final mapProvider = Provider.of<GoogleMapProvider>(
                            context,
                            listen: false);
                        mapProvider.setBitmapDescriptor(
                            "assets/images/placemark_pin.png");
                        mapProvider.updateZoom(12.4746);

                        mapProvider.flyToLocation(
                            LatLng(widget.initialLat, widget.initialLong));

                        for (int i = 0; i < widget.places.length; i++) {
                          PlacesModel placeModel = widget.places[i];

                          mapProvider.addMarker(context, placeModel,
                              removeAll: false);
                        }

                        await Future.delayed(const Duration(seconds: 3));
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        Connectionprovider connection =
                            Provider.of<Connectionprovider>(context,
                                listen: false);

                        ///checking the connection status first
                        if (sshData.client != null &&
                            connection.isLgConnected) {
                          await buildShowPois(
                              widget.places,
                              context,
                              widget.initialLat,
                              widget.initialLong,
                              widget.city,
                              widget.country,
                              widget.query);
                        }
                      },
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.165,
                      fontSize: textSize,
                      // fontSize: fontVal.fonts.textSize,
                      fontColor: FontAppColors.primaryFont,
                      isLoading: false,
                      isBold: true,
                      isPrefixIcon: true,
                      prefixIcon: Icons.location_on_outlined,
                      prefixIconColor: FontAppColors.primaryFont,
                      prefixIconSize: 30,
                      isSuffixIcon: false,
                      borderColor: FontAppColors.primaryFont,
                      borderWidth: 2,
                      curvatureRadius: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    LgElevatedButton(
                      // elevatedButtonContent: 'Play Tour',
                      elevatedButtonContent: AppLocalizations.of(context)!
                          .visualizationDialog_playTour,
                      buttonColor: SettingsSharedPref.getTheme() == 'dark'
                          ? colorVal.colors.midShadow
                          : FontAppColors.secondaryFont,
                      onpressed: () async {
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        Connectionprovider connection =
                            Provider.of<Connectionprovider>(context,
                                listen: false);

                        ///checking the connection status first
                        if (sshData.client != null &&
                            connection.isLgConnected) {
                          List<KMLModel> kmlBalloons = await buildQueryTour(
                              context, widget.query, widget.places);
                          dialogBuilder(
                              context,
                              'Are you sure you want to start tour?',
                              // AppLocalizations.of(context)!
                              //     .lgTasks_notConnectedError,
                              false,
                              // 'OK',
                              AppLocalizations.of(context)!.defaults_yes,
                              () async {
                            TourStatusprovider tourStatus =
                                Provider.of<TourStatusprovider>(context,
                                    listen: false);
                            setState(() {
                              _isTourOn = true;
                              tourStatus.isTourOn = true;
                            });

                            await LgService(sshData).startTour('App Tour');
                            for (int i = 0; i < kmlBalloons.length; i++) {
                              if (_isTourOn) {
                                await LgService(sshData).sendKMLToSlave(
                                  LgService(sshData).balloonScreen,
                                  kmlBalloons[i].body,
                                );
                                await Future.delayed(Duration(seconds: 60));
                              } else {
                                break;
                              }
                            }
                          }, null);
                        } else {
                          dialogBuilder(
                              context,
                              // 'NOT connected to LG !! \n Please Connect to LG',
                              AppLocalizations.of(context)!
                                  .lgTasks_notConnectedError,
                              true,
                              // 'OK',
                              AppLocalizations.of(context)!.defaults_ok,
                              null,
                              null);
                        }
                      },
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.165,
                      fontSize: textSize,

                      fontColor: FontAppColors.primaryFont,
                      isLoading: false,
                      isBold: true,
                      isPrefixIcon: true,
                      prefixIcon: Icons.play_arrow_outlined,
                      prefixIconColor: FontAppColors.primaryFont,
                      prefixIconSize: 30,
                      isSuffixIcon: false,
                      borderColor: FontAppColors.primaryFont,
                      borderWidth: 2,
                      curvatureRadius: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    LgElevatedButton(
                      // elevatedButtonContent: 'Stop Tour',
                      elevatedButtonContent: AppLocalizations.of(context)!
                          .visualizationDialog_stopTour,
                      buttonColor: SettingsSharedPref.getTheme() == 'dark'
                          ? colorVal.colors.midShadow
                          : FontAppColors.secondaryFont,
                      onpressed: () async {
                        final sshData =
                            Provider.of<SSHprovider>(context, listen: false);

                        Connectionprovider connection =
                            Provider.of<Connectionprovider>(context,
                                listen: false);

                        ///checking the connection status first
                        if (sshData.client != null &&
                            connection.isLgConnected) {
                          dialogBuilder(
                              context,
                              'Are you sure you want to stop tour?',
                              // AppLocalizations.of(context)!
                              //     .lgTasks_notConnectedError,
                              false,
                              // 'OK',
                              AppLocalizations.of(context)!.defaults_yes,
                              () async {
                            TourStatusprovider tourStatus =
                                Provider.of<TourStatusprovider>(context,
                                    listen: false);
                            await LgService(sshData).stopTour();
                            setState(() {
                              _isTourOn = false;
                              tourStatus.isTourOn = true;
                            });
                            await LgService(sshData).clearKml();
                          }, null);
                        } else {
                          dialogBuilder(
                              context,
                              // 'NOT connected to LG !! \n Please Connect to LG',
                              AppLocalizations.of(context)!
                                  .lgTasks_notConnectedError,
                              true,
                              // 'OK',
                              AppLocalizations.of(context)!.defaults_ok,
                              null,
                              null);
                        }
                      },
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.165,
                      fontSize: textSize,

                      fontColor: FontAppColors.primaryFont,
                      isLoading: false,
                      isBold: true,
                      isPrefixIcon: true,
                      prefixIcon: Icons.stop_outlined,
                      prefixIconColor: FontAppColors.primaryFont,
                      prefixIconSize: 30,
                      isSuffixIcon: false,
                      borderColor: FontAppColors.primaryFont,
                      borderWidth: 2,
                      curvatureRadius: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    // LgElevatedButton(
                    //   elevatedButtonContent: playAudioElevatedButtonContent,

                    //   // elevatedButtonContent: AppLocalizations.of(context)!
                    //   //     .visualizationDialog_PrepTour,
                    //   buttonColor: SettingsSharedPref.getTheme() == 'dark'
                    //       ? colorVal.colors.midShadow
                    //       : FontAppColors.secondaryFont,
                    //   onpressed: () async {
                    //     String voiceNarration =
                    //         'Let\'s begin our ${widget.query} tour!';
                    //     for (int i = 0; i < widget.places.length; i++) {
                    //       PlacesModel poi = widget.places[i];
                    //       if (i == 0) {
                    //         voiceNarration +=
                    //             'First, we have ${poi.name} in ${poi.city}, ${poi.country}.';
                    //       } else {
                    //         voiceNarration +=
                    //             'Next, we have ${poi.name} in ${poi.city}, ${poi.country}.';
                    //       }
                    //       voiceNarration += poi.description ?? '';
                    //     }
                    //     if (_isAudioEmptyError) {
                    //       //
                    //       dialogBuilder(
                    //           context,
                    //           _isAudioEmptyError
                    //               ? 'Error loading audio. Please try again later.'
                    //               : 'Error playing audio. Please try again later.',
                    //           true,
                    //           AppLocalizations.of(context)!.defaults_ok,
                    //           () {},
                    //           () {});
                    //     } else {
                    //       _handlePlayPause(voiceNarration);
                    //     }
                    //   },
                    //   height: MediaQuery.of(context).size.height * 0.07,
                    //   width: MediaQuery.of(context).size.width * 0.165,
                    //   fontSize: textSize,

                    //   fontColor: FontAppColors.primaryFont,
                    //   isLoading: false,
                    //   isBold: true,
                    //   isPrefixIcon: true,
                    //   prefixIcon: _isAudioLoading
                    //       ? Icons.watch_later_outlined
                    //       : _isPlaying
                    //           ? Icons.stop
                    //           : _isAudioFinishedNarration
                    //               ? CupertinoIcons.speaker_1_fill
                    //               : Icons.play_circle_sharp,
                    //   prefixIconColor: FontAppColors.primaryFont,
                    //   prefixIconSize: 30,
                    //   isSuffixIcon: false,
                    //   borderColor: FontAppColors.primaryFont,
                    //   borderWidth: 2,
                    //   curvatureRadius: 10,
                    // ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.01,
                    // ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: Consumer<SearchProvider>(
                    builder: (BuildContext context, SearchProvider value,
                        Widget? child) {
                      if (value.showMap) {
                        return Column(children: [
                          GoogleMapWidget(
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.55,
                            initialLatValue: widget.initialLat,
                            initialLongValue: widget.initialLong,
                            initialTiltValue: 41.82725143432617,
                            initialBearingValue: 61.403038024902344,
                            initialCenterValue:
                                LatLng(widget.initialLat, widget.initialLong),
                            query: widget.query,
                          ),
                        ]);
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: SearchResultsContainer(),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                AppDividerWidget(
                    height: MediaQuery.of(context).size.height * 0.6),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Consumer<FontsProvider>(
                        builder: (BuildContext context, FontsProvider value,
                            Widget? child) {
                          return Text(
                            // 'List of POIs',
                            AppLocalizations.of(context)!
                                .visualizationDialog_listofPois,
                            style: TextStyle(
                                color: value.fonts.primaryFontColor,
                                fontSize: fontVal.fonts.textSize + 4,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontType),
                          );
                        },
                      ),
                      const Divider(
                        color: FontAppColors.primaryFont,
                        thickness: 0.5,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.places.length,
                          itemBuilder: (context, index) {
                            final placeModel = widget.places[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PoiExpansionWidget(
                                  placeModel: placeModel,
                                  index: index,
                                  query: widget.query,
                                ),
                                Divider(
                                  color: FontAppColors.primaryFont,
                                  thickness: 0.5,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Consumer2<SearchProvider, ColorProvider>(
                builder: (BuildContext context, SearchProvider value,
                    ColorProvider colorProv, Widget? child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!value.showMap)
                        LgElevatedButton(
                          // elevatedButtonContent: 'Map',
                          elevatedButtonContent: AppLocalizations.of(context)!
                              .visualizationDialog_mapButton,

                          buttonColor: colorProv.colors.buttonColors,
                          onpressed: () {
                            Provider.of<SearchProvider>(context, listen: false)
                                .showMap = true;
                          },
                          height: MediaQuery.of(context).size.height * 0.035,
                          width: MediaQuery.of(context).size.width * 0.1,

                          fontSize: fontVal.fonts.textSize,
                          fontColor: FontAppColors.secondaryFont,
                          isLoading: false,
                          isBold: false,
                          isPrefixIcon: false,
                          isSuffixIcon: false,
                          curvatureRadius: 30,
                        ),
                      if (!value.showMap)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                      LgElevatedButton(
                        // elevatedButtonContent: 'Close',
                        elevatedButtonContent:
                            AppLocalizations.of(context)!.defaults_close,

                        buttonColor: colorProv.colors.buttonColors,
                        onpressed: () async {
                          SSHprovider sshData =
                              Provider.of<SSHprovider>(context, listen: false);
                          await LgService(sshData).clearKml();
                          await buildAppBalloonOverlay(context);

                          final mapProvider = Provider.of<GoogleMapProvider>(
                              context,
                              listen: false);

                          mapProvider.clearCustomMarkers();
                          mapProvider.clearMarkers();
                          mapProvider.clearPolylinesMap();
                          mapProvider.clearPolylines();
                          mapProvider.pinPillPosition =
                              MediaQuery.of(context).size.height * 1;

                          while (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                        height: MediaQuery.of(context).size.height * 0.035,
                        width: MediaQuery.of(context).size.width * 0.1,

                        fontSize: fontVal.fonts.textSize,
                        fontColor: FontAppColors.secondaryFont,
                        isLoading: false,
                        isBold: false,
                        isPrefixIcon: false,
                        isSuffixIcon: false,
                        curvatureRadius: 30,
                      ),
                    ],
                  );
                },
              ),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  String get playAudioElevatedButtonContent {
    if (_isAudioLoading) {
      return 'Loading..';
    } else if (_isAudioEmptyError ||
        _isAudioPlayError ||
        _isAudioFinishedNarration) {
      return 'Play sound';
    } else if (_isPlaying) {
      return 'Pause';
    } else {
      return 'Resume';
    }
  }
}

class FavIcon extends StatefulWidget {
  final double iconSize;
  final String query;
  final List<PlacesModel> places;
  final String city;
  final String country;
  final VoidCallback onItemRemoved;
  final bool fromFav;
  const FavIcon({
    super.key,
    required this.iconSize,
    required this.query,
    required this.places,
    required this.city,
    required this.country,
    required this.onItemRemoved,
    required this.fromFav,
  });

  @override
  State<FavIcon> createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _checkIsFav();
  }

  Future<void> _checkIsFav() async {
    bool doesExist = await FavoritesSharedPref().isTourExist(widget.query);
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
    return Tooltip(
      message: _isFav
          ? AppLocalizations.of(context)!.favs_addtofavsmessage
          : AppLocalizations.of(context)!.favs_removefromfavsmessage,
      triggerMode: TooltipTriggerMode.tap,
      onTriggered: () async {
        if (await FavoritesSharedPref().isTourExist(widget.query)) {
          await FavoritesSharedPref().removeTour(widget.query);
          setState(() {
            _isFav = false;
          });
          if (widget.fromFav) {
            widget.onItemRemoved();
            Navigator.of(context).pop();
          }
        } else {
          await FavoritesSharedPref().addTour(SavedToursModel(
            query: widget.query,
            places: widget.places,
            city: widget.city,
            country: widget.country,
            isGenerated: true,
          ));
          setState(() {
            _isFav = true;
          });
        }
      },
      child: Icon(
        _isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
        color: LgAppColors.lgColor2,
        size: widget.iconSize,
      ),
    );
  }
}
