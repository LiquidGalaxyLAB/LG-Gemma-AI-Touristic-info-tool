import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
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
  double _currentProgress = 0.0;
  final double _totalDuration = 1.2 * 10; // Example total duration

  bool play = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        textAlign: TextAlign.justify,
        '${widget.index + 1}. ${widget.placeModel.name}',
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
            color: FontAppColors.primaryFont,
            fontSize: textSize,
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
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              border: Border.all(color: FontAppColors.primaryFont, width: 3),
              color: PrimaryAppColors.gradient4,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.1),
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
                              fontSize: textSize,
                              fontFamily: fontType,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () async {
                            LatLng newLocation = LatLng(
                                widget.placeModel.latitude,
                                widget.placeModel.longitude);
                            final mapProvider = Provider.of<GoogleMapProvider>(
                                context,
                                listen: false);
                            mapProvider.setBitmapDescriptor();
                            mapProvider.addMarker(context, widget.placeModel,
                                removeAll: true);
                            mapProvider.updateZoom(18.4746);
                            mapProvider.updateBearing(90);
                            mapProvider.updateTilt(45);
                            mapProvider.flyToLocation(newLocation);

                            mapProvider.currentlySelectedPin =
                                widget.placeModel;
                            mapProvider.pinPillPosition = 10;

                            await Future.delayed(const Duration(seconds: 3));

                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);

                            Connectionprovider connection =
                                Provider.of<Connectionprovider>(context,
                                    listen: false);

                            ///checking the connection status first
                            if (sshData.client != null &&
                                connection.isLgConnected) {
                              await buildPlacePlacemark(widget.placeModel,
                                  widget.index + 1, widget.query, context);
                            }
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                color: PrimaryAppColors.gradient1,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(Icons.airplanemode_active_outlined,
                                      color: FontAppColors.secondaryFont,
                                      size: textSize + 10),
                                  Text(
                                    'Fly to',
                                    style: TextStyle(
                                        color: FontAppColors.secondaryFont,
                                        fontSize: textSize - 4,
                                        fontFamily: fontType,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          // height: MediaQuery.of(context).size.height * 0.05,
                          //width: MediaQuery.of(context).size.width * 0.18,
                          width: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            color: FontAppColors.secondaryFont,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Row(
                                  //   children: [
                                  //     Text('x/2',
                                  //         style: TextStyle(
                                  //           color: FontAppColors.primaryFont,
                                  //           fontSize: textSize - 2,
                                  //           fontFamily: fontType,
                                  //         )),
                                  //     const Icon(
                                  //         Icons.keyboard_double_arrow_left,
                                  //         color: FontAppColors.primaryFont,
                                  //         size: textSize + 10),
                                  //   ],
                                  // ),
                                  GestureDetector(
                                      onTap: () async {
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
                                          if (play) {
                                            await LgService(sshData)
                                                .startTour('Orbit');
                                          } else {
                                            await LgService(sshData).stopTour();
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
                                              Icons.play_circle_outlined,
                                              //stop_circle_outlined
                                              color: FontAppColors.primaryFont,
                                              size: textSize + 10)
                                          : const Icon(
                                              Icons.stop_circle_outlined,
                                              color: FontAppColors.primaryFont,
                                              size: textSize + 10)),
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //         Icons.keyboard_double_arrow_right,
                                  //         color: FontAppColors.primaryFont,
                                  //         size: textSize + 10),
                                  //     Text('x2',
                                  //         style: TextStyle(
                                  //           color: FontAppColors.primaryFont,
                                  //           fontSize: textSize - 2,
                                  //           fontFamily: fontType,
                                  //         )),
                                  //   ],
                                  // ),
                                ],
                              ),
                              Text(
                                'Orbit',
                                style: TextStyle(
                                  color: FontAppColors.primaryFont,
                                  fontSize: textSize - 2,
                                  fontFamily: fontType,
                                ),
                              )
                              // Slider(
                              //   value: _currentProgress,
                              //   max: _totalDuration,
                              //   onChanged: (value) {
                              //     setState(() {
                              //       _currentProgress = value;
                              //     });
                              //   },
                              //   activeColor: FontAppColors.primaryFont,
                              //   inactiveColor:
                              //       FontAppColors.primaryFont.withOpacity(0.5),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
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