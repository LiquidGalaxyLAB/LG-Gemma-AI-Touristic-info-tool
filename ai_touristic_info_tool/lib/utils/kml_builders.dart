import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/kml/KMLModel.dart';
import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/models/kml/orbit_model.dart';
import 'package:ai_touristic_info_tool/models/kml/placemark_model.dart';
import 'package:ai_touristic_info_tool/models/kml/point_model.dart';
import 'package:ai_touristic_info_tool/models/kml/screen_overlay_model.dart';
import 'package:ai_touristic_info_tool/models/kml/tour_model.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

/// Escapes HTML special characters in the input string.
String escapeHtml(String input) {
  return input
      .replaceAll('&', 'and')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}

/// Builds and sends an app balloon overlay to Liquid Galaxy setup.
buildAppBalloonOverlay(BuildContext context) async {
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  // String appLogoGemma =
  //     'https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/appLogo-Gemma.png?raw=true';
  String appLogoGemini =
      'https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/appLogo-Gemini.png?raw=true';
  String balloonContent = '''
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
      .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
              color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
            }    
        
      
        .balloon b {
            color: #ffff;
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
            max-width: 100%;
            max-height: 100%;
            display: block;
            margin: auto;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="balloon">
        <div class="container-logo">
            <div class="logo">
                <img src="$appLogoGemini" alt="Logo Image"/>
            </div>
        </div>

        <div style="text-align:center;">
            <h1>Welcome to LG Gemini AI Touristic Info Tool!</h1>
        </div>

        <br>

        <div style="text-align:justify;">
            <pp>Prepare to be inspired by discovering the most captivating POIs tailored to your preference.</pp>
        </div>

        <div class="details">
            <p><b>Contributor:</b> Mahinour Elsarky</p>
            <p><b>Organization:</b> Liquid Galaxy Project</p>
            <p><b>Main-Mentors:</b> Claudia Diosan , Andreu Ibanez</p>
            <p><b>Co-Mentors:</b> Emilie Ma , Irene</p>
            <p><b>Listener Contributors:</b> Vertika Bajpai</p>
        </div>
    </div>
</body>
</html>
    ''';

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 1,
    screenY: 1,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );

  String kmlName = 'App-Balloon';
  String content = '<name>AppBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: content,
    screenOverlay: screenOverlay.balloonTag,
  );

  LookAtModel lookAt = LookAtModel(
    longitude: 0.0000101,
    latitude: 0.0000101,
    range: '31231212.86',
    tilt: '0',
    altitude: 50000.1097385,
    heading: '0',
    altitudeMode: 'relativeToSeaFloor',
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

buildWebsiteLinkBallon(String placeName, String? city, String? country,
    double lat, double long, String webLink, BuildContext context,
    {visibility = true}) async {
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String countryCode = countryMap[country] ?? 'None';
  String countryFlagImg;

  String flagDiv;
  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

    flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>
''';
  } else {
    countryFlagImg = '';
    flagDiv = '<br>';
  }
  city ??= '';
  country ??= 'World Wide';

  String balloonContent = '''
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
            .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
              color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
            }    
             .balloon linkp{
              font-size:  ${textSize}px;
              color: blue;
              text-decoration: underline; 
            }
           
            .balloon b {
              color: #ffff;
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
</head>
<body>  
        
        <div class="balloon">
        
              <div style="text-align:center;">
                <h2> ${escapeHtml(placeName)}</h2>
              </div>

              <div style="text-align:center;">
                <h3>${escapeHtml(city)}</h3>
                <h3>${escapeHtml(country)}</h3>
              </div>

              $flagDiv

            <iframe width="800" height="600" src="$webLink" frameborder="0"></iframe>

        </div>
</body>
</html>
''';

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 1,
    screenY: 1,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );

  String kmlName = 'Website-Balloon';
  String content = '<name>WebsiteBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: content,
    screenOverlay: screenOverlay.balloonTag,
  );

  LookAtModel lookAt = LookAtModel(
    longitude: long,
    latitude: lat,
    range: '500',
    tilt: '60',
    altitude: 0,
    heading: '0',
    altitudeMode: 'relativeToGround',
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

buildYoutubeLinkBallon(String placeName, String? city, String? country,
    double lat, double long, String vidId, BuildContext context,
    {visibility = true}) async {
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String countryCode = countryMap[country] ?? 'None';
  String countryFlagImg;

  String flagDiv;
  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

    flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>
''';
  } else {
    countryFlagImg = '';
    flagDiv = '<br>';
  }
  city ??= '';
  country ??= 'World Wide';

  String balloonContent = '''
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style> 
         .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
              color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
            }    
           
             .balloon linkp{
             font-size:  ${textSize}px;
              color: blue;
              text-decoration: underline; 
            }
          
            .balloon b {
              color: #ffff;
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
</head>
<body>
        
        <div class="balloon">
        
              <div style="text-align:center;">
                <h2> ${escapeHtml(placeName)}</h2>
              </div>

              <div style="text-align:center;">
                <h3>${escapeHtml(city)}</h3>
                <h3>${escapeHtml(country)}</h3>
              </div>

              $flagDiv


                <iframe width="560" height="315" src="https://www.youtube.com/embed/$vidId?autoplay=1" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

        </div>
</body>
  </html>
''';

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 1,
    screenY: 1,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );

  String kmlName = 'Youtube-Balloon';
  String content = '<name>YoutubeBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: content,
    screenOverlay: screenOverlay.balloonTag,
  );

  LookAtModel lookAt = LookAtModel(
    longitude: long,
    latitude: lat,
    range: '500',
    tilt: '60',
    altitude: 0,
    heading: '0',
    altitudeMode: 'relativeToGround',
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

buildAllLinksBalloon(String placeName, String? city, String? country,
    double lat, double long, List<String> links, BuildContext context,
    {visibility = true}) async {
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String countryCode = countryMap[country] ?? 'None';
  String countryFlagImg;

  String flagDiv;
  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

    flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>
''';
  } else {
    countryFlagImg = '';
    flagDiv = '<br>';
  }
  city ??= '';
  country ??= 'World Wide';
  String linkDetails = '';
  for (String link in links) {
    linkDetails += '<p><b>Link</b></p>';
    linkDetails += '<linkp>- $link</linkp>';
    linkDetails += '<br>';
  }
  String balloonContent = '''
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
             .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
              color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
            }    
        
             .balloon linkp{
               font-size:  ${textSize}px;
              color: blue;
              text-decoration: underline; 
            }
          
            .balloon b {
              color: #ffff;
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
</head>
<body>
        
        <div class="balloon">
        
              <div style="text-align:center;">
                <h2> ${escapeHtml(placeName)}</h2>
              </div>

              <div style="text-align:center;">
                <h3>${escapeHtml(city)}</h3>
                <h3>${escapeHtml(country)}</h3>
              </div>

              $flagDiv

              <div style="text-align:justify;">
                <pp>Website & Youtube Links</pp>
              </div>

              <div class="details">
                $linkDetails
              </div>
      
           
        </div>
</body>
  </html>
''';

  LookAtModel lookAt = LookAtModel(
    longitude: long,
    latitude: lat,
    range: '500',
    tilt: '60',
    altitude: 0,
    heading: '0',
    altitudeMode: 'relativeToGround',
  );

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 1,
    screenY: 1,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );
  String kmlName = 'AllLinks-Balloon';
  String content = '<name>LinksBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: content,
    screenOverlay: screenOverlay.balloonTag,
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
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String countryCode = countryMap[country] ?? 'None';
  String countryFlagImg;

  String flagDiv;
  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

    flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>
''';
  } else {
    countryFlagImg = '';
    flagDiv = '<br>';
  }
  city ??= '';
  country ??= 'World Wide';
  String balloonContent = '''
        <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
             .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
             color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
            }    
            .balloon b {
              color: #ffff;
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
</head>
<body>
          <div class="balloon">

            <div style="text-align:center;">
              <h1>$query</h1>
            </div>

            <br>

            <div style="text-align:center;">
              <h2>$city</h2>
              <h2>$country</h2>
            </div>

            $flagDiv
        </div>
</body>
</html>
''';

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 1,
    screenY: 1,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );
  String kmlName = 'query-Balloon';
  String content = '<name>QueryBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: content,
    screenOverlay: screenOverlay.balloonTag,
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
    {visibility = true, viewOrbit = true, double duration = 1.2}) async {
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  print('inside placemark');
  String indx = '';
  if (index != -1) {
    indx = index.toString();
  }
  final sshData = Provider.of<SSHprovider>(context, listen: false);

  String content = '';

  String placeName = escapeHtml(place.name);
  String placeDescription = escapeHtml(place.description ?? '');
  String placeAddress = escapeHtml(place.address);
  String placeCity = escapeHtml(place.city ?? '');
  String placeCountry = escapeHtml(place.country ?? '');
  String placeAmenities = escapeHtml(place.amenities ?? '');
  String placePrices = escapeHtml(place.price ?? '\$\$');
  double placesRating = place.ratings ?? 0;
  double placeLatitude = place.latitude;
  double placeLongitude = place.longitude;
  String placeLink = escapeHtml(place.sourceLink ?? '');

  String countryCode = countryMap[placeCountry] ?? 'None';
  String countryFlagImg;
  String flagDiv;

  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

    flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>
''';
  } else {
    countryFlagImg = '';
    flagDiv = '<br>';
  }

  String icon =
      "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true";
  String balloonContent = '''
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
             .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
              color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
            }    
            .balloon b {
              color: #ffff;
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
</head>
<body>
        
          <div class="balloon">

              <div style="text-align:center;">
                <h1>$query</h1>
              </div>

            <br>

              <div style="text-align:center;">
                <h2> $indx. $placeName</h2>
              </div>

              <div style="text-align:center;">
                <h3>$placeCity</h3>
                <h3>$placeCountry</h3>
              </div>

              $flagDiv

              <div style="text-align:justify;">
                <pp>$placeDescription</pp>
              </div>

              <div class="details">
                <p><b>Address:</b>$placeAddress</p>
                <p><b>Average Ratings:</b>$placesRating</p>
                <p><b>Pricing:</b>$placePrices</p>
                <p><b>Amenities:</b>$placeAmenities</p>
                <p style="text-align: center;"><a href="$placeLink">source link</a></p>
              </div>
          </div>
</body>
</html>
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
  String orbitContent = OrbitModel.tag(lookAtObjOrbit, duration: duration);
  PlacemarkModel placemark = PlacemarkModel(
      id: place.id.toString(),
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
  print('Content: $content');
  print('Lat: $placeLatitude ,long: $placeLongitude ');

  final kmlPlacemark = KMLModel(
    name: '$placeName-pin',
    content: content,
  );

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 1,
    screenY: 1,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );

  String kmlName = 'place-Balloon';
  String ballooncontent = '<name>placeBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: ballooncontent,
    screenOverlay: screenOverlay.balloonTag,
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
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  String content = '';
  String icon =
      "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true";
  String countryCode = countryMap[country] ?? 'None';
  String countryFlagImg;

  String flagDiv;
  if (countryCode != 'None') {
    String cc = countryCode.toLowerCase();
    countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

    flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </ d iv>
''';
  } else {
    countryFlagImg = '';
    flagDiv = '<br>';
  }
  city ??= '';
  country ??= 'World Wide';

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
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
              .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
              color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
            }    
            .balloon b {
              color: #ffff;
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
</head>
<body>
          <div class="balloon">

             <div style="text-align:center;">
                <h1>$query</h1>
              </div>

              <br>

              <div style="text-align:center;">
                <h2>$city</h2>
                <h2>$country</h2>
              </div>

              $flagDiv

              
              <div style="text-align:center;">
                <pp>Top $poisLength POIs</pp>
              </div>

              $placesBalloonContent
          </div>
</body>
</html>
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

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 1,
    screenY: 1,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );

  String kmlName = 'POIs-Balloon';
  String content2 = '<name>POIsBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: content2,
    screenOverlay: screenOverlay.balloonTag,
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

Future<List<KMLModel>> buildQueryTour(
    BuildContext context, String query, List<PlacesModel> pois) async {
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  // String buttonColor =
  //     colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  List<LookAtModel> lookAts = [];
  List<String> ballonContents = [];
  List<String> poisNames = [];

  for (int i = 0; i < pois.length; i++) {
    String placeName = escapeHtml(pois[i].name);
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
    String flagDiv;
    if (countryCode != 'None') {
      String cc = countryCode.toLowerCase();
      countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

      flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>
''';
    } else {
      countryFlagImg = '';
      flagDiv = '<br></br>';
    }
    String balloonContent = '''
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
            .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
          
            .balloon pp{
              font-size: ${textSize}px;
              color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }

            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
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
</head>
<body>
          <div class="balloon">


              <div style="text-align:center;">
                <h1>$query</h1>
              </div>

              <br>

              <div style="text-align:center;">
                <h2> ${i + 1}. ${escapeHtml(pois[i].name)}</h2>
              </div>


              <div style="text-align:center;">
                <h3>${escapeHtml(pois[i].city ?? '')}</h3>
                <h3>${escapeHtml(pois[i].country ?? '')}</h3>
              </div>
      

              $flagDiv

              <div style="text-align:justify;">
                <pp>${escapeHtml(pois[i].description ?? '')}</pp>
              </div>

              <div class="details">
                <p><b>Address:</b>${escapeHtml(pois[i].address)}</p>
                <p><b>Average Ratings:</b>${pois[i].ratings ?? ''}</p>
                <p><b>Pricing:</b>${escapeHtml(pois[i].price ?? '')}</p>
                <p><b>Amenities:</b>${escapeHtml(pois[i].amenities ?? '')}</p>
                 <p style="text-align: center;"><a href="${escapeHtml(pois[i].sourceLink ?? '')}">source link</a></p>
              </div>
          </div>
</body>
</html>
''';
    ballonContents.add(balloonContent);
  }

  List<ScreenOverlayModel> screenOverlays = [];
  List<KMLModel> kmlBallonsList = [];
  for (int i = 0; i < pois.length; i++) {
    int index = i;
    ScreenOverlayModel screenOverlay = ScreenOverlayModel(
      overlayID: 'overlay-$index',
      name: "",
      overlayX: 0,
      overlayY: 1,
      screenX: 2,
      screenY: 2,
      sizeX: 0.5,
      sizeY: 0.5,
      content: ballonContents[i],
    );
    screenOverlays.add(screenOverlay);
    String kmlName = 'place-Balloon';
    String ballooncontent = '<name>placeBalloon</name>';

    final kmlBalloon = KMLModel(
      name: kmlName,
      content: ballooncontent,
      screenOverlay: screenOverlay.balloonTag,
    );
    kmlBallonsList.add(kmlBalloon);
  }


  String screenoverlayTags = '';

  for (int i = 0; i < screenOverlays.length; i++) {
    screenoverlayTags += screenOverlays[i].balloonTourTag;
  }

  TourModel tour = TourModel(
    name: 'app-tour',
    numberOfPlaces: pois.length,
    lookAtCoordinates: lookAts,
    poisNames: poisNames,
  );
  String kmlContent = screenoverlayTags + tour.tourTag();
  print(kmlContent);

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  final kmlPlacemark = KMLModel(name: 'app-tour', content: kmlContent);

  try {
    await LgService(sshData).sendKmlPlacemarks(kmlPlacemark.body, 'app-tour');
    return kmlBallonsList;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<double> buildCustomTour(
    BuildContext context, List<PlacesModel> pois) async {
  FontsProvider fonts = Provider.of<FontsProvider>(context, listen: false);
  ColorProvider colors = Provider.of<ColorProvider>(context, listen: false);
  double textSize = fonts.fonts.textSize;
  double titleSize = fonts.fonts.titleSize;
  double headSize = fonts.fonts.headingSize;

  String primaryColor;

  if (SettingsSharedPref.getTheme() == 'light') {
    print('light');
    primaryColor = 'black';
  } else {
    print('dark');
    primaryColor = 'white';
  }

  print('primaryColor');
  print(primaryColor);
  String buttonColor =
      colors.colors.buttonColors.toHexString(enableAlpha: false).substring(2);
  String grad1 =
      colors.colors.gradient1.toHexString(enableAlpha: false).substring(2);
  String grad2 =
      colors.colors.gradient2.toHexString(enableAlpha: false).substring(2);
  String grad3 =
      colors.colors.gradient3.toHexString(enableAlpha: false).substring(2);
  String grad4 =
      colors.colors.gradient4.toHexString(enableAlpha: false).substring(2);

  List<LookAtModel> lookAts = [];
  List<String> poisNames = [];
  String placesData = '';

  for (int i = 0; i < pois.length; i++) {
    String placeName = escapeHtml(pois[i].name);
    poisNames.add(placeName);
    LookAtModel lookAt = LookAtModel(
      longitude: pois[i].longitude,
      latitude: pois[i].latitude,
      range: '500',
      tilt: '45',
      altitude: 0,
      heading: '300',
      altitudeMode: 'relativeToGround',
    );
    lookAts.add(lookAt);

    String countryFlagImg;
    String countryCode = countryMap[pois[i].country] ?? 'None';
    String flagDiv;
    if (countryCode != 'None') {
      String cc = countryCode.toLowerCase();
      countryFlagImg = "https://www.worldometers.info/img/flags/$cc-flag.gif";

      flagDiv = '''
              <div style="text-align:center;">
                <img src="$countryFlagImg" style="display: block; margin: auto; width: 50px; height: 45px;"/><br/><br/>
              </div>
''';
    } else {
      countryFlagImg = '';
      flagDiv = '<br></br>';
    }

    placesData += '''
             <div class="details" style="text-align: center; font-weight: bold;">
                $flagDiv
                <p>${i + 1}</p>
                <p>${escapeHtml(pois[i].name)}</p>
              </div>
              ''';
  }

  print('button color:');
  print(buttonColor);

  String balloonContent = '''
    <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LG Gemini AI Touristic Info Tool</title>
    <style>
            .balloon {
               background: linear-gradient(135deg, #$grad1 5%, #$grad2 15%, #$grad3 60%, #$grad4 100%);
              padding: 10px;
              border-radius: 20px;
              font-family: Lato, sans-serif;
            }
            .balloon h1 {
              font-size: ${titleSize}px;
              color: $primaryColor;
            }
             .balloon h2 {
              font-size: ${headSize}px;
              color: $primaryColor;
            }
            .balloon h3 {
              font-size: ${headSize - 10}px;
              color: $primaryColor;
            }
            
            
            .balloon pp{
              font-size: ${textSize}px;
             color: $primaryColor;
            }
            .balloon p {
              font-size:  ${textSize}px;
              color: #ffff;
            }
            .details {
              background-color: rgba(255, 255, 255, 1);
              color: #000;
              padding: 10px;
              border-radius: 10px;
              margin-top: 10px;
              text-align: left;
              font-size: ${textSize}px;
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
</head>
<body>
          <div class="balloon">
              <div style="text-align:center;">
                <h1>Your Custom Tour Pathway</h1>
              </div>

              <br>

              $placesData

          </div>
</body>
</html>
''';

  ScreenOverlayModel screenOverlay = ScreenOverlayModel(
    overlayID: 'custom-overlay',
    name: "",
    overlayX: 0,
    overlayY: 1,
    screenX: 2,
    screenY: 2,
    sizeX: 0.5,
    sizeY: 0.5,
    content: balloonContent,
  );

  String kmlName = 'custom-tour-Balloon';
  String ballooncontent = '<name>customTourBalloon</name>';

  final kmlBalloon = KMLModel(
    name: kmlName,
    content: ballooncontent,
    screenOverlay: screenOverlay.balloonTag,
  );

  TourModel tour = TourModel(
    name: 'app-tour',
    numberOfPlaces: pois.length,
    lookAtCoordinates: lookAts,
    poisNames: poisNames,
  );
  List<dynamic> tourTag = tour.lineTourTag();
  String tourTagContent = tourTag[0];
  double tourTagDuration = tourTag[1];

  final sshData = Provider.of<SSHprovider>(context, listen: false);
  final kmlPlacemark = KMLModel(name: 'app-tour', content: tourTagContent);

  print(kmlPlacemark.body);

  try {
    await LgService(sshData).sendKmlPlacemarks(kmlPlacemark.body, 'app-tour');
    // await LgService(sshData).sendKmlPlacemarks(kmlTemp, 'app-tour');
    await LgService(sshData).sendKMLToSlave(
      LgService(sshData).balloonScreen,
      kmlBalloon.body,
    );
  } catch (e) {
    print(e);
  }
  return tourTagDuration;
}
