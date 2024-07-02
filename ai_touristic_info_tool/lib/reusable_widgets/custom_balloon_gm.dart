import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:flutter/material.dart';

class CustomBalloonGoogleMaps extends StatelessWidget {
  final double pinPillPosition;
  final PlacesModel poi;
  final String query;
  const CustomBalloonGoogleMaps({
    super.key,
    required this.pinPillPosition,
    required this.poi,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    String countryCode = countryMap[poi.country] ?? 'None';
    String countryFlagImg;

    if (countryCode != 'None') {
      String cc = countryCode.toLowerCase();
      countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";
    } else {
      countryFlagImg = '';
    }
    return AnimatedPositioned(
      top: pinPillPosition,
      //mapProvider.pinPillPosition,
      right: MediaQuery.of(context).size.width * 0.4,
      left: 0,
      duration: const Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset.zero,
                    color: Colors.grey.withOpacity(0.5))
              ]),
          child: Container(
            margin: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    PrimaryAppColors.gradient1,
                    PrimaryAppColors.gradient2,
                    PrimaryAppColors.gradient3,
                    PrimaryAppColors.gradient4,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * 0.08,
                  //     width: MediaQuery.of(context).size.width * 0.1,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       color: FontAppColors.secondaryFont,
                  //       image: const DecorationImage(
                  //         image: AssetImage('assets/images/appLogo.png'),
                  //         fit: BoxFit.scaleDown,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Text(query,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: textSize + 8,
                  //         fontWeight: FontWeight.bold,
                  //         fontFamily: fontType)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    //'${mapProvider.currentlySelectedPin.id}. ${mapProvider.currentlySelectedPin.name}',
                    '${poi.id}. ${poi.name}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize + 5,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontType,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    '${poi.city}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontType,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    '${poi.country}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize + 2,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontType,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  if (countryFlagImg != '')
                    Image.network(
                      countryFlagImg,
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    '${poi.description}',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize,
                      fontFamily: fontType,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: FontAppColors.secondaryFont,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Address: ',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: poi.address,
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Avg. Ratings: ',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${poi.ratings}',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Pricing: ',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${poi.price}',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Amenities: ',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${poi.amenities}',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
