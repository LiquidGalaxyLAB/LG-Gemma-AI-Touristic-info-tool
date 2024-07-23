import 'dart:async';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/api.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProcessContainerWidget extends StatefulWidget {
  final String query;
  final String city;
  final String country;
  const ProcessContainerWidget(
      {super.key, required this.query, this.city = '', this.country = ''});

  @override
  State<ProcessContainerWidget> createState() => _ProcessContainerWidgetState();
}

class _ProcessContainerWidgetState extends State<ProcessContainerWidget> {
  late StreamController<dynamic> _messageController;
  late StreamController<dynamic> _chunkController;
  final List<String> _words = [];
  final List<PlacesModel> _pois = [];
  int _currProgress = 0;
  bool _isFinished = false;
  bool _isError = false;
  late StreamController<dynamic> _errorController;

  @override
  void initState() {
    super.initState();
    _messageController = StreamController();
    _chunkController = StreamController();
    _errorController = StreamController();

    Api().postaStreamEventsGemma(input: widget.query).listen((event) {
      setState(() {
        if (event['type'] == 'chunk') {
          _chunkController.sink.add(event['data']);
        } else if (event['type'] == 'message') {
          ModelErrorProvider errProvider =
              Provider.of<ModelErrorProvider>(context, listen: false);
          errProvider.hasStarted = true;
          _currProgress++;
          _messageController.sink.add(event['data']);
        } else if (event['type'] == 'result') {
          _isFinished = true;
          _pois.addAll(event['data']);
        } else if (event['type'] == 'error') {
          _isError = true;
          ModelErrorProvider errProvider =
              Provider.of<ModelErrorProvider>(context, listen: false);
          errProvider.isError = true;
          _errorController.sink.add(event['data']);
          if (event['data'].toString() ==
              'The server is currently unavailable. Please try again later.') {
            Connectionprovider connection =
                Provider.of<Connectionprovider>(context, listen: false);
            connection.isAiConnected = false;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _messageController.close();
    _chunkController.close();
    _errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: _errorController.stream,
      builder: (context, errorSnapshot) {
        if (_isError && errorSnapshot.hasData) {
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
                    child: Text(
                      errorSnapshot.data.toString(),
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
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Consumer2<ColorProvider, FontsProvider>(
              builder: (BuildContext context, ColorProvider colorProv,
                  FontsProvider fontProv, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 30, right: 30, bottom: 10),
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.8,
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
                                  snapshot.data.toString(),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(
                              // color: PrimaryAppColors.gradient1,
                              color: colorProv.colors.gradient1,
                              width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: LinearProgressIndicator(
                          value: _currProgress / 12, //was 6
                          backgroundColor:
                              FontAppColors.secondaryFont.withOpacity(0.5),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            // PrimaryAppColors.accentColor,
                            colorProv.colors.accentColor,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      // color: PrimaryAppColors.gradient1,
                                      color: colorProv.colors.gradient1,
                                      width: 4),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(111, 184, 184, 187),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: StreamBuilder<dynamic>(
                                        stream: _chunkController.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            //return CircularProgressIndicator();
                                            return Text(
                                              'Waiting for stream. Please wait... ',
                                              style: TextStyle(
                                                color:
                                                    FontAppColors.primaryFont,
                                                // fontSize: textSize,
                                                fontSize:
                                                    fontProv.fonts.textSize,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: fontType,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                              style: TextStyle(
                                                color:
                                                    FontAppColors.primaryFont,
                                                // fontSize: textSize,
                                                fontSize:
                                                    fontProv.fonts.textSize,
                                                fontFamily: fontType,
                                              ),
                                            );
                                          } else if (snapshot.hasData) {
                                            _words
                                                .add(snapshot.data!.toString());
                                            return Text(
                                              _words.join(' '),
                                              style: TextStyle(
                                                color:
                                                    FontAppColors.primaryFont,
                                                // fontSize: textSize,
                                                fontSize:
                                                    fontProv.fonts.textSize,
                                                fontFamily: fontType,
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              'No data available',
                                              style: TextStyle(
                                                color:
                                                    FontAppColors.primaryFont,
                                                // fontSize: textSize,
                                                fontSize:
                                                    fontProv.fonts.textSize,
                                                fontFamily: fontType,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  textAlign: TextAlign.justify,
                                  'Please Note that the model takes on Average 10 minutes to answer.\n\nThank you for your patience!',
                                  style: TextStyle(
                                    color: LgAppColors.lgColor2,
                                    // fontSize: textSize + 2,
                                    fontSize: fontProv.fonts.textSize + 2,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontType,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            if (fontProv.fonts.titleSize > 40)
                              Image.asset(
                                'assets/images/wait2.gif', // Replace with your actual asset path
                                width: MediaQuery.of(context).size.width * 0.2,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,

                                // You can also adjust other properties like width, height, etc.
                              ),
                            if (fontProv.fonts.titleSize == 40)
                              Image.asset(
                                'assets/images/wait2.gif', // Replace with your actual asset path
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                color: SettingsSharedPref.getTheme() == 'dark'
                                    ? Colors.black
                                    : Colors.white,
                                // You can also adjust other properties like width, height, etc.
                              ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Consumer<ModelErrorProvider>(builder:
                                (BuildContext context, ModelErrorProvider value,
                                    Widget? child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (_isFinished)
                                    LgElevatedButton(
                                        elevatedButtonContent: 'Visualize now!',
                                        // buttonColor:
                                        //     PrimaryAppColors.buttonColors,
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
                                              widget.country);
                                        },
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        // fontSize: textSize,
                                        fontSize: fontProv.fonts.textSize,
                                        fontColor: FontAppColors.secondaryFont,
                                        isLoading: false,
                                        isBold: true,
                                        isPrefixIcon: false,
                                        isSuffixIcon: false,
                                        curvatureRadius: 30),

                                  // SizedBox(
                                  //   width: MediaQuery.of(context).size.width *
                                  //       0.05,
                                  // ),
                                  // if (value.hasStarted)
                                  //   LgElevatedButton(
                                  //     elevatedButtonContent: 'Cancel',
                                  //     buttonColor: LgAppColors.lgColor2,
                                  //     onpressed: () {
                                  //       Navigator.pop(context);
                                  //       Api().cancelOperation();
                                  //     },
                                  //     height: MediaQuery.of(context).size.height *
                                  //         0.05,
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.15,
                                  //     fontSize: textSize,
                                  //     fontColor: FontAppColors.secondaryFont,
                                  //     isLoading: false,
                                  //     isBold: true,
                                  //     isPrefixIcon: false,
                                  //     isSuffixIcon: false,
                                  //     curvatureRadius: 30,
                                  //   ),
                                ],
                              );
                            }),
                          ],
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
