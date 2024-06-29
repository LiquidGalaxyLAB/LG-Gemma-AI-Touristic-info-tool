import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/kml/KMLModel.dart';
import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/models/kml/orbit_model.dart';
import 'package:ai_touristic_info_tool/models/kml/placemark_model.dart';
import 'package:ai_touristic_info_tool/models/kml/point_model.dart';
import 'package:ai_touristic_info_tool/models/kml/tour_model.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String escapeHtml(String input) {
  return input
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}

buildAppBalloon(BuildContext context, {visibility = true}) async {
  final sshData = Provider.of<SSHprovider>(context, listen: false);
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
              <h1>Welcome to LG Gemma AI Touristic Info Tool!</h1>
              </div>

              <div style="text-align:justify;">
                  <pp>Prepare to be inspired by discovering the most captivating POIs tailored to your preference.</pp>
              </div>

              <div class="details">
                <p><b>Contributor:</b> Mahinour Elsarky</p>
                <p><b>Organization:</b> Liquid Galaxy Project</p>
                <p><b>Main-Mentors:</b> Claudia Diosan , Andreu Ibanez</p>
                <p><b>Co-Mentors:</b> Emilie Ma ,  Irene</p>
                <p><b>Listener Contributors:</b> Vertika Bajpai</p>
              </div>
            


           
        </div>
''';

  LookAtModel lookAt = LookAtModel(
    longitude: 0.0000101,
    latitude: 0.0000101,
    range: '31231212.86',
    tilt: '0',
    altitude: 50000.1097385,
    heading: '0',
    altitudeMode: 'relativeToSeaFloor',
  );

  PlacemarkModel placemark = PlacemarkModel(
    id: 'home',
    name: 'home',
    styleId: 'placemark-style',
    description: 'App Start up',
    balloonContent: balloonContent,
    visibility: visibility,
    lookAt: lookAt,
    viewOrbit: false,
  );

  final kmlBalloon = KMLModel(
    name: 'home-balloon',
    content: placemark.balloonOnlyTag,
  );

  try {
    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );
    await LgService(sshData).flyTo(lookAt);
  } catch (e) {
    print(e);
  }
}

buildQueryPlacemark(
    String query, String? city, String? country, BuildContext context,
    {visibility = true}) async {
  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String countryCode = countryMap[country] ?? 'None';
  String countryFlagImg;

  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";
  } else {
    countryFlagImg = '';
  }
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
              <h2>$city</h2>
              <h2>$country</h2>
            </div>

            <div style="text-align:center;">
              <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
            </div>
        </div>
''';

  PlacemarkModel placemark = PlacemarkModel(
    id: 'query-$city',
    name: 'query-$city',
    styleId: 'placemark-style',
    description: '$query , $city , $country',
    balloonContent: balloonContent,
    visibility: visibility,
    viewOrbit: false,
  );

  final kmlBalloon = KMLModel(
    name: '$city-balloon',
    content: placemark.balloonOnlyTag,
  );

  try {
    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );
  } catch (e) {
    print(e);
  }
}

buildPlacePlacemark(
    PlacesModel place, int index, String query, BuildContext context,
    {visibility = true, viewOrbit = true}) async {
  print('inside placemark');
  final sshData = Provider.of<SSHprovider>(context, listen: false);

  String content = '';

  String placeName = escapeHtml(place.name);
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
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";
  } else {
    countryFlagImg = '';
  }

  String icon =
      "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true";
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
    tilt: '60',
    altitude: 0,
    heading: '0',
    altitudeMode: 'relativeToGround',
  );

  PointModel point =
      PointModel(lat: placeLatitude, lng: placeLongitude, altitude: 0);
  LookAtModel lookAtObjOrbit = LookAtModel(
    longitude: placeLongitude,
    latitude: placeLatitude,
    range: '500',
    tilt: '90',
    altitude: 0,
    heading: '0',
    altitudeMode: 'relativeToGround',
  );
  String orbitContent = OrbitModel.tag(lookAtObjOrbit);
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
      point: point,
      orbitContent: orbitContent);

  content += placemark.tag;

  final kmlBalloon = KMLModel(
    name: '$placeName-balloon',
    content: placemark.balloonOnlyTag,
  );

  final kmlPlacemark = KMLModel(
    name: '$placeName-pin',
    content: content,
  );

  try {
    await LgService(sshData).sendKmlPlacemarks(kmlPlacemark.body, placeName);
    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );
    await LgService(sshData).flyTo(lookAt);
  } catch (e) {
    print(e);
  }
}

buildShowPois(List<PlacesModel> pois, BuildContext context, double lat,
    double long, String? city, String? country, String query) async {
  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String content = '';
  String icon =
      "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true";
  String countryCode = countryMap[country] ?? 'None';
  String countryFlagImg;

  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";
  } else {
    countryFlagImg = '';
  }

  int poisLength = pois.length;

  String placesBalloonContent = '';

  for (int i = 0; i < poisLength; i++) {
    int index = i + 1;
    String name = escapeHtml(pois[i].name);
    placesBalloonContent += '''
             <div class="details">
                <p>$index. $name</p>
              </div>
''';
  }

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
                <h2>$city</h2>
                <h2>$country</h2>
              </div>

              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>

              
              <div style="text-align:center;">
                <pp>Top $poisLength POIs</pp>
              </div>

              $placesBalloonContent
          </div>
''';

  LookAtModel lookAt = LookAtModel(
    longitude: long,
    latitude: lat,
    range: '10000',
    tilt: '45',
    altitude: 0,
    heading: '0',
    altitudeMode: 'relativeToGround',
  );
  String styleId = 'placemark-style';
  double scale = 1;

  String styleTag = '''
<Style id="$styleId">
    <IconStyle id="mystyle">
      <Icon>
        <href>$icon</href>
        <scale>$scale</scale>
      </Icon>
    </IconStyle>
  </Style>
''';

  content += styleTag;

  for (PlacesModel poi in pois) {
    PointModel point =
        PointModel(lat: poi.latitude, lng: poi.longitude, altitude: 0);
    PlacemarkModel placemark = PlacemarkModel(
      id: poi.name,
      name: poi.name,
      styleId: styleId,
      description: poi.description ?? '',
      icon: icon,
      scale: scale,
      lookAt: lookAt,
      point: point,
    );

    content += placemark.placemarkOnlyTag;
  }
  final kmlPlacemark = KMLModel(
    name: 'POIs-pins',
    content: content,
  );

  String balloonTag = '''
 <Style id="balloon-POIs">
      <BalloonStyle>
        <bgColor>000000</bgColor>
        <text><![CDATA[
         <html>
          <body style="font-family: montserrat, sans-serif; font-size: 18px; width: 400px; display: flex; justify-content: center; align-items: center;">
            <div style="background-color: #ffffff; padding: 10px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);">
              <span style="color: black;">$balloonContent</span> <!-- Content of the balloon with red color -->
            </div>
          </body>
        </html>
        ]]></text>
      </BalloonStyle>
      <LabelStyle>
        <scale>0</scale>
      </LabelStyle>
      <IconStyle>
        <scale>0</scale>
      </IconStyle>
    </Style>
    <Placemark>
      <name>POIs-Balloon</name>
      <styleUrl>#balloon-POIs</styleUrl>
      <gx:balloonVisibility>${balloonContent.isEmpty ? 0 : 1}</gx:balloonVisibility>
    </Placemark>
''';
  final kmlBalloon = KMLModel(
    name: 'home-balloon',
    content: balloonTag,
  );
  try {
    await LgService(sshData).flyTo(lookAt);
    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );
    await LgService(sshData).sendKmlPlacemarks(kmlPlacemark.body, 'POIs');
  } catch (e) {
    print(e);
  }
}

buildQueryTour(
    BuildContext context, String query, List<PlacesModel> pois) async {
  List<LookAtModel> lookAts = [];
  List<String> ballonContents = [];
  List<String> poisNames = [];

  for (int i = 0; i < pois.length; i++) {
    String placeName = pois[i].name;
    poisNames.add(placeName);
    LookAtModel lookAt = LookAtModel(
      longitude: pois[i].longitude,
      latitude: pois[i].latitude,
      range: '10000',
      tilt: '45',
      altitude: 0,
      heading: '0',
      altitudeMode: 'relativeToGround',
    );
    lookAts.add(lookAt);
    String countryFlagImg;
    String countryCode = countryMap[pois[i].country] ?? 'None';
    if (countryCode != 'None') {
      String cc = countryCode.toLowerCase();
      countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";
    } else {
      countryFlagImg = '';
    }
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
                <h1> ${i + 1}. ${escapeHtml(pois[i].name)}</h1>
              </div>

              <div style="text-align:center;">
                <h2>${escapeHtml(pois[i].city ?? '')}</h2>
                <h2>${escapeHtml(pois[i].country ?? '')}</h2>
              </div>

              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>

              <div style="text-align:justify;">
                <pp>${escapeHtml(pois[i].description ?? '')}</pp>
              </div>

              <div class="details">
                <p><b>Address:</b>${escapeHtml(pois[i].address)}</p>
                <p><b>Average Ratings:</b>${pois[i].ratings ?? ''}</p>
                <p><b>Pricing:</b>${escapeHtml(pois[i].price ?? '')}</p>
                <p><b>Amenities:</b>${escapeHtml(pois[i].amenities ?? '')}</p>
              </div>
          </div>
''';
    ballonContents.add(balloonContent);
  }

  TourModel tour = TourModel(
    name: 'app-tour',
    numberOfPlaces: pois.length,
    lookAtCoordinates: lookAts,
    ballonContentOfPlacemarks: ballonContents,
    poisNames: poisNames,
  );

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  final kmlPlacemark = KMLModel(
    name: 'app-tour',
    content: tour.tourTag(),
  );
  try {
    await LgService(sshData).sendKmlPlacemarks(kmlPlacemark.body, 'app-tour');
  } catch (e) {
    print(e);
  }
}
