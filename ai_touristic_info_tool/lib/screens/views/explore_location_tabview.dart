import 'dart:io';
import 'dart:math';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/dialogs/dialog_builder.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/drop_down_list_component.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/services/gemini_services.dart';
import 'package:ai_touristic_info_tool/services/voices_services.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/dialogs/show_stream_gemini_dialog.dart';
import 'package:ai_touristic_info_tool/dialogs/visualization_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:record/record.dart';

class ExploreLocationTabView extends StatefulWidget {
  const ExploreLocationTabView({
    super.key,
    required GlobalKey<FormState> form2Key,
    required TextEditingController prompt2Controller,
  })  : _form2Key = form2Key,
        _prompt2Controller = prompt2Controller;

  final GlobalKey<FormState> _form2Key;
  final TextEditingController _prompt2Controller;

  @override
  State<ExploreLocationTabView> createState() => _ExploreLocationTabViewState();
}

class _ExploreLocationTabViewState extends State<ExploreLocationTabView> {
  Map<String, String?> fullAdddress = {};
  bool showAddressFields = false;
  bool useMap = true;
  bool _isTypePrompt = false;

  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: countries[0]);
  String? _chosenCountry;
  String _city = '';
  String _country = '';
  String _address = '';
  String _addressQuery = '';
  String _whatToDoQuery = '';

  final _addressFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // ignore: unused_field
  bool _isUseRecord = false;
  bool _isRecording = false;
  String? _audioPath;
  late final AudioRecorder _audioRecorder;
  // ignore: unused_field
  bool _isAudioProcessing = false;
  String? audioPrompt;
  // ignore: unused_field
  bool _isSTTFinished = false;
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    player.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      debugPrint(
          '=========>>>>>>>>>>> RECORDING!!!!!!!!!!!!!!! <<<<<<===========');

      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('ERROR WHILE RECORDING: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();
      if (mounted) {
        setState(() {
          _audioPath = path!;
          _isAudioProcessing = true;
        });
      }
      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
      convertSpeechToText();
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (_isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _isRecording = true;
          });
        }
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
      }
    } else {
      await _stopRecording();
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  void convertSpeechToText() async {
    //making a file using audio path:
    if (_audioPath != null) {
      final audioFile = File(_audioPath!);
      VoicesServicesApi().speechToTextApi(audioFile).then((value) {
        if (mounted) {
          setState(() {
            audioPrompt = value;
            _isAudioProcessing = false;
            _isSTTFinished = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int countryIndex = countries.indexOf(_countryController.text);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<FontsProvider>(
            builder:
                (BuildContext context, FontsProvider value, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: LgElevatedButton(
                        // elevatedButtonContent: 'Use Map',
                        elevatedButtonContent: AppLocalizations.of(context)!
                            .exploreLocation_mapButton,
                        buttonColor: ButtonColors.mapButton,
                        onpressed: () {
                          if (mounted) {
                            setState(() {
                              showAddressFields = false;
                              useMap = true;
                            });
                          }
                        },
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.2,
                        fontSize: value.fonts.textSize,
                        fontColor: FontAppColors.secondaryFont,
                        isLoading: false,
                        isBold: false,
                        isPrefixIcon: true,
                        prefixIcon: Icons.map_outlined,
                        prefixIconColor: Colors.white,
                        prefixIconSize: 30,
                        isSuffixIcon: false,
                        curvatureRadius: 10,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: LgElevatedButton(
                        // elevatedButtonContent: 'Type Address',
                        elevatedButtonContent: AppLocalizations.of(context)!
                            .exploreLocation_typeAdd,
                        buttonColor: ButtonColors.locationButton,
                        onpressed: () {
                          dialogBuilder(
                              context,
                              'Please add a city, and choose a country first to be able to generate POIs\nDo not forget to click on Save afterwards',
                              true,
                              AppLocalizations.of(context)!.defaults_ok, () {
                            if (mounted) {
                              setState(() {
                                showAddressFields = true;
                                _isUseRecord = false;
                                useMap = false;
                              });
                            }
                          }, () {});
                        },
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.2,
                        fontSize: value.fonts.textSize,
                        fontColor: FontAppColors.secondaryFont,
                        isLoading: false,
                        isBold: false,
                        isPrefixIcon: true,
                        prefixIcon: Icons.text_fields_outlined,
                        prefixIconColor: Colors.white,
                        prefixIconSize: 30,
                        isSuffixIcon: false,
                        curvatureRadius: 10,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(20.0),
                  //     child: LgElevatedButton(
                  //       elevatedButtonContent: 'Record Location',
                  //       // elevatedButtonContent: AppLocalizations.of(context)!
                  //       //     .exploreLocation_recordAudio,
                  //       buttonColor: ButtonColors.musicButton,
                  //       onpressed: () {
                  //         setState(() {
                  //           showAddressFields = false;
                  //           _isUseRecord = true;
                  //           useMap = false;
                  //         });
                  //       },
                  //       height: MediaQuery.of(context).size.height * 0.1,
                  //       width: MediaQuery.of(context).size.width * 0.2,
                  //       // fontSize: textSize,
                  //       fontSize: value.fonts.textSize,
                  //       fontColor: FontAppColors.secondaryFont,
                  //       isLoading: false,
                  //       isBold: false,
                  //       isPrefixIcon: true,
                  //       prefixIcon: Icons.mic_outlined,
                  //       prefixIconColor: Colors.white,
                  //       prefixIconSize: 30,
                  //       isSuffixIcon: false,
                  //       curvatureRadius: 10,
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          if (showAddressFields)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Consumer2<ColorProvider, FontsProvider>(
                builder: (BuildContext context, ColorProvider value,
                    FontsProvider fontval, Widget? child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: value.colors.buttonColors,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _addressFormKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                                // 'Address Details',
                                AppLocalizations.of(context)!
                                    .exploreLocation_address,
                                style: TextStyle(
                                    fontSize: fontval.fonts.textSize + 10,
                                    fontFamily: fontType,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            TextFormFieldWidget(
                              // hint: 'Enter address, or leave empty',
                              hint: AppLocalizations.of(context)!
                                  .exploreLocation_addressHint,
                              fontSize: fontval.fonts.textSize,
                              key: const ValueKey("address"),
                              textController: _addressController,
                              isSuffixRequired: false,
                              isPassword: false,
                              maxLength: 100,
                              maxlines: 1,
                              width: MediaQuery.sizeOf(context).width * 0.85,
                            ),
                            Text(
                                // 'City',
                                AppLocalizations.of(context)!
                                    .exploreLocation_city,
                                style: TextStyle(
                                    fontSize: fontval.fonts.textSize + 10,
                                    fontFamily: fontType,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            TextFormFieldWidget(
                              // hint: 'Enter city',
                              hint: AppLocalizations.of(context)!
                                  .exploreLocation_cityHint,
                              fontSize: fontval.fonts.textSize,
                              key: const ValueKey("city"),
                              textController: _cityController,
                              isSuffixRequired: true,
                              isPassword: false,
                              maxLength: 100,
                              maxlines: 1,
                              width: MediaQuery.sizeOf(context).width * 0.85,
                            ),
                            Text(
                                // 'Country',
                                AppLocalizations.of(context)!
                                    .exploreLocation_country,
                                style: TextStyle(
                                    fontSize: fontval.fonts.textSize + 10,
                                    fontFamily: fontType,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            DropDownListWidget(
                              key: const ValueKey("countries"),
                              fontSize: fontval.fonts.textSize,
                              items: countries,
                              selectedValue: countryIndex != -1
                                  ? countries[countryIndex]
                                  : countries[0],
                              hinttext: AppLocalizations.of(context)!
                                  .exploreLocation_countryHint,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    _countryController.text = value;
                                    _chosenCountry = value;
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Consumer2<ColorProvider, FontsProvider>(
                              builder: (BuildContext context,
                                  ColorProvider value,
                                  FontsProvider fontval,
                                  Widget? child) {
                                return LgElevatedButton(
                                    // elevatedButtonContent: 'Save',
                                    elevatedButtonContent:
                                        AppLocalizations.of(context)!
                                            .defaults_save,
                                    buttonColor: value.colors.innerBackground,
                                    fontColor: fontval.fonts.primaryFontColor,
                                    onpressed: () async {
                                      if (_addressFormKey.currentState!
                                          .validate()) {
                                        if (mounted) {
                                          setState(() {
                                            _city = _cityController.text;
                                            _country = _chosenCountry ?? '';
                                            _address = _addressController.text;
                                            _addressQuery =
                                                '$_address $_city $_country';
                                            useMap = false;
                                          });
                                        }

                                        MyLatLng myLatLng =
                                            await GeocodingService()
                                                .getCoordinates(_addressQuery);
                                        double lat = myLatLng.latitude;
                                        double long = myLatLng.longitude;

                                        LatLng newLocation = LatLng(lat, long);
                                        final mapProvider =
                                            Provider.of<GoogleMapProvider>(
                                                context,
                                                listen: false);
                                        mapProvider.currentFullAddress = {
                                          'city': _city,
                                          'country': _country,
                                          'address': _address
                                        };

                                        mapProvider.updateZoom(18.4746);
                                        mapProvider.updateBearing(90);
                                        mapProvider.updateTilt(45);
                                        mapProvider.flyToLocation(newLocation);
                                      }
                                    },
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    fontSize: fontval.fonts.textSize,
                                    isLoading: false,
                                    isBold: true,
                                    isPrefixIcon: false,
                                    isSuffixIcon: false,
                                    curvatureRadius: 10);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          // if (_isUseRecord)
          //   Consumer2<FontsProvider, ColorProvider>(
          //     builder: (BuildContext context, FontsProvider fontsProv,
          //         ColorProvider colorVal, Widget? child) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Center(
          //           child: Container(
          //             width: MediaQuery.of(context).size.width * 0.9,
          //             height: MediaQuery.of(context).size.height * 0.3,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               border: Border.all(
          //                 color: colorVal.colors.buttonColors,
          //                 width: 4,
          //               ),
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: SingleChildScrollView(
          //                 child: Column(
          //                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     Row(
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Expanded(
          //                           child: Text(
          //                             _isAudioProcessing
          //                                 ? 'We are processing your audio to text. Please wait...'
          //                                 : _isSTTFinished
          //                                     ? audioPrompt ??
          //                                         'No Text found. Please try recording again..'
          //                                     : 'Tap the microphone button to start recording.',
          //                             maxLines: 4,
          //                             style: TextStyle(
          //                               fontSize: fontsProv.fonts.textSize,
          //                               fontFamily: fontType,
          //                               // color: FontAppColors.primaryFont,
          //                               color: fontsProv.fonts.primaryFontColor,
          //                             ),
          //                           ),
          //                         ),
          //                         CustomRecordingButton(
          //                           isRecording: _isRecording,
          //                           onPressed: () => _record(),
          //                         ),
          //                       ],
          //                     ),
          //                     SizedBox(
          //                       height:
          //                           MediaQuery.of(context).size.height * 0.05,
          //                     ),
          //                     Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         LgElevatedButton(
          //                           elevatedButtonContent: 'Confirm',
          //                           buttonColor: LgAppColors.lgColor4,
          //                           onpressed: () async {
          //                             ModelErrorProvider errProvider =
          //                                 Provider.of<ModelErrorProvider>(
          //                                     context,
          //                                     listen: false);
          //                             errProvider.isError = false;
          //                             if (_isSTTFinished &&
          //                                 audioPrompt != null) {
          //                               setState(() {
          //                                 _addressQuery = audioPrompt!;
          //                                 useMap = false;
          //                               });

          //                               MyLatLng myLatLng =
          //                                   await GeocodingService()
          //                                       .getCoordinates(_addressQuery);
          //                               double lat = myLatLng.latitude;
          //                               double long = myLatLng.longitude;

          //                               LatLng newLocation = LatLng(lat, long);
          //                               final mapProvider =
          //                                   Provider.of<GoogleMapProvider>(
          //                                       context,
          //                                       listen: false);

          //                               mapProvider.updateZoom(18.4746);
          //                               mapProvider.updateBearing(90);
          //                               mapProvider.updateTilt(45);
          //                               mapProvider.flyToLocation(newLocation);

          //                               // gmp.updateCameraPosition(CameraPosition(
          //                               //     target: LatLng(lat, long), zoom: 14.4746));
          //                               // gmp.flyToLocation(LatLng(lat, long));

          //                               //snack bar:
          //                               ScaffoldMessenger.of(context)
          //                                   .showSnackBar(
          //                                 SnackBar(
          //                                   backgroundColor:
          //                                       LgAppColors.lgColor4,
          //                                   content: Consumer<FontsProvider>(
          //                                     builder: (BuildContext context,
          //                                         FontsProvider value,
          //                                         Widget? child) {
          //                                       return Text(
          //                                         'Scroll down now to choose one of the activities nearby that location!',
          //                                         // AppLocalizations.of(context)!
          //                                         //     .exploreWorld_recordPromptError,
          //                                         style: TextStyle(
          //                                           fontSize:
          //                                               value.fonts.textSize,
          //                                           color: Colors.white,
          //                                           fontFamily: fontType,
          //                                         ),
          //                                       );
          //                                     },
          //                                   ),
          //                                 ),
          //                               );
          //                             } else {
          //                               //snack bar:
          //                               ScaffoldMessenger.of(context)
          //                                   .showSnackBar(
          //                                 SnackBar(
          //                                   backgroundColor:
          //                                       LgAppColors.lgColor2,
          //                                   content: Consumer<FontsProvider>(
          //                                     builder: (BuildContext context,
          //                                         FontsProvider value,
          //                                         Widget? child) {
          //                                       return Text(
          //                                         'Please record a prompt first!',
          //                                         // AppLocalizations.of(context)!
          //                                         //     .exploreWorld_recordPromptError,
          //                                         style: TextStyle(
          //                                           fontSize:
          //                                               value.fonts.textSize,
          //                                           color: Colors.white,
          //                                           fontFamily: fontType,
          //                                         ),
          //                                       );
          //                                     },
          //                                   ),
          //                                 ),
          //                               );
          //                             }
          //                           },
          //                           height: MediaQuery.of(context).size.height *
          //                               0.05,
          //                           width:
          //                               MediaQuery.of(context).size.width * 0.2,
          //                           fontSize: fontsProv.fonts.textSize,
          //                           fontColor: Colors.white,
          //                           isLoading: false,
          //                           isBold: true,
          //                           isPrefixIcon: false,
          //                           isSuffixIcon: true,
          //                           suffixIcon: Icons.done_all,
          //                           suffixIconColor: Colors.white,
          //                           suffixIconSize: 30,
          //                           curvatureRadius: 30,
          //                         ),
          //                         SizedBox(
          //                             width: MediaQuery.of(context).size.width *
          //                                 0.05),
          //                         LgElevatedButton(
          //                           elevatedButtonContent: 'Clear',
          //                           buttonColor: LgAppColors.lgColor2,
          //                           onpressed: () {
          //                             setState(() {
          //                               _isAudioProcessing = false;
          //                               _isSTTFinished = false;
          //                               _audioPath = null;
          //                               _isRecording = false;
          //                             });
          //                           },
          //                           height: MediaQuery.of(context).size.height *
          //                               0.05,
          //                           width:
          //                               MediaQuery.of(context).size.width * 0.2,
          //                           fontSize: fontsProv.fonts.textSize,
          //                           fontColor: Colors.white,
          //                           isLoading: false,
          //                           isBold: true,
          //                           isPrefixIcon: false,
          //                           isSuffixIcon: true,
          //                           suffixIcon: Icons.clear,
          //                           suffixIconColor: Colors.white,
          //                           suffixIconSize: 30,
          //                           curvatureRadius: 30,
          //                         )
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
          if (useMap)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20),
              child: Consumer<FontsProvider>(
                builder:
                    (BuildContext context, FontsProvider value, Widget? child) {
                  return Text(
                    // 'Navigate till you find your desired location!',
                    AppLocalizations.of(context)!.exploreLocation_navigate,
                    style: TextStyle(
                        fontSize: value.fonts.textSize + 10,
                        fontFamily: fontType,
                        fontWeight: FontWeight.bold,
                        color: value.fonts.primaryFontColor),
                  );
                },
              ),
            ),

          if (!useMap)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20),
              child: Consumer<FontsProvider>(
                builder:
                    (BuildContext context, FontsProvider value, Widget? child) {
                  return Text(
                    // 'Click on Use Map button to navigate if you want!',
                    AppLocalizations.of(context)!.exploreLocation_useMap,
                    style: TextStyle(
                        fontSize: value.fonts.textSize + 10,
                        fontFamily: fontType,
                        fontWeight: FontWeight.bold,
                        color: value.fonts.primaryFontColor),
                  );
                },
              ),
            ),

          GoogleMapWidget(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            initialLatValue: 40.416775,
            initialLongValue: -3.703790,
            initialTiltValue: 41.82725143432617,
            initialBearingValue: 61.403038024902344,
            initialCenterValue: const LatLng(40.416775, -3.703790),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Center(
            child: Consumer<GoogleMapProvider>(
              builder: (BuildContext context, GoogleMapProvider value,
                  Widget? child) {
                if (useMap) {
                  _address = value.currentFullAddress['address'] ?? '';
                  _city = value.currentFullAddress['city'] ?? '';
                  _country = value.currentFullAddress['country'] ?? '';
                  _addressQuery = '$_address $_city $_country';
                } else {
                  _address = _addressController.text;
                  _city = _cityController.text;
                  _country =
                      (_chosenCountry != 'None' || _chosenCountry != null)
                          ? _chosenCountry ?? ''
                          : '';
                  if (_address == '' && _city == '' && _country == '') {
                    _addressQuery = '';
                  } else {
                    _addressQuery = '$_address $_city $_country';
                  }
                }

                return Consumer<FontsProvider>(
                  builder: (BuildContext context, FontsProvider value,
                      Widget? child) {
                    return Text(
                      // 'You are in $_addressQuery',
                      AppLocalizations.of(context)!
                          .exploreLocation_youarein(_addressQuery),
                      style: TextStyle(
                        fontSize: value.fonts.textSize + 8,
                        fontFamily: fontType,
                        color: value.fonts.primaryFontColor,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 50, bottom: 20),
            child: Consumer<FontsProvider>(
              builder:
                  (BuildContext context, FontsProvider value, Widget? child) {
                return Text(
                  // 'AI-Recommended Things To Do nearby',
                  AppLocalizations.of(context)!
                      .exploreLocation_aiRecommendation,
                  style: TextStyle(
                      fontSize: value.fonts.textSize + 10,
                      fontFamily: fontType,
                      fontWeight: FontWeight.bold,
                      color: value.fonts.primaryFontColor),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Consumer2<GoogleMapProvider, FontsProvider>(builder:
                  (BuildContext context, GoogleMapProvider value,
                      FontsProvider fontsVal, Widget? child) {
                return GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: <Widget>[
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/landmarkss.jpg',
                      // title: 'Landmarks',
                      title: AppLocalizations.of(context)!
                          .exploreLocation_landmarks,
                      query: !useMap
                          ? 'landmarks in $_addressQuery'
                          : 'landmarks in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/restaurants.jpeg',
                      // title: 'Restaurants and Cafes',
                      title: AppLocalizations.of(context)!
                          .exploreLocation_restaurants,
                      query: !useMap
                          ? 'Restaurants and Cafes in $_addressQuery'
                          : 'Restaurants and Cafes in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/art.jpeg',
                      // title: 'Art and Culture',
                      title: AppLocalizations.of(context)!.exploreLocation_art,
                      query: !useMap
                          ? 'Art and Culture in $_addressQuery'
                          : 'Art and Culture in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/shopping.jpeg',
                      // title: 'Shopping Malls',
                      title: AppLocalizations.of(context)!
                          .exploreLocation_shopping,
                      query: !useMap
                          ? 'Shopping Malls in $_addressQuery'
                          : 'Shopping Malls in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/sports.jpeg',
                      // title: 'Sports and Recreation',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_sports,
                      query: !useMap
                          ? 'Sports and Recreation in $_addressQuery'
                          : 'Sports and Recreation in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/spa.webp',
                      // title: 'Spa and Wellness',
                      title: AppLocalizations.of(context)!.exploreLocation_spa,
                      query: !useMap
                          ? 'Spa and Wellness in $_addressQuery'
                          : 'Spa and Wellness in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/outdoor.jpeg',
                      // title: 'Outdoor Activities',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_outdoor,
                      query: !useMap
                          ? 'Outdoor Activities in $_addressQuery'
                          : 'Outdoor Activities in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/pizza.jpeg',
                      // title: 'Top Pizza Places',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_pizza,
                      query: !useMap
                          ? 'Top Pizza Places in $_addressQuery'
                          : 'Top Pizza Places in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/history.jpg',
                      // title: 'Historical Sites',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_history,
                      query: !useMap
                          ? 'Historical Sites in $_addressQuery'
                          : 'Historical Sites in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/parks.webp',
                      // title: 'Local Parks',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_parks,
                      query: !useMap
                          ? 'Local Parks in $_addressQuery'
                          : 'Local Parks in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/cinema.jpeg',
                      // title: 'Cinemas',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_cinemas,
                      query: !useMap
                          ? 'Cinemas in $_addressQuery'
                          : 'Cinemas in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/library.jpeg',
                      // title: 'Libraries',
                      title: AppLocalizations.of(context)!
                          .exploreLocation_libraries,
                      query: !useMap
                          ? 'Libraries in $_addressQuery'
                          : 'Libraries in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/dancing.jpeg',
                      // title: 'Dancing Studios',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_dance,
                      query: !useMap
                          ? 'Dancing Studios in $_addressQuery'
                          : 'Dancing Studios in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/yoga.jpg',
                      // title: 'Yoga Studios',
                      title: AppLocalizations.of(context)!.exploreLocation_yoga,
                      query: !useMap
                          ? 'Yoga Studios in $_addressQuery'
                          : 'Yoga Studios in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/education.jpeg',
                      // title: 'Educational Institutions',
                      title: AppLocalizations.of(context)!.exploreLocation_edu,
                      query: !useMap
                          ? 'Educational Institutions in $_addressQuery'
                          : 'Educational Institutions in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/salons.jpeg',
                      // title: 'Beauty Salons',
                      title:
                          AppLocalizations.of(context)!.exploreLocation_salons,
                      query: !useMap
                          ? 'Beauty Salons in $_addressQuery'
                          : 'Beauty Salons in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                      addressQuery: _addressQuery,
                      isFromWorldwide: false,
                    ),
                  ],
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 30, bottom: 20),
            child: Consumer<FontsProvider>(
              builder:
                  (BuildContext context, FontsProvider value, Widget? child) {
                return Text(
                  //Local:
                  // 'Ask Gemma anything you want to know nearby:',
                  //Gemini:
                  // 'Ask Gemini anything you want to know nearby:',
                  AppLocalizations.of(context)!.exploreLocation_askGemini,
                  style: TextStyle(
                      fontSize: value.fonts.textSize + 10,
                      fontFamily: fontType,
                      fontWeight: FontWeight.bold,
                      color: value.fonts.primaryFontColor),
                );
              },
            ),
          ),
          Consumer<FontsProvider>(
            builder:
                (BuildContext context, FontsProvider value, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LgElevatedButton(
                    // elevatedButtonContent: 'Type a Prompt',
                    elevatedButtonContent:
                        AppLocalizations.of(context)!.button_TypePrompt,
                    buttonColor: ButtonColors.locationButton,
                    onpressed: () {
                      if (mounted) {
                        setState(() {
                          _isTypePrompt = true;
                          // _isRecordPrompt = false;
                        });
                      }
                    },
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.2,
                    fontSize: value.fonts.textSize,
                    fontColor: Colors.white,
                    isLoading: false,
                    isBold: true,
                    isPrefixIcon: false,
                    isSuffixIcon: true,
                    suffixIcon: Icons.keyboard,
                    suffixIconColor: Colors.white,
                    suffixIconSize: value.fonts.headingSize,
                    curvatureRadius: 10,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  // LgElevatedButton(
                  //   elevatedButtonContent: 'Record a Prompt',
                  //   buttonColor: ButtonColors.musicButton,
                  //   onpressed: () {
                  //     setState(() {
                  //       _isRecordPrompt = true;
                  //       _isTypePrompt = false;
                  //     });
                  //   },
                  //   height: MediaQuery.of(context).size.height * 0.08,
                  //   width: MediaQuery.of(context).size.width * 0.2,
                  //   fontSize: fontsProv.fonts.textSize,
                  //   fontColor: Colors.white,
                  //   isLoading: false,
                  //   isBold: true,
                  //   isPrefixIcon: false,
                  //   isSuffixIcon: true,
                  //   suffixIcon: Icons.mic,
                  //   suffixIconColor: Colors.white,
                  //   suffixIconSize: fontsProv.fonts.headingSize,
                  //   curvatureRadius: 10,
                  // ),
                ],
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          if (_isTypePrompt)
            Form(
              key: widget._form2Key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer<FontsProvider>(
                    builder: (BuildContext context, FontsProvider value,
                        Widget? child) {
                      return Center(
                        child: TextFormFieldWidget(
                          fontSize: value.fonts.textSize,
                          key: const ValueKey("location-prompt"),
                          textController: widget._prompt2Controller,
                          isSuffixRequired: false,
                          isPassword: false,
                          maxLength: 100,
                          maxlines: 1,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, top: 20),
                    child: Consumer2<ColorProvider, FontsProvider>(
                      builder: (BuildContext context, ColorProvider value,
                          FontsProvider fontVal, Widget? child) {
                        return LgElevatedButton(
                          key: const ValueKey("location-prompt-button"),
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          buttonColor: value.colors.buttonColors,
                          fontSize: fontVal.fonts.textSize,
                          fontColor:
                              SettingsSharedPref.getTheme() == 'default' ||
                                      SettingsSharedPref.getTheme() == 'light'
                                  ? fontVal.fonts.secondaryFontColor
                                  : fontVal.fonts.primaryFontColor,
                          isBold: true,
                          isLoading: false,
                          isPrefixIcon: false,
                          isSuffixIcon: false,
                          curvatureRadius: 50,
                          onpressed: () async {
                            ModelErrorProvider errProvider =
                                Provider.of<ModelErrorProvider>(context,
                                    listen: false);
                            errProvider.isError = false;
                            if (widget._form2Key.currentState!.validate()) {
                              GoogleMapProvider gmp =
                                  Provider.of<GoogleMapProvider>(context,
                                      listen: false);
                              _whatToDoQuery = widget._prompt2Controller.text;
                              String query;

                              if (useMap) {
                                query =
                                    '$_whatToDoQuery in ${gmp.currentFullAddress['address']}, ${gmp.currentFullAddress['city']}, ${gmp.currentFullAddress['country']}';
                              } else {
                                if (_addressQuery == '') {
                                  query = '';
                                } else {
                                  query = '$_whatToDoQuery in $_addressQuery';
                                }
                              }

                              if (!useMap && query == '') {
                                //show snack bar with error:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: LgAppColors.lgColor2,
                                    content: Consumer<FontsProvider>(
                                      builder: (BuildContext context,
                                          FontsProvider value, Widget? child) {
                                        return Text(
                                          // 'Please enter an address first above or use map!',
                                          AppLocalizations.of(context)!
                                              .exploreLocation_missingAddress,
                                          style: TextStyle(
                                            fontSize: value.fonts.textSize,
                                            color: Colors.white,
                                            fontFamily: fontType,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                PromptsSharedPref.getPlaces(query)
                                    .then((value) async {
                                  if (value.isNotEmpty) {
                                    await buildQueryPlacemark(
                                        query, _city, _country, context);

                                    showVisualizationDialog(context, value,
                                        query, _city, _country, () {}, false);
                                  } else {
                                    //Local:
                                    // Connectionprovider connection =
                                    //     Provider.of<Connectionprovider>(context,
                                    //         listen: false);
                                    // if (!connection.isAiConnected) {
                                    //   dialogBuilder(
                                    //       context,
                                    //       'NOT connected to AI Server!!\nPlease Connect!',
                                    //       true,
                                    //       'OK',
                                    //       null,
                                    //       null);
                                    // } else {
                                    //   showStreamingDialog(
                                    //       context, query, _city, _country);
                                    // }
                                    //Gemini:
                                    ApiKeyModel? apiKeyModel =
                                        await APIKeySharedPref.getDefaultApiKey(
                                            'Gemini');
                                    String apiKey;
                                    if (apiKeyModel == null) {
                                      //snackbar:
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                LgAppColors.lgColor2,
                                            content: Consumer<FontsProvider>(
                                              builder: (BuildContext context,
                                                  FontsProvider value,
                                                  Widget? child) {
                                                return Text(
                                                  // 'Please add a default API Key for Gemini in the settings!',
                                                  AppLocalizations.of(context)!
                                                      .settings_apiKeyNotSetDefaultError,
                                                  style: TextStyle(
                                                    fontSize:
                                                        value.fonts.textSize,
                                                    color: Colors.white,
                                                    fontFamily: fontType,
                                                  ),
                                                );
                                              },
                                            )),
                                      );
                                    } else {
                                      apiKey = apiKeyModel.key;
                                      if (mounted) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                      String res = await GeminiServices()
                                          .checkAPIValidity(apiKey, context);
                                      if (mounted) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                      if (res == '') {
                                        Locale locale = await SettingsSharedPref
                                            .getLocale();
                                        showStreamingGeminiDialog(
                                            context,
                                            query,
                                            _city,
                                            _country,
                                            apiKey,
                                            locale);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor:
                                                  LgAppColors.lgColor2,
                                              content: Consumer<FontsProvider>(
                                                builder: (BuildContext context,
                                                    FontsProvider value,
                                                    Widget? child) {
                                                  return Text(
                                                    res,
                                                    style: TextStyle(
                                                      fontSize:
                                                          value.fonts.textSize,
                                                      color: Colors.white,
                                                      fontFamily: fontType,
                                                    ),
                                                  );
                                                },
                                              )),
                                        );
                                      }
                                    }
                                  }
                                });
                              }
                            }
                          },
                          elevatedButtonContent:
                              // _isLoading ? 'Loading..' : 'GENERATE',
                              _isLoading
                                  ? AppLocalizations.of(context)!
                                      .defaults_loading
                                  : AppLocalizations.of(context)!
                                      .defaults_generate,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
