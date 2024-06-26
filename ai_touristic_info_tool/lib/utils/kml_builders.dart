 import 'package:ai_touristic_info_tool/models/kml/KMLModel.dart';
import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/models/kml/placemark_model.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

viewPlacemarks(List<PlacemarkModel> placemarks, BuildContext context) async {
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
      await LgService(sshData)
          .sendKmlPlacemarks(kmlPlacemark.body, 'placePin');
    } catch (e) {
      print(e);
    }
  }

  

  buildLocationBallon(
      String animalName, String cityName, String countryName, BuildContext context) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final placemark = PlacemarkModel(
      id: ' $animalName-query-facts',
      name: ' $animalName-query-facts',
      balloonContent: '''
    <div style="text-align:center;">
      <b><font size="+3"> 'Discover more about $animalName' <font color="#5D5D5D"></font></font></b>
      </div>
      <br/><br/>
      <p>$animalName can be found in $cityName , $countryName</p>
      <br/>
    ''',
    );
    final kmlBalloon = KMLModel(
      name: '$animalName-query-balloon',
      content: placemark.balloonOnlyTag,
    );

    try {
      /// sending kml to slave where we send to `balloon screen` and send the `kml balloon ` body
      await LgService(sshData).sendKMLToSlave(
        LgService(sshData).balloonScreen,
        kmlBalloon.body,
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  buildFunFactsBallon(String animalName, String funFacts, BuildContext context) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final placemark = PlacemarkModel(
      id: '$animalName-fun-facts',
      name: '$animalName-fun-facts',
      balloonContent: '''
    <div style="text-align:center;">
      <b><font size="+3"> 'Discover more about $animalName' <font color="#5D5D5D"></font></font></b>
      </div>
      <br/><br/>
     <div style="text-align:center;">
      <b><font size="+2"> 'FUN FACTS' <font color="#5D5D5D"></font></font></b>
      </div>
      <br/>
      <p>${funFacts.split('\n\n').join('<br/><br/>')}</p>
      <br/>
    ''',
    );
    final kmlBalloon = KMLModel(
      name: '$animalName-fun-facts-balloon',
      content: placemark.balloonOnlyTag,
    );
    if (sshData.client != null) {
      LookAtModel lookAtObj = LookAtModel(
        longitude: -45.4518936,
        latitude: 0.0000101,
        range: '31231212.86',
        tilt: '0',
        altitude: 50000.1097385,
        heading: '0',
        altitudeMode: 'relativeToSeaFloor',
      );

      try {
        await LgService(sshData).flyTo(lookAtObj);

        /// sending kml to slave where we send to `balloon screen` and send the `kml balloon ` body
        await LgService(sshData).sendKMLToSlave(
          LgService(sshData).balloonScreen,
          kmlBalloon.body,
        );
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  buildInitialsBalloon(String animalName, BuildContext context) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    final placemark = PlacemarkModel(
      id: '$animalName-initial',
      name: '$animalName-initial',
      balloonContent: '''
    <div style="text-align:center;">
      <b><font size="+3"> 'Discover more about $animalName' <font color="#5D5D5D"></font></font></b>
      </div>
      <br/><br/>
      <div style="text-align:center;">
      <img src="https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/animalsBalloon.png?raw=true" style="display: block; margin: auto; width: 150px; height: 100px;"/><br/><br/>
     </div>
      <br/>
    ''',
    );
    final kmlBalloon = KMLModel(
      name: '$animalName-initial-balloon',
      content: placemark.balloonOnlyTag,
    );

    if (sshData.client != null) {
      LookAtModel lookAtObj = LookAtModel(
        longitude: -45.4518936,
        latitude: 0.0000101,
        range: '31231212.86',
        tilt: '0',
        altitude: 50000.1097385,
        heading: '0',
        altitudeMode: 'relativeToSeaFloor',
      );

      try {
        await LgService(sshData).flyTo(lookAtObj);

        /// sending kml to slave where we send to `balloon screen` and send the `kml balloon ` body
        await LgService(sshData).sendKMLToSlave(
          LgService(sshData).balloonScreen,
          kmlBalloon.body,
        );
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }