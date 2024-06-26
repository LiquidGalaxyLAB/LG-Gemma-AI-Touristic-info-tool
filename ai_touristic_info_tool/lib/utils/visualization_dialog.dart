
import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/app_divider_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_map_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void showVisualizationDialog(BuildContext context, List<PlacesModel> places, String query) {
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
                    onpressed: () {},
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
                    onpressed: () {},
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
                      initialLatValue: places[0].latitude,
                      initialLongValue: places[0].longitude,
                      initialTiltValue: 41.82725143432617,
                      initialBearingValue: 61.403038024902344,
                      initialCenterValue:
                          LatLng(places[0].latitude, places[0].longitude),
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
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
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
                                  const Icon(Icons.airplanemode_active_outlined,
                                      color: FontAppColors.primaryFont,
                                      size: textSize + 4),
                                ],
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
              onpressed: () {
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
