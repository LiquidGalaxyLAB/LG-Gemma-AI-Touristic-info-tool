import 'dart:async';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/services/gemini_services.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/dialogs/visualization_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProcessContainerGemini extends StatefulWidget {
  final String query;
  final String city;
  final String country;
  final String apiKey;
  final Locale locale;
  const ProcessContainerGemini(
      {super.key,
      required this.query,
      this.city = '',
      this.country = '',
      required this.apiKey,
      required this.locale});

  @override
  State<ProcessContainerGemini> createState() => _ProcessContainerGeminiState();
}

class _ProcessContainerGeminiState extends State<ProcessContainerGemini> {
  late StreamController<dynamic> _streamController;
  late StreamController<dynamic> _messageController;
  late StreamController<dynamic> _errorController;

  List<PlacesModel> _pois = [];
  late Map<String, dynamic> full_result;
  int _currProgress = 0;
  bool _isFinished = false;
  bool _isError = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final GeminiServices _langchainService = GeminiServices();

  late StreamSubscription _subscription;
  late Map<String, dynamic> lastResult;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<dynamic>();
    _messageController = StreamController<dynamic>();
    _errorController = StreamController<dynamic>();
    Timer(Duration(seconds: 200), () {
      if (!_isFinished) {
        if (mounted) {
          setState(() {
            _isError = true;
            _errorController.addError(AppLocalizations.of(context)!
                .aiGenerationAPIGemini_timeOutMessg);
          });
        }
      }
    });

    _subscription = _langchainService
        .generateStreamAnswer(widget.query, widget.apiKey)
        .listen((event) {
      if (mounted) {
        if (event['type'] == 'stream') {
          if (mounted) {
            setState(() {
              lastResult = event['data'];
              _streamController.add(event['data']);
            });
          }
        } else if (event['type'] == 'error') {
          if (mounted) {
            setState(() {
              _isError = true;
              _errorController.addError(event['data']);
            });
          }
        } else if (event['type'] == 'message') {
          if (event['data'] == 'Preparing visualizations') {
            if (mounted) {
              setState(() {
                _currProgress = 12;
                _messageController.add(event['data']);
              });
            }
          } else if (event['data'] == 'Streaming' ||
              event['data'] == "بث" ||
              event['data'] == 'Transmitiendo' ||
              event['data'] == 'स्ट्रीमिंग' ||
              event['data'] == 'ストリーミング中') {
            if (mounted) {
              setState(() {
                _currProgress += 1;
                _messageController.add(event['data']);
              });
            }
          }
        }
      }
    }, onDone: () {
      if (mounted) {
        if (!_isError) {
          _initializePlaces(lastResult);
        }
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          _isError = true;
          _streamController.addError(error);
          _messageController.addError(error);
          _errorController.addError(error);
        });
      }
    });
  }

  _initializePlaces(Map<String, dynamic> futureResult) async {
    try {
      Map<String, dynamic> result = futureResult;

      List<dynamic> places = result["places"] ?? [];

      for (int i = 0; i < places.length; i++) {
        final poi = places[i];
        String location =
            '${poi['name']}, ${poi['address']}, ${poi['city']}, ${poi['country']}';
        MyLatLng latlng = await GeocodingService().getCoordinates(location);

        if (mounted) {
          setState(() {
            _pois.add(PlacesModel(
              id: i + 1,
              name: poi["name"],
              address: poi["address"],
              city: poi["city"],
              country: poi["country"],
              description: poi["description"],
              price: poi["pricing"],
              ratings: poi["rating"],
              amenities: poi["amenities"],
              latitude: latlng.latitude,
              longitude: latlng.longitude,
              sourceLink: poi["source"],
            ));
          });
        }
      }
      if (mounted) {
        setState(() {
          _currProgress = 13;
          _isFinished = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _streamController.close();
    _errorController.close();
    _messageController.close();
    _scrollController.dispose();
    _scrollController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: _errorController.stream,
      builder: (context, errorSnapshot) {
        if (_isError || errorSnapshot.hasData) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            // height: MediaQuery.of(context).size.height * 0.2,
            child: Consumer2<ColorProvider, FontsProvider>(builder:
                (BuildContext context, ColorProvider colorProv,
                    FontsProvider fontsProv, Widget? child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      errorSnapshot.hasData
                          ? errorSnapshot.data.toString()
                          // : 'An error occurred. Please try again later...\n',
                          : AppLocalizations.of(context)!
                              .aiGenerationAPIGemini_error2,
                      style: TextStyle(
                        color: fontsProv.fonts.primaryFontColor,
                        fontSize: fontsProv.fonts.textSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontType,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  LgElevatedButton(
                    // elevatedButtonContent: 'OK',
                    elevatedButtonContent:
                        AppLocalizations.of(context)!.defaults_ok,

                    buttonColor: colorProv.colors.buttonColors,
                    onpressed: () {
                      Navigator.pop(context);
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.2,

                    fontSize: fontsProv.fonts.textSize,
                    fontColor: FontAppColors.secondaryFont,
                    isLoading: false,
                    isBold: true,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 30,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  )
                ],
              );
            }),
          );
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height*0.02,
            child: Consumer2<ColorProvider, FontsProvider>(
              builder: (BuildContext context, ColorProvider colorProv,
                  FontsProvider fontProv, Widget? child) {
                return StreamBuilder<dynamic>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: CircularProgressIndicator(
                                        color: colorProv.colors.buttonColors,
                                      )),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                                Center(
                                  child: Text(
                                    // 'Please hold on while the model collects information from the web to provide a unique, accurate, and up-to-date experience!',
                                    AppLocalizations.of(context)!
                                        .aiGenerationAPIGemini_webLoadingMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: fontProv.fonts.primaryFontColor,
                                      fontSize: fontProv.fonts.textSize,
                                      fontFamily: fontType,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        // height: MediaQuery.of(context).size.height * 0.1,
                        child: Consumer2<ColorProvider, FontsProvider>(builder:
                            (BuildContext context, ColorProvider colorProv,
                                FontsProvider fontsProv, Widget? child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    // 'Error: ${snapshot.error}\nPlease try again later...',
                                    AppLocalizations.of(context)!
                                        .aiGenerationAPIGemini_snapShotError(
                                            snapshot.error.toString()),
                                    style: TextStyle(
                                      color: fontsProv.fonts.primaryFontColor,
                                      fontSize: fontsProv.fonts.textSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontType,
                                    ),
                                  ),
                                ),
                              ),
                              LgElevatedButton(
                                // elevatedButtonContent: 'OK',
                                elevatedButtonContent:
                                    AppLocalizations.of(context)!.defaults_ok,

                                buttonColor: colorProv.colors.buttonColors,
                                onpressed: () {
                                  Navigator.pop(context);
                                },
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.2,

                                fontSize: fontsProv.fonts.textSize,
                                fontColor: FontAppColors.secondaryFont,
                                isLoading: false,
                                isBold: true,
                                isPrefixIcon: false,
                                isSuffixIcon: false,
                                curvatureRadius: 30,
                              ),
                            ],
                          );
                        }),
                      );
                    } else if (!snapshot.hasData) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        // height: MediaQuery.of(context).size.height * 0.2,
                        child: Consumer2<ColorProvider, FontsProvider>(builder:
                            (BuildContext context, ColorProvider colorProv,
                                FontsProvider fontsProv, Widget? child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    // 'No data available\nPlease try again later...',
                                    AppLocalizations.of(context)!
                                        .aiGenerationAPIGemini_noDataError,
                                    style: TextStyle(
                                      color: fontsProv.fonts.primaryFontColor,
                                      fontSize: fontsProv.fonts.textSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontType,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              LgElevatedButton(
                                // elevatedButtonContent: 'OK',
                                elevatedButtonContent:
                                    AppLocalizations.of(context)!.defaults_ok,

                                buttonColor: colorProv.colors.buttonColors,
                                onpressed: () {
                                  Navigator.pop(context);
                                },
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.2,

                                fontSize: fontsProv.fonts.textSize,
                                fontColor: FontAppColors.secondaryFont,
                                isLoading: false,
                                isBold: true,
                                isPrefixIcon: false,
                                isSuffixIcon: false,
                                curvatureRadius: 30,
                              ),
                            ],
                          );
                        }),
                      );
                    } else {
                      return Scrollbar(
                        thumbVisibility: true,
                        controller: _scrollController2,
                        child: SingleChildScrollView(
                          controller: _scrollController2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 10.0, right: 10, top: 10),
                              //   child: Container(
                              //     height:
                              //         MediaQuery.of(context).size.height * 0.4,
                              //     width:
                              //         MediaQuery.of(context).size.width * 0.9,
                              //     decoration: BoxDecoration(
                              //       border: Border.all(
                              //           color: colorProv.colors.gradient1,
                              //           width: 4),
                              //       borderRadius: BorderRadius.circular(30),
                              //       color: colorProv.colors.shadow
                              //           .withOpacity(0.5),
                              //     ),
                              //     child: Scrollbar(
                              //       thumbVisibility: true,
                              //       controller: _scrollController,
                              //       child: SingleChildScrollView(
                              //         controller: _scrollController,
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(10.0),
                              //           child: Text(
                              //             snapshot.data.toString(),
                              //             style: TextStyle(
                              //               color: FontAppColors.primaryFont,
                              //               fontSize: fontProv.fonts.textSize,
                              //               fontFamily: fontType,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Center(
                                child: Padding(
                                  // padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                  padding: EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: _isFinished ? 20 : 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .aiGenerationAPIGemini_responseTimeMessg,
                                        style: TextStyle(
                                          color: LgAppColors.lgColor2,
                                          fontSize: fontProv.fonts.textSize + 2,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: fontType,
                                        ),
                                      ),
                                      Image.asset(
                                        _isFinished
                                            ? 'assets/images/wait.png'
                                            : 'assets/images/wait2.gif',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height: _isFinished
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.12
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, bottom: 0),
                                child: Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: StreamBuilder<dynamic>(
                                      stream: _messageController.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                            // 'Please wait... ',
                                            AppLocalizations.of(context)!
                                                .aiGenerationAPIGemini_waitMessg,
                                            style: TextStyle(
                                              color: fontProv
                                                  .fonts.primaryFontColor,
                                              fontSize: fontProv.fonts.textSize,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: fontType,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            // 'Error: ${snapshot.error}',
                                            AppLocalizations.of(context)!
                                                .aiGenerationAPIGemini_snapShotError(
                                                    snapshot.error.toString()),
                                            style: TextStyle(
                                              color: fontProv
                                                  .fonts.primaryFontColor,
                                              fontSize: fontProv.fonts.textSize,
                                              fontFamily: fontType,
                                            ),
                                          );
                                        } else if (snapshot.hasData) {
                                          return Text(
                                            _isFinished
                                                ? AppLocalizations.of(context)!
                                                    .aiGenerationAPIGemini_successGeneration
                                                : snapshot.data.toString() ==
                                                        'The model is generating the POIs for you. Please wait... '
                                                    ? widget.locale ==
                                                            Locale('ar')
                                                        ? 'جاري توليد الأماكن لك. يرجى الانتظار...'
                                                        : widget.locale ==
                                                                Locale('ja')
                                                            ? 'モデルがPOIを生成しています。お待ちください...'
                                                            : widget.locale ==
                                                                    Locale('hi')
                                                                ? 'मॉडल आपके लिए पीओआई उत्पन्न कर रहा है। कृपया प्रतीक्षा करें...'
                                                                : widget.locale ==
                                                                        Locale(
                                                                            'es')
                                                                    ? 'El modelo está generando los POI para ti. Por favor espera...'
                                                                    : widget.locale ==
                                                                            Locale(
                                                                                'de')
                                                                        ? 'Das Modell generiert die POIs für Sie. Bitte warten...'
                                                                        : widget.locale ==
                                                                                Locale(
                                                                                    'fr')
                                                                            ? 'Le modèle génère les POI pour vous. Veuillez patienter...'
                                                                            : widget.locale ==
                                                                                    Locale(
                                                                                        'it')
                                                                                ? 'Il modello sta generando i POI per te. Attendere...'
                                                                                : 'The model is generating the POIs for you. Please wait... '
                                                    : snapshot.data
                                                                .toString() ==
                                                            'Preparing visualizations'
                                                        ? widget.locale ==
                                                                Locale('ar')
                                                            ? 'جاري تحضير التصورات'
                                                            : widget.locale ==
                                                                    Locale('ja')
                                                                ? 'ビジュアライゼーションの準備中'
                                                                : widget.locale ==
                                                                        Locale(
                                                                            'hi')
                                                                    ? 'विजुअलाइजेशन की तैयारी'
                                                                    : widget.locale ==
                                                                            Locale(
                                                                                'es')
                                                                        ? 'Preparando visualizaciones'
                                                                        : widget.locale ==
                                                                                Locale('de')
                                                                            ? 'Visualisierungen vorbereiten'
                                                                            : widget.locale == Locale('fr')
                                                                                ? 'Préparation des visualisations'
                                                                                : widget.locale == Locale('it')
                                                                                    ? 'Preparazione delle visualizzazioni'
                                                                                    : 'Preparing visualizations'
                                                        : 'Please wait...',
                                            style: TextStyle(
                                              color: fontProv
                                                  .fonts.primaryFontColor,
                                              fontSize: fontProv.fonts.textSize,
                                              fontFamily: fontType,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            // 'No data available',
                                            AppLocalizations.of(context)!
                                                .aiGenerationAPIGemini_noDataError,
                                            style: TextStyle(
                                              color: fontProv
                                                  .fonts.primaryFontColor,
                                              fontSize: fontProv.fonts.textSize,
                                              fontFamily: fontType,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colorProv.colors.gradient1,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: LinearProgressIndicator(
                                    value: _isFinished
                                        ? 1.0
                                        : _currProgress / 13.0,
                                    borderRadius: BorderRadius.circular(30),
                                    backgroundColor: FontAppColors.secondaryFont
                                        .withOpacity(0.5),
                                    valueColor: _isFinished
                                        ? AlwaysStoppedAnimation<Color>(
                                            LgAppColors.lgColor4)
                                        : AlwaysStoppedAnimation<Color>(
                                            colorProv.colors.accentColor,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Consumer<ModelErrorProvider>(
                                builder: (BuildContext context,
                                    ModelErrorProvider value, Widget? child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_isFinished)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30.0, top: 10, bottom: 10),
                                          child: LgElevatedButton(
                                              elevatedButtonContent:
                                                  // 'Visualize now!',
                                                  AppLocalizations.of(context)!
                                                      .defaults_visualizeNow,
                                              buttonColor:
                                                  colorProv.colors.buttonColors,
                                              onpressed: () async {
                                                await buildQueryPlacemark(
                                                    widget.query,
                                                    widget.city,
                                                    widget.country,
                                                    context);

                                                showVisualizationDialog(
                                                    context,
                                                    _pois,
                                                    widget.query,
                                                    widget.city,
                                                    widget.country,
                                                    () {},
                                                    false);
                                              },
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              fontSize: fontProv.fonts.textSize,
                                              fontColor:
                                                  FontAppColors.secondaryFont,
                                              isLoading: false,
                                              isBold: true,
                                              isPrefixIcon: false,
                                              isSuffixIcon: false,
                                              curvatureRadius: 30),
                                        ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      LgElevatedButton(
                                        // elevatedButtonContent: 'Cancel',
                                        elevatedButtonContent:
                                            AppLocalizations.of(context)!
                                                .defaults_cancel,
                                        buttonColor: LgAppColors.lgColor2,
                                        onpressed: () {
                                          if (mounted) {
                                            _subscription.cancel();

                                            Navigator.pop(context);
                                          }
                                        },
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        fontSize: textSize,
                                        fontColor: FontAppColors.secondaryFont,
                                        isLoading: false,
                                        isBold: true,
                                        isPrefixIcon: false,
                                        isSuffixIcon: false,
                                        curvatureRadius: 30,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
