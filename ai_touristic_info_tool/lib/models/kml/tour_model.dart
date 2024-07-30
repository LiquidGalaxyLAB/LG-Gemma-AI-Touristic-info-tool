// import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';

// class TourModel {
//   String name;
//   int numberOfPlaces;
//   List<LookAtModel> lookAtCoordinates;
//   List<String> ballonContentOfPlacemarks;
//   List<String> poisNames;

//   TourModel({
//     required this.name,
//     required this.numberOfPlaces,
//     required this.lookAtCoordinates,
//     required this.ballonContentOfPlacemarks,
//     required this.poisNames,
//   });

//   String styleOnlyTag(String balloonContent, String placemarkIndex) {
//     String content = '';
//     content += '''
//       <Style id="placemark-$placemarkIndex-style">
//       <IconStyle>
//         <Icon>
//           <href>https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true</href>
//         </Icon>
//       </IconStyle>
//       <BalloonStyle>
//         <bgColor>ffffffff</bgColor>
//         <text><![CDATA[
//         $balloonContent
//         ]]></text>
//       </BalloonStyle>
//     </Style>
// ''';
//     return content;
//   }

//   String flyToLookAtOnlyTag(
//       double lat,
//       double long,
//       String mode,
//       double duration,
//       String range,
//       String tilt,
//       String heading,
//       double altitude) {
//     String content = '';
//     content += '''
//  <gx:FlyTo>
//           <gx:duration>$duration</gx:duration>
//           <gx:flyToMode>$mode</gx:flyToMode>
//           <LookAt>
//             <longitude>$long</longitude>
//             <latitude>$lat</latitude>
//             <altitude>$altitude</altitude>
//             <heading>$heading</heading>
//             <tilt>$tilt</tilt>
//             <range>$range</range>
//             <altitudeMode>relativeToGround</altitudeMode>
//           </LookAt>
//         </gx:FlyTo>
// ''';

//     return content;
//   }

//   String flyToCameraOnlyTag(
//     double lat,
//     double long,
//   ) {
//     String content = '';
//     content += '''
//  <gx:FlyTo>
//          <gx:duration>8.0</gx:duration>
//        <Camera>
//           <longitude>$long</longitude>
//           <latitude>$lat</latitude>
//           <altitude>18275</altitude>
//           <heading>-4.921</heading>
//           <tilt>65</tilt>
//           <altitudeMode>absolute</altitudeMode>
//         </Camera>
// </gx:FlyTo>
// ''';

//     return content;
//   }

//   String ballonVisibilityOnlyTag(String placemarkIndex, int visibility) {
//     String content = '';
//     content += '''
//         <gx:AnimatedUpdate>
//           <Update>
//             <targetHref/>
//             <Change>
//               <Placemark targetId="placemark-$placemarkIndex-Id">
//                 <gx:balloonVisibility>$visibility</gx:balloonVisibility>
//               </Placemark>
//             </Change>
//           </Update>
//         </gx:AnimatedUpdate>
// ''';
//     return content;
//   }

//   String get waitOnlyTag => '''
//  <gx:Wait>
//     <gx:duration>6.0</gx:duration>
//   </gx:Wait>
// ''';

//   String placemarkOnlyTag(
//       String placemarkIndex, String placemarkName, double lat, double long) {
//     String content = '';
//     content += '''
// <Placemark id="placemark-$placemarkIndex-Id">
//       <name>$placemarkName</name>
//       <styleUrl>#placemark-$placemarkIndex-style</styleUrl>
//       <Point>
//         <coordinates>$long,$lat,0</coordinates>
//       </Point>
//     </Placemark>
// ''';
//     return content;
//   }

//   String tourTag() {
//     String content = '';

//     //1. Style
//     for (int i = 0; i < numberOfPlaces; i++) {
//       content += styleOnlyTag(ballonContentOfPlacemarks[i], i.toString());
//     }

//     //2. Tour
//     content += '''
//     <gx:Tour>
//         <name>App Tour</name>
//         <gx:Playlist>
// ''';

//     for (int i = 0; i < numberOfPlaces; i++) {
//       if (i == 0) {
//         content += flyToLookAtOnlyTag(lookAtCoordinates[i].latitude,
//             lookAtCoordinates[i].longitude, 'bounce', 5, '500', '60', '0', 0);
//         content += ballonVisibilityOnlyTag(i.toString(), 1);
//         content += waitOnlyTag;
//         content += ballonVisibilityOnlyTag(i.toString(), 0);
//       } else {

//         content += flyToCameraOnlyTag(
//             lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
//         content += flyToLookAtOnlyTag(lookAtCoordinates[i].latitude,
//             lookAtCoordinates[i].longitude, 'smooth', 2, '500', '60', '0', 0);
//         content += ballonVisibilityOnlyTag(i.toString(), 1);

//         content += waitOnlyTag;
//         content += ballonVisibilityOnlyTag(i.toString(), 0);

//       }
//     }
//     content += '''
//       </gx:Playlist>
//     </gx:Tour>
// ''';

//     // 3. Placemarks
//     for (int i = 0; i < numberOfPlaces; i++) {
//       content += placemarkOnlyTag(i.toString(), poisNames[i],
//           lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
//     }

//     return content;
//   }

//   /// Returns a [Map] from the current [TourModel].
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'numberOfPlaces': numberOfPlaces,
//       'lookAtCoordinates': lookAtCoordinates.map((e) => e.toMap()).toList(),
//       'ballonContentOfPlacemarks': ballonContentOfPlacemarks,
//       'poisNames': poisNames,
//     };
//   }

//   /// Returns a [TourModel] from the given [map].
//   factory TourModel.fromMap(Map<String, dynamic> map) {
//     return TourModel(
//       name: map['name'],
//       numberOfPlaces: map['numberOfPlaces'],
//       lookAtCoordinates: List<LookAtModel>.from(
//           map['lookAtCoordinates']?.map((x) => LookAtModel.fromMap(x))),
//       ballonContentOfPlacemarks:
//           List<String>.from(map['ballonContentOfPlacemarks']),
//       poisNames: List<String>.from(map['poisNames']),
//     );
//   }
// }

import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/models/kml/orbit_model.dart';

class TourModel {
  String name;
  int numberOfPlaces;
  List<LookAtModel> lookAtCoordinates;
  // List<String> ballonContentOfPlacemarks;
  List<String> poisNames;

  TourModel({
    required this.name,
    required this.numberOfPlaces,
    required this.lookAtCoordinates,
    // required this.ballonContentOfPlacemarks,
    required this.poisNames,
  });

  String styleOnlyTag(String placemarkIndex) {
    String content = '';
    content += '''
      <Style id="placemark-$placemarkIndex-style">
      <IconStyle>
        <Icon>
          <href>https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true</href>
        </Icon>
      </IconStyle>
    </Style>
''';
    return content;
  }

  String flyToLookAtOnlyTag(
      double lat,
      double long,
      String mode,
      double duration,
      String range,
      String tilt,
      String heading,
      double altitude) {
    String content = '';
    content += '''
 <gx:FlyTo>
          <gx:duration>$duration</gx:duration>
          <gx:flyToMode>$mode</gx:flyToMode>
          <LookAt>
            <longitude>$long</longitude>
            <latitude>$lat</latitude>
            <altitude>$altitude</altitude>
            <heading>$heading</heading>
            <tilt>$tilt</tilt>
            <range>$range</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>
''';

    return content;
  }

  String flyToCameraOnlyTag(
    double lat,
    double long,
  ) {
    String content = '';
    content += '''
 <gx:FlyTo>
         <gx:duration>3.0</gx:duration>
       <Camera>
          <longitude>$long</longitude>
          <latitude>$lat</latitude>
          <altitude>18275</altitude>
          <heading>-4.921</heading>
          <tilt>65</tilt>
          <altitudeMode>absolute</altitudeMode>
        </Camera>
</gx:FlyTo>
''';

    return content;
  }

  String ballonVisibilityOnlyTag(String placemarkIndex, int visibility) {
    String content = '';
    content += '''
        <gx:AnimatedUpdate>
          <gx:duration>0.5</gx:duration>
          <Update>
            <targetHref/>
            <Change>
              <ScreenOverlay targetId="overlay-$placemarkIndex">
                <visibility>$visibility</visibility>
              </ScreenOverlay>
            </Change>
          </Update>
        </gx:AnimatedUpdate>
''';
    return content;
  }

  String get waitOnlyTag => '''
 <gx:Wait>
    <gx:duration>6.0</gx:duration>
  </gx:Wait>
''';

  String placemarkOnlyTag(
      String placemarkIndex, String placemarkName, double lat, double long) {
    String content = '';
    content += '''
<Placemark id="placemark-$placemarkIndex-Id">
      <name>$placemarkName</name>
      <styleUrl>#placemark-$placemarkIndex-style</styleUrl>
      <Point>
        <coordinates>$long,$lat,0</coordinates>
      </Point>
    </Placemark>
''';
    return content;
  }

  String tourTag() {
    String content = '';

    //1. Style
    for (int i = 0; i < numberOfPlaces; i++) {
      content += styleOnlyTag(i.toString());
    }

    //2. Tour
    content += '''
    <gx:Tour>
        <name>App Tour</name>
        <gx:Playlist>
''';

    for (int i = 0; i < numberOfPlaces; i++) {
      // OrbitModel orbitModelForPOI=OrbitModel();
      LookAtModel lookAtObjOrbit = LookAtModel(
        longitude: lookAtCoordinates[i].longitude,
        latitude: lookAtCoordinates[i].latitude,
        range: '200',
        tilt: '90',
        altitude: 0,
        heading: '0',
        altitudeMode: 'relativeToGround',
      );

      if (i == 0) {
        content += flyToLookAtOnlyTag(lookAtCoordinates[i].latitude,
            lookAtCoordinates[i].longitude, 'bounce', 5, '500', '60', '0', 0);
        content += flyToLookAtOnlyTag(lookAtCoordinates[i].latitude,
            lookAtCoordinates[i].longitude, 'smooth', 3, '200', '60', '0', 0);
        content += OrbitModel.tag(lookAtObjOrbit, duration: 1);
        // content += ballonVisibilityOnlyTag(i.toString(), 1);
        // content += waitOnlyTag;
        // content += ballonVisibilityOnlyTag(i.toString(), 0);
      } else {
        // content += flyToCameraOnlyTag(
        //     lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
        content += flyToLookAtOnlyTag(lookAtCoordinates[i].latitude,
            lookAtCoordinates[i].longitude, 'bounce', 8, '500', '60', '0', 0);
        content += flyToLookAtOnlyTag(lookAtCoordinates[i].latitude,
            lookAtCoordinates[i].longitude, 'smooth', 3, '200', '60', '0', 0);
        content += OrbitModel.tag(lookAtObjOrbit, duration: 1);
        // content += ballonVisibilityOnlyTag(i.toString(), 1);

        // content += waitOnlyTag;
        // content += ballonVisibilityOnlyTag(i.toString(), 0);
      }
    }
    content += '''
      </gx:Playlist>
    </gx:Tour>
''';

    // 3. Placemarks
    for (int i = 0; i < numberOfPlaces; i++) {
      content += placemarkOnlyTag(i.toString(), poisNames[i],
          lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
    }

    return content;
  }

  /// Returns a [Map] from the current [TourModel].
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'numberOfPlaces': numberOfPlaces,
      'lookAtCoordinates': lookAtCoordinates.map((e) => e.toMap()).toList(),
      // 'ballonContentOfPlacemarks': ballonContentOfPlacemarks,
      'poisNames': poisNames,
    };
  }

  /// Returns a [TourModel] from the given [map].
  factory TourModel.fromMap(Map<String, dynamic> map) {
    return TourModel(
      name: map['name'],
      numberOfPlaces: map['numberOfPlaces'],
      lookAtCoordinates: List<LookAtModel>.from(
          map['lookAtCoordinates']?.map((x) => LookAtModel.fromMap(x))),
      // ballonContentOfPlacemarks:
      //     List<String>.from(map['ballonContentOfPlacemarks']),
      poisNames: List<String>.from(map['poisNames']),
    );
  }
}
