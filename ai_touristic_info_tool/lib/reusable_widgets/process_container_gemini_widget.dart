import 'dart:async';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/api.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/services/langchain_service.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProcessContainerGemini extends StatefulWidget {
  final String query;
  final String city;
  final String country;
  const ProcessContainerGemini(
      {super.key, required this.query, this.city = '', this.country = ''});

  @override
  State<ProcessContainerGemini> createState() => _ProcessContainerGeminiState();
}

class _ProcessContainerGeminiState extends State<ProcessContainerGemini> {
  late StreamController<dynamic> _streamController;
  late StreamController<dynamic> _messageController;
  // late StreamController<Map<String, dynamic>> _fullResultController;
  List<PlacesModel> _pois = [];
  late Map<String, dynamic> full_result;
  int _currProgress = 0;
  bool _isFinished = false;
  bool _isError = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final LangchainService _langchainService = LangchainService();
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<dynamic>();
    _messageController = StreamController<dynamic>();
    //  _fullResultController = StreamController<Map<String, dynamic>>();
    _subscription = _langchainService
        .generateStreamAnswer(widget.query)
        // .timeout(
        // Duration(seconds: 30), // Set your timeout duration here
        // onTimeout: (sink) {
        //   sink.addError('The request timed out. Please try again later.');
        // },
        // )
        .listen((event) {
      if (event['type'] == 'stream') {
        print('TYPE STREAM');
        if (mounted) {
          setState(() {
            // _currProgress += 1;
            print(_currProgress);
            _streamController.add(event['data']);
          });
        }
      } else if (event['type'] == 'result') {
        if (mounted) {
          setState(() {
            print('here');
            _initializePlaces(event['data']);
            print('after here');
          });
        }
      } else if (event['type'] == 'message') {
        if (event['data'] == 'Preparing visualizations') {
          if (mounted) {
            setState(() {
              _currProgress = 11;
              _messageController.add(event['data']);
            });
          }
        } else if (event['data'] == 'Almost Done! Please wait few seconds...') {
          if (mounted) {
            setState(() {
              _currProgress = 12;
              _messageController.add(event['data']);
            });
          }
        } else if (event['data'] == 'Streaming') {
          if (mounted) {
            setState(() {
              _currProgress += 1;
              _messageController.add(event['data']);
            });
          }
        }
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          _isError = true;
          _streamController.addError(error);
          _messageController.addError(error);
        });
      }
    });
  }

  _initializePlaces(Future<Map<String, dynamic>> futureResult) async {
    try {
      Map<String, dynamic> result = await futureResult;

      List<dynamic> places = result["places"] ?? [];
      print('places length:');
      print(places.length);
      print(places[0]['name']);

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
      // rethrow;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _streamController.close();
    _messageController.close();
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider colorProv,
            FontsProvider fontProv, Widget? child) {
          return StreamBuilder<dynamic>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Consumer2<ColorProvider, FontsProvider>(builder:
                      (BuildContext context, ColorProvider colorProv,
                          FontsProvider fontsProv, Widget? child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Error: ${snapshot.error}\nPlease try again later...',
                              style: TextStyle(
                                // color: FontAppColors.primaryFont,
                                color: fontsProv.fonts.primaryFontColor,
                                // fontSize: textSize,
                                fontSize: fontsProv.fonts.textSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontType,
                              ),
                            ),
                          ),
                        ),
                        LgElevatedButton(
                          elevatedButtonContent: 'OK',
                          // buttonColor: PrimaryAppColors.buttonColors,
                          buttonColor: colorProv.colors.buttonColors,
                          onpressed: () {
                            Navigator.pop(context);
                          },
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.2,
                          // fontSize: textSize,
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
                // return Center(
                //   child: Text(
                //     'Error: ${snapshot.error}',
                //     style: TextStyle(
                //       color: fontProv.fonts.primaryFontColor,
                //       fontSize: fontProv.fonts.textSize,
                //       fontFamily: fontType,
                //     ),
                //   ),
                // );
              } else if (!snapshot.hasData) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Consumer2<ColorProvider, FontsProvider>(builder:
                      (BuildContext context, ColorProvider colorProv,
                          FontsProvider fontsProv, Widget? child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'No data available\nPlease try again later...',
                              style: TextStyle(
                                // color: FontAppColors.primaryFont,
                                color: fontsProv.fonts.primaryFontColor,
                                // fontSize: textSize,
                                fontSize: fontsProv.fonts.textSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontType,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        LgElevatedButton(
                          elevatedButtonContent: 'OK',
                          // buttonColor: PrimaryAppColors.buttonColors,
                          buttonColor: colorProv.colors.buttonColors,
                          onpressed: () {
                            Navigator.pop(context);
                          },
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.2,
                          // fontSize: textSize,
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
                // return Center(
                //   child: Text(
                //     'No data available',
                //     style: TextStyle(
                //       color: fontProv.fonts.primaryFontColor,
                //       fontSize: fontProv.fonts.textSize,
                //       fontFamily: fontType,
                //     ),
                //   ),
                // );
              } else {
                return Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController2,
                  child: SingleChildScrollView(
                    controller: _scrollController2,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colorProv.colors.gradient1, width: 4),
                              borderRadius: BorderRadius.circular(30),
                              color: colorProv.colors.shadow.withOpacity(0.5),
                            ),
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: fontProv.fonts.textSize,
                                      fontFamily: fontType,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          // padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Average response time is 1 minute.\nThank you for your patience!',
                                style: TextStyle(
                                  color: LgAppColors.lgColor2,
                                  fontSize: fontProv.fonts.textSize + 2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: fontType,
                                ),
                              ),
                              if (fontProv.fonts.titleSize > 40)
                                Image.asset(
                                  'assets/images/wait2.gif',
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                              if (fontProv.fonts.titleSize == 40)
                                Image.asset(
                                  'assets/images/wait2.gif',
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  color: SettingsSharedPref.getTheme() == 'dark'
                                      ? Colors.black
                                      : Colors.white,
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 0),
                          child: Center(
                            child: Container(
                              // height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: StreamBuilder<dynamic>(
                                stream: _messageController.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      'Please wait... ',
                                      style: TextStyle(
                                        // color: FontAppColors.primaryFont,
                                        color: fontProv.fonts.primaryFontColor,
                                        // fontSize: textSize,
                                        fontSize: fontProv.fonts.textSize,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontType,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(
                                        // color: FontAppColors.primaryFont,
                                        color: fontProv.fonts.primaryFontColor,
                                        // fontSize: textSize,
                                        fontSize: fontProv.fonts.textSize,
                                        fontFamily: fontType,
                                      ),
                                    );
                                  } else if (snapshot.hasData) {
                                    return Text(
                                      _isFinished
                                          ? 'Generation completed successfully!'
                                          : snapshot.data.toString(),
                                      style: TextStyle(
                                        // color: FontAppColors.primaryFont,
                                        // fontSize: textSize,
                                        color: fontProv.fonts.primaryFontColor,
                                        fontSize: fontProv.fonts.textSize,
                                        fontFamily: fontType,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      'No data available',
                                      style: TextStyle(
                                        // color: FontAppColors.primaryFont,
                                        // fontSize: textSize,
                                        color: fontProv.fonts.primaryFontColor,
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
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colorProv.colors.gradient1, width: 2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: LinearProgressIndicator(
                              value: _isFinished ? 1.0 : _currProgress / 13.0,
                              borderRadius: BorderRadius.circular(30),
                              backgroundColor:
                                  FontAppColors.secondaryFont.withOpacity(0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorProv.colors.accentColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
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
                                        elevatedButtonContent: 'Visualize now!',
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        fontSize: fontProv.fonts.textSize,
                                        fontColor: FontAppColors.secondaryFont,
                                        isLoading: false,
                                        isBold: true,
                                        isPrefixIcon: false,
                                        isSuffixIcon: false,
                                        curvatureRadius: 30),
                                  ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                LgElevatedButton(
                                  elevatedButtonContent: 'Cancel',
                                  buttonColor: LgAppColors.lgColor2,
                                  onpressed: () {
                                    Navigator.pop(context);
                                  },
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
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
                          height: MediaQuery.of(context).size.height * 0.02,
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
}
