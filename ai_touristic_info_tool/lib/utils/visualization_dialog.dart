import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_map_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/services/coordinates_extraction.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/map_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void showVisualizationDialog(BuildContext context, List<PlacesModel> places,
    String query, String? city, String? country) async {
  MyLatLng myLatLng = await getCoordinates('$city, $country');
  double lat = myLatLng.latitude;
  double long = myLatLng.longitude;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FontAppColors.secondaryFont,
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
        title: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                TopBarWidget(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Center(
                    child: Text(
                      query,
                      style: TextStyle(
                          color: FontAppColors.secondaryFont,
                          fontSize: headingSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontType),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                )
              ],
            ),
            Positioned(
              bottom: 5,
              // left: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LgElevatedButton(
                    elevatedButtonContent: 'Show\nPOIs',
                    buttonColor: FontAppColors.secondaryFont,
                    onpressed: () async {
                      final mapProvider = Provider.of<GoogleMapProvider>(
                          context,
                          listen: false);
                      mapProvider.setBitmapDescriptor();
                      mapProvider.updateZoom(12.4746);
                      mapProvider.flyToLocation(
                          LatLng(myLatLng.latitude, myLatLng.longitude));

                      for (int i = 0; i < places.length; i++) {
                        PlacesModel placeModel = places[i];

                        LatLng newLocation =
                            LatLng(placeModel.latitude, placeModel.longitude);
                        mapProvider.addMarker(newLocation, placeModel.name,
                            placeModel.description,
                            removeAll: false);
                      }

                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      Connectionprovider connection =
                          Provider.of<Connectionprovider>(context,
                              listen: false);

                      ///checking the connection status first
                      if (sshData.client != null && connection.isLgConnected) {
                        await buildShowPois(
                            places, context, lat, long, city, country, query);
                      }
                    },
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.15,
                    fontSize: textSize,
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
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  LgElevatedButton(
                    elevatedButtonContent: 'Start\nTour',
                    buttonColor: FontAppColors.secondaryFont,
                    onpressed: () async {
                      final sshData =
                          Provider.of<SSHprovider>(context, listen: false);

                      Connectionprovider connection =
                          Provider.of<Connectionprovider>(context,
                              listen: false);

                      ///checking the connection status first
                      if (sshData.client != null && connection.isLgConnected) {
                        await buildQueryTour(context, query, places);
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
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.15,
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
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  LgElevatedButton(
                    elevatedButtonContent: 'Stop\nTour',
                    buttonColor: FontAppColors.secondaryFont,
                    onpressed: () {},
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.15,
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
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  LgElevatedButton(
                    elevatedButtonContent: 'Resume\nTour',
                    buttonColor: FontAppColors.secondaryFont,
                    onpressed: () {},
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.15,
                    fontSize: textSize,
                    fontColor: FontAppColors.primaryFont,
                    isLoading: false,
                    isBold: true,
                    isPrefixIcon: true,
                    prefixIcon: Icons.restore_outlined,
                    prefixIconColor: FontAppColors.primaryFont,
                    prefixIconSize: 30,
                    isSuffixIcon: false,
                    borderColor: FontAppColors.primaryFont,
                    borderWidth: 2,
                    curvatureRadius: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  LgElevatedButton(
                    elevatedButtonContent: 'Save\nFavorite',
                    buttonColor: FontAppColors.secondaryFont,
                    onpressed: () {},
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.15,
                    fontSize: textSize,
                    fontColor: FontAppColors.primaryFont,
                    isLoading: false,
                    isBold: true,
                    isPrefixIcon: true,
                    prefixIcon: Icons.favorite_border_outlined,
                    prefixIconColor: FontAppColors.primaryFont,
                    prefixIconSize: 30,
                    isSuffixIcon: false,
                    borderColor: FontAppColors.primaryFont,
                    borderWidth: 2,
                    curvatureRadius: 10,
                  ),
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
                child: Column(
                  children: [
                    GoogleMapWidget(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.55,
                      initialLatValue: lat,
                      //places[0].latitude,
                      initialLongValue: long,
                      //places[0].longitude,
                      initialTiltValue: 41.82725143432617,
                      initialBearingValue: 61.403038024902344,
                      initialCenterValue: LatLng(lat, long),
                      //LatLng(places[0].latitude, places[0].longitude),
                    ),
                  ],
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
                    Text(
                      'List of POIs',
                      style: TextStyle(
                          color: FontAppColors.primaryFont,
                          fontSize: textSize + 4,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontType),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);

                            Connectionprovider connection =
                                Provider.of<Connectionprovider>(context,
                                    listen: false);

                            ///checking the connection status first
                            if (sshData.client != null &&
                                connection.isLgConnected) {
                              await LgService(sshData).startTour('Orbit');
                            }
                          },
                          child: const Icon(Icons.loop_outlined,
                              color: FontAppColors.primaryFont,
                              size: textSize + 20),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);

                            Connectionprovider connection =
                                Provider.of<Connectionprovider>(context,
                                    listen: false);

                            ///checking the connection status first
                            if (sshData.client != null &&
                                connection.isLgConnected) {
                              await LgService(sshData).stopTour();
                            }
                            // } else {
                            //   dialogBuilder(
                            //       context,
                            //       'NOT connected to LG !! \n Please Connect to LG',
                            //       true,
                            //       'OK',
                            //       null,
                            //       null);
                            // }
                          },
                          child: const Icon(Icons.stop_outlined,
                              color: FontAppColors.primaryFont,
                              size: textSize + 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    const Divider(
                      color: FontAppColors.primaryFont,
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          final placeModel = places[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  LatLng newLocation = LatLng(
                                      placeModel.latitude,
                                      placeModel.longitude);
                                  final mapProvider =
                                      Provider.of<GoogleMapProvider>(context,
                                          listen: false);
                                  mapProvider.setBitmapDescriptor();
                                  mapProvider.addMarker(newLocation,
                                      placeModel.name, placeModel.description,
                                      removeAll: true);
                                  mapProvider.updateZoom(18.4746);
                                  mapProvider.updateBearing(90);
                                  mapProvider.updateTilt(45);
                                  mapProvider.flyToLocation(newLocation);

                                  final sshData = Provider.of<SSHprovider>(
                                      context,
                                      listen: false);

                                  Connectionprovider connection =
                                      Provider.of<Connectionprovider>(context,
                                          listen: false);

                                  ///checking the connection status first
                                  if (sshData.client != null &&
                                      connection.isLgConnected) {
                                    await buildPlacePlacemark(
                                        placeModel, index + 1, query, context);
                                  }
                                  // } else {
                                  //   dialogBuilder(
                                  //       context,
                                  //       'NOT connected to LG !! \n Please Connect to LG',
                                  //       true,
                                  //       'OK',
                                  //       null,
                                  //       null);
                                  // }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Consider setting mainAxisSize to MainAxisSize.min and using FlexFit.loose fits for the flexible children
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Text(
                                          placeModel.name,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: FontAppColors.primaryFont,
                                            fontSize: textSize,
                                            fontFamily: fontType,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    const Icon(
                                        Icons.airplanemode_active_outlined,
                                        color: FontAppColors.primaryFont,
                                        size: textSize + 10),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: FontAppColors.primaryFont,
                                thickness: 0.5,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                          'You can fly to any POI while the tour is nnot running',
                          style: TextStyle(
                              color: LgAppColors.lgColor3,
                              fontSize: textSize - 4,
                              fontStyle: FontStyle.italic,
                              fontFamily: fontType)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: LgElevatedButton(
              elevatedButtonContent: 'Close',
              buttonColor: PrimaryAppColors.buttonColors,
              onpressed: () async {
                await buildAppBalloon(context);
                Navigator.of(context).pop();
              },
              height: MediaQuery.of(context).size.height * 0.035,
              width: MediaQuery.of(context).size.width * 0.1,
              fontSize: textSize,
              fontColor: FontAppColors.secondaryFont,
              isLoading: false,
              isBold: false,
              isPrefixIcon: false,
              isSuffixIcon: false,
              curvatureRadius: 30,
            ),
            // Text('Close',
            //     style: TextStyle(
            //         color: FontAppColors.primaryFont,
            //         fontSize: textSize,
            //         fontWeight: FontWeight.bold,
            //         fontFamily: fontType)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
