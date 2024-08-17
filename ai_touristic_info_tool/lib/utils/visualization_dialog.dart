import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/visualization_dialog.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showVisualizationDialog(
  BuildContext context,
  List<PlacesModel> places,
  String query,
  String? city,
  String? country,
  VoidCallback onItemRemoved,
  bool fromFav,
) async{
  MyLatLng myLatLng;
  if (country == '' || country == null) {
      myLatLng =
          MyLatLng(places[0].latitude, places[0].longitude);
    } else {
      myLatLng = await GeocodingService()
          .getCoordinates('$city, $country');
    }
    double lat = myLatLng.latitude;
    double long = myLatLng.longitude;
  SearchProvider srch = Provider.of<SearchProvider>(context, listen: false);
  srch.showMap = true;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return VisualizationDialog(
        places: places,
        query: query,
        city: city,
        country: country,
        onItemRemoved: onItemRemoved,
        fromFav: fromFav,
        initialLat: lat,
        initialLong:long,
      );
    },
  );
}



// void showVisualizationDialog(
//   BuildContext context,
//   List<PlacesModel> places,
//   String query,
//   String? city,
//   String? country,
//   VoidCallback onItemRemoved,
//   bool fromFav,
// ) async {
//   print('inside visualizatiion: $city , $country');
//   MyLatLng myLatLng;
//   //check if null
//   if (country == '' || country == null) {
//     myLatLng = MyLatLng(places[0].latitude, places[0].longitude);
//   } else {
//     myLatLng = await GeocodingService().getCoordinates('$city, $country');
//   }
//   SearchProvider srch = Provider.of<SearchProvider>(context, listen: false);
//   srch.showMap = true;

//   double lat = myLatLng.latitude;
//   double long = myLatLng.longitude;
//   bool _isTourOn = false;
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Consumer2<ColorProvider, FontsProvider>(
//         builder: (BuildContext context, ColorProvider colorVal,
//             FontsProvider fontVal, Widget? child) {
//           return StatefulBuilder(
//             builder: (BuildContext context,
//                 void Function(void Function()) setState) {
//               return AlertDialog(
//                 // backgroundColor: FontAppColors.secondaryFont,
//                 backgroundColor: colorVal.colors.innerBackground,
//                 shadowColor: FontAppColors.secondaryFont,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 // insetPadding: EdgeInsets.zero,
//                 iconPadding: EdgeInsets.zero,
//                 titlePadding: const EdgeInsets.only(bottom: 20),
//                 contentPadding: EdgeInsets.zero,
//                 actionsPadding: const EdgeInsets.only(bottom: 10),
//                 surfaceTintColor: FontAppColors.secondaryFont,
//                 title: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Column(
//                       children: [
//                         TopBarWidget(
//                           // grad1: colorVal.colors.gradient1,
//                           // grad2: colorVal.colors.gradient2,
//                           // grad3: colorVal.colors.gradient3,
//                           // grad4: colorVal.colors.gradient4,
//                           grad1: SettingsSharedPref.getTheme() == 'light'
//                               ? colorVal.colors.buttonColors
//                               : colorVal.colors.gradient1,
//                           grad2: SettingsSharedPref.getTheme() == 'light'
//                               ? colorVal.colors.buttonColors
//                               : colorVal.colors.gradient2,
//                           grad3: SettingsSharedPref.getTheme() == 'light'
//                               ? colorVal.colors.buttonColors
//                               : colorVal.colors.gradient3,
//                           grad4: SettingsSharedPref.getTheme() == 'light'
//                               ? colorVal.colors.buttonColors
//                               : colorVal.colors.gradient4,

//                           height: MediaQuery.of(context).size.height * 0.1,
//                           width: MediaQuery.of(context).size.width * 1,
//                           child: Center(
//                             child: Text(
//                               query,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   // color: FontAppColors.secondaryFont,
//                                   // color: SettingsSharedPref.getTheme() == 'default'
//                                   //     ? fontVal.fonts.secondaryFontColor
//                                   //     : fontVal.fonts.primaryFontColor,
//                                   color: SettingsSharedPref.getTheme() == 'dark'
//                                       ? fontVal.fonts.primaryFontColor
//                                       : fontVal.fonts.secondaryFontColor,
//                                   // fontSize: headingSize,
//                                   // fontSize: fontVal.fonts.headingSize,
//                                   fontSize: fontVal.fonts.headingSize,
//                                   fontWeight: FontWeight.bold,
//                                   fontFamily: fontType),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: MediaQuery.of(context).size.height * 0.055,
//                         )
//                       ],
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       // left: 50,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           LgElevatedButton(
//                             // elevatedButtonContent: 'Show POIs',
//                             elevatedButtonContent: AppLocalizations.of(context)!
//                                 .visualizationDialog_Showpois,
//                             buttonColor: SettingsSharedPref.getTheme() == 'dark'
//                                 ? colorVal.colors.midShadow
//                                 : FontAppColors.secondaryFont,
//                             onpressed: () async {
//                               final mapProvider =
//                                   Provider.of<GoogleMapProvider>(context,
//                                       listen: false);
//                               mapProvider.setBitmapDescriptor(
//                                   "assets/images/placemark_pin.png");
//                               mapProvider.updateZoom(12.4746);
//                               mapProvider.flyToLocation(LatLng(
//                                   myLatLng.latitude, myLatLng.longitude));

//                               for (int i = 0; i < places.length; i++) {
//                                 PlacesModel placeModel = places[i];

//                                 // LatLng newLocation =
//                                 //     LatLng(placeModel.latitude, placeModel.longitude);
//                                 mapProvider.addMarker(context, placeModel,
//                                     removeAll: false);
//                               }

//                               //wait for 5 seconds:
//                               await Future.delayed(const Duration(seconds: 3));
//                               final sshData = Provider.of<SSHprovider>(context,
//                                   listen: false);

//                               Connectionprovider connection =
//                                   Provider.of<Connectionprovider>(context,
//                                       listen: false);

//                               ///checking the connection status first
//                               if (sshData.client != null &&
//                                   connection.isLgConnected) {
//                                 await buildShowPois(places, context, lat, long,
//                                     city, country, query);
//                               }
//                             },
//                             height: MediaQuery.of(context).size.height * 0.07,
//                             width: MediaQuery.of(context).size.width * 0.165,
//                             fontSize: textSize,
//                             // fontSize: fontVal.fonts.textSize,
//                             fontColor: FontAppColors.primaryFont,
//                             isLoading: false,
//                             isBold: true,
//                             isPrefixIcon: true,
//                             prefixIcon: Icons.location_on_outlined,
//                             prefixIconColor: FontAppColors.primaryFont,
//                             prefixIconSize: 30,
//                             isSuffixIcon: false,
//                             borderColor: FontAppColors.primaryFont,
//                             borderWidth: 2,
//                             curvatureRadius: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.01,
//                           ),
//                           LgElevatedButton(
//                             // elevatedButtonContent: 'Play Tour',
//                             elevatedButtonContent: AppLocalizations.of(context)!
//                                 .visualizationDialog_playTour,
//                             buttonColor: SettingsSharedPref.getTheme() == 'dark'
//                                 ? colorVal.colors.midShadow
//                                 : FontAppColors.secondaryFont,
//                             onpressed: () async {
//                               final sshData = Provider.of<SSHprovider>(context,
//                                   listen: false);

//                               Connectionprovider connection =
//                                   Provider.of<Connectionprovider>(context,
//                                       listen: false);

//                               ///checking the connection status first
//                               if (sshData.client != null &&
//                                   connection.isLgConnected) {
//                                 List<KMLModel> kmlBalloons =
//                                     await buildQueryTour(
//                                         context, query, places);
//                                 dialogBuilder(
//                                     context,
//                                     'Are you sure you want to start tour?',
//                                     // AppLocalizations.of(context)!
//                                     //     .lgTasks_notConnectedError,
//                                     false,
//                                     // 'OK',
//                                     AppLocalizations.of(context)!.defaults_yes,
//                                     () async {
//                                   setState(() {
//                                     _isTourOn = true;
//                                   });

//                                   await LgService(sshData)
//                                       .startTour('App Tour');
//                                   for (int i = 0; i < kmlBalloons.length; i++) {
//                                     if (_isTourOn) {
//                                       print('tour is on');
//                                       print('new kml balloon');
//                                       await LgService(sshData).sendKMLToSlave(
//                                         LgService(sshData).balloonScreen,
//                                         kmlBalloons[i].body,
//                                       );
//                                       await Future.delayed(
//                                           Duration(seconds: 60));
//                                     } else {
//                                       break;
//                                     }
//                                   }
//                                 }, null);
//                               } else {
//                                 dialogBuilder(
//                                     context,
//                                     // 'NOT connected to LG !! \n Please Connect to LG',
//                                     AppLocalizations.of(context)!
//                                         .lgTasks_notConnectedError,
//                                     true,
//                                     // 'OK',
//                                     AppLocalizations.of(context)!.defaults_ok,
//                                     null,
//                                     null);
//                               }
//                             },
//                             height: MediaQuery.of(context).size.height * 0.07,
//                             width: MediaQuery.of(context).size.width * 0.165,
//                             fontSize: textSize,
//                             // fontSize: fontVal.fonts.textSize,
//                             fontColor: FontAppColors.primaryFont,
//                             isLoading: false,
//                             isBold: true,
//                             isPrefixIcon: true,
//                             prefixIcon: Icons.play_arrow_outlined,
//                             prefixIconColor: FontAppColors.primaryFont,
//                             prefixIconSize: 30,
//                             isSuffixIcon: false,
//                             borderColor: FontAppColors.primaryFont,
//                             borderWidth: 2,
//                             curvatureRadius: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.01,
//                           ),
//                           LgElevatedButton(
//                             // elevatedButtonContent: 'Stop Tour',
//                             elevatedButtonContent: AppLocalizations.of(context)!
//                                 .visualizationDialog_stopTour,
//                             buttonColor: SettingsSharedPref.getTheme() == 'dark'
//                                 ? colorVal.colors.midShadow
//                                 : FontAppColors.secondaryFont,
//                             onpressed: () async {
//                               final sshData = Provider.of<SSHprovider>(context,
//                                   listen: false);

//                               Connectionprovider connection =
//                                   Provider.of<Connectionprovider>(context,
//                                       listen: false);

//                               ///checking the connection status first
//                               if (sshData.client != null &&
//                                   connection.isLgConnected) {
//                                 dialogBuilder(
//                                     context,
//                                     'Are you sure you want to stop tour?',
//                                     // AppLocalizations.of(context)!
//                                     //     .lgTasks_notConnectedError,
//                                     false,
//                                     // 'OK',
//                                     AppLocalizations.of(context)!.defaults_yes,
//                                     () async {
//                                   await LgService(sshData).stopTour();
//                                   setState(() {
//                                     _isTourOn = false;
//                                   });
//                                   await LgService(sshData).clearKml();
//                                 }, null);
//                               } else {
//                                 dialogBuilder(
//                                     context,
//                                     // 'NOT connected to LG !! \n Please Connect to LG',
//                                     AppLocalizations.of(context)!
//                                         .lgTasks_notConnectedError,
//                                     true,
//                                     // 'OK',
//                                     AppLocalizations.of(context)!.defaults_ok,
//                                     null,
//                                     null);
//                               }
//                             },
//                             height: MediaQuery.of(context).size.height * 0.07,
//                             width: MediaQuery.of(context).size.width * 0.165,
//                             fontSize: textSize,
//                             // fontSize: fontVal.fonts.textSize,
//                             fontColor: FontAppColors.primaryFont,
//                             isLoading: false,
//                             isBold: true,
//                             isPrefixIcon: true,
//                             prefixIcon: Icons.stop_outlined,
//                             prefixIconColor: FontAppColors.primaryFont,
//                             prefixIconSize: 30,
//                             isSuffixIcon: false,
//                             borderColor: FontAppColors.primaryFont,
//                             borderWidth: 2,
//                             curvatureRadius: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.01,
//                           ),
//                           LgElevatedButton(
//                             elevatedButtonContent: 'Narrate',
//                             // elevatedButtonContent: AppLocalizations.of(context)!
//                             //     .visualizationDialog_PrepTour,
//                             buttonColor: SettingsSharedPref.getTheme() == 'dark'
//                                 ? colorVal.colors.midShadow
//                                 : FontAppColors.secondaryFont,
//                             onpressed: () async {},
//                             height: MediaQuery.of(context).size.height * 0.07,
//                             width: MediaQuery.of(context).size.width * 0.165,
//                             fontSize: textSize,
//                             // fontSize: fontVal.fonts.textSize,
//                             fontColor: FontAppColors.primaryFont,
//                             isLoading: false,
//                             isBold: true,
//                             isPrefixIcon: true,
//                             prefixIcon: Icons.speaker_notes,
//                             prefixIconColor: FontAppColors.primaryFont,
//                             prefixIconSize: 30,
//                             isSuffixIcon: false,
//                             borderColor: FontAppColors.primaryFont,
//                             borderWidth: 2,
//                             curvatureRadius: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.01,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.05,
//                               ),
//                               FavIcon(
//                                 iconSize: fontVal.fonts.textSize + 40,
//                                 query: query,
//                                 places: places,
//                                 city: city ?? '',
//                                 country: country ?? '',
//                                 onItemRemoved: onItemRemoved,
//                                 fromFav: fromFav,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 content: SizedBox(
//                   width: MediaQuery.of(context).size.width * 1,
//                   height: MediaQuery.of(context).size.height * 1,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SingleChildScrollView(
//                         child: Consumer<SearchProvider>(
//                           builder: (BuildContext context, SearchProvider value,
//                               Widget? child) {
//                             if (value.showMap) {
//                               return Column(children: [
//                                 GoogleMapWidget(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.65,
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.55,
//                                   initialLatValue: lat,
//                                   //places[0].latitude,
//                                   initialLongValue: long,
//                                   //places[0].longitude,
//                                   initialTiltValue: 41.82725143432617,
//                                   initialBearingValue: 61.403038024902344,
//                                   initialCenterValue: LatLng(lat, long),
//                                   //LatLng(places[0].latitude, places[0].longitude),
//                                   query: query,
//                                 ),
//                               ]);
//                             } else {
//                               return Container(
//                                 width: MediaQuery.of(context).size.width * 0.65,
//                                 child: SearchResultsContainer(),
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.02,
//                       ),
//                       AppDividerWidget(
//                           height: MediaQuery.of(context).size.height * 0.6),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.02,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Consumer<FontsProvider>(
//                               builder: (BuildContext context,
//                                   FontsProvider value, Widget? child) {
//                                 return Text(
//                                   // 'List of POIs',
//                                   AppLocalizations.of(context)!
//                                       .visualizationDialog_listofPois,
//                                   style: TextStyle(
//                                       // color: FontAppColors.primaryFont,
//                                       color: value.fonts.primaryFontColor,

//                                       // fontSize: textSize + 4,
//                                       fontSize: fontVal.fonts.textSize + 4,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: fontType),
//                                 );
//                               },
//                             ),
//                             const Divider(
//                               color: FontAppColors.primaryFont,
//                               thickness: 0.5,
//                             ),
//                             Expanded(
//                               child: ListView.builder(
//                                 itemCount: places.length,
//                                 itemBuilder: (context, index) {
//                                   final placeModel = places[index];
//                                   return Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       PoiExpansionWidget(
//                                         placeModel: placeModel,
//                                         index: index,
//                                         query: query,
//                                       ),
//                                       Divider(
//                                         color: FontAppColors.primaryFont,
//                                         thickness: 0.5,
//                                       )
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Consumer2<SearchProvider, ColorProvider>(
//                       builder: (BuildContext context, SearchProvider value,
//                           ColorProvider colorProv, Widget? child) {
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             if (!value.showMap)
//                               LgElevatedButton(
//                                 // elevatedButtonContent: 'Map',
//                                 elevatedButtonContent:
//                                     AppLocalizations.of(context)!
//                                         .visualizationDialog_mapButton,
//                                 // buttonColor: PrimaryAppColors.buttonColors,
//                                 buttonColor: colorProv.colors.buttonColors,
//                                 onpressed: () {
//                                   Provider.of<SearchProvider>(context,
//                                           listen: false)
//                                       .showMap = true;
//                                 },
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.035,
//                                 width: MediaQuery.of(context).size.width * 0.1,
//                                 // fontSize: textSize,
//                                 fontSize: fontVal.fonts.textSize,
//                                 fontColor: FontAppColors.secondaryFont,
//                                 isLoading: false,
//                                 isBold: false,
//                                 isPrefixIcon: false,
//                                 isSuffixIcon: false,
//                                 curvatureRadius: 30,
//                               ),
//                             if (!value.showMap)
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.02,
//                               ),
//                             LgElevatedButton(
//                               // elevatedButtonContent: 'Close',
//                               elevatedButtonContent:
//                                   AppLocalizations.of(context)!.defaults_close,
//                               // buttonColor: PrimaryAppColors.buttonColors,
//                               buttonColor: colorProv.colors.buttonColors,
//                               onpressed: () async {
//                                 SSHprovider sshData = Provider.of<SSHprovider>(
//                                     context,
//                                     listen: false);
//                                 await LgService(sshData).clearKml();
//                                 await buildAppBalloonOverlay(context);
//                                 //value.showMap = true;
//                                 while (Navigator.of(context).canPop()) {
//                                   Navigator.of(context).pop();
//                                 }
//                               },
//                               height:
//                                   MediaQuery.of(context).size.height * 0.035,
//                               width: MediaQuery.of(context).size.width * 0.1,
//                               // fontSize: textSize,
//                               fontSize: fontVal.fonts.textSize,
//                               fontColor: FontAppColors.secondaryFont,
//                               isLoading: false,
//                               isBold: false,
//                               isPrefixIcon: false,
//                               isSuffixIcon: false,
//                               curvatureRadius: 30,
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                     onPressed: () {
//                       // Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }
