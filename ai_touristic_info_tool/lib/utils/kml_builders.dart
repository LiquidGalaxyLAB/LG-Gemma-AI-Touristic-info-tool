import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/kml/KMLModel.dart';
import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/models/kml/placemark_model.dart';
import 'package:ai_touristic_info_tool/models/kml/point_model.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

buildPlacePlacemark(
    PlacesModel place, int index, String query, BuildContext context,
    {visibility = true, viewOrbit = true}) async {
  final sshData = Provider.of<SSHprovider>(context, listen: false);

  String content = '';

  String placeName = place.name;
  String placeDescription = place.description ?? '';
  String placeAddress = place.address;
  String placeCity = place.city ?? '';
  String placeCountry = place.country ?? '';
  String placeAmenities = place.amenities ?? '';
  String placePrices = place.price ?? '\$\$';
  double placesRating = place.ratings ?? 0;
  double placeLatitude = place.latitude;
  double placeLongitude = place.longitude;

  String countryCode = countryMap[placeCountry] ?? 'None';
  String countryFlagImg;

  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = 'https://www.worldometers.info/img/flags/$cc-flag.gif';
  } else {
    countryFlagImg = '';
  }

  String icon =
      'https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true';
  String balloonContent = '''
 <style>
            .balloon {
              background: linear-gradient(135deg, #243558 5%, #4F73BF 15%, #6988C9 60%, #8096C5 100%);
              color: white;
              padding: 10px;
              border-radius: 20px;
              font-family: Montserrat, sans-serif;
            }
            .balloon h1 {
              font-size: 24px;
              color: #ffff;
            }
            .balloon h2 {
              font-size: 20px;
              color: #ffff;
            }
            
            .balloon pp{
              font-size: 18px;
              color: #ffff;
            }
            .balloon p {
              font-size: 14px;
              color: #ffff;
            }
            .balloon b {
              color: #ffff;
            }
            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
            }
           .container-logo {
            width: 100px; 
            height: 50px;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            margin: auto; 
          }
          .logo img {
            max-width: 100%; /* Ensure image fits within container */
            max-height: 100%; /* Ensure image fits within container */
            display: block;
            margin: auto;
            border-radius: 10px; /* Optional rounded corners for the image */
          }
          </style>
        
          <div class="balloon">
              <div class="container-logo">
              <div class="logo">
                <img src="https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/appLogo.png?raw=true" alt="Logo Image"/>
              </div>
            </div>
            <div style="text-align:center;">
              <h1>$query</h1>
            </div>
            <div style="text-align:center;">
              <h1> $index. $placeName</h1>
            </div>
            <div style="text-align:center;">
              <h2>$placeCity</h2>
              <h2>$placeCountry</h2>
            </div>
             <div style="text-align:center;">
              <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
            </div>
             <div style="text-align:justify;">
              <pp>$placeDescription</pp>
            </div>
            <div class="details">
              <p><b>Address:</b>$placeAddress</p>
              <p><b>Average Ratings:</b>$placesRating</p>
              <p><b>Pricing:</b>$placePrices</p>
              <p><b>Amenities:</b>$placeAmenities</p>
            </div>
          </div>
''';

  LookAtModel lookAt = LookAtModel(
    longitude: placeLongitude,
    latitude: placeLatitude,
    range: '500',
    tilt: '45',
    altitude: 1000,
    heading: '0',
    altitudeMode: 'relativeToGround',
  );

  PointModel point =
      PointModel(lat: placeLatitude, lng: placeLongitude, altitude: 1000);

  PlacemarkModel placemark = PlacemarkModel(
      id: placeName,
      name: placeName,
      styleId: 'placemark-style',
      description: placeDescription,
      icon: icon,
      balloonContent: balloonContent,
      visibility: visibility,
      viewOrbit: viewOrbit,
      scale: 1,
      lookAt: lookAt,
      point: point);

  content += placemark.tag;

  final kmlPlacemark = KMLModel(
    name: 'places-pins',
    content: content,
  );

  try {
    await LgService(sshData).sendKmlPlacemarks(kmlPlacemark.body, 'placePin');
  } catch (e) {
    print(e);
  }
}

buildPlacemarks(List<PlacemarkModel> placemarks, BuildContext context) async {
  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String content = '';
  content += placemarks[0].styleTag;
  for (PlacemarkModel placemark in placemarks) {
    content += placemark.placemarkOnlyTag;
  }
  final kmlPlacemark = KMLModel(
    name: 'places-pins',
    content: content,
  );

  try {
    await LgService(sshData).sendKmlPlacemarks(kmlPlacemark.body, 'placePin');
  } catch (e) {
    print(e);
  }
}

// buildLocationBallon(String animalName, String cityName, String countryName,
//     BuildContext context) async {
//   final sshData = Provider.of<SSHprovider>(context, listen: false);

//   final placemark = PlacemarkModel(
//     id: ' $animalName-query-facts',
//     name: ' $animalName-query-facts',
//     balloonContent: '''
//     <div style="text-align:center;">
//       <b><font size="+3"> 'Discover more about $animalName' <font color="#5D5D5D"></font></font></b>
//       </div>
//       <br/><br/>
//       <p>$animalName can be found in $cityName , $countryName</p>
//       <br/>
//     ''',
//   );
//   final kmlBalloon = KMLModel(
//     name: '$animalName-query-balloon',
//     content: placemark.balloonOnlyTag,
//   );

//   try {
//     /// sending kml to slave where we send to `balloon screen` and send the `kml balloon ` body
//     await LgService(sshData).sendKMLToSlave(
//       LgService(sshData).balloonScreen,
//       kmlBalloon.body,
//     );
//   } catch (e) {
//     // ignore: avoid_print
//     print(e);
//   }
// }
