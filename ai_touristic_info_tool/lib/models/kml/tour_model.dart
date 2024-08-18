import 'dart:math';

import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/models/kml/orbit_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


/// Class that defines the `tour` entity, which contains its properties and methods.
/// Used for creating the tour path and the placemarks.
class TourModel {
  /// Property that defines the tour `name`.
  String name;

  /// Property that defines the number of places in the tour.
  int numberOfPlaces;

  /// Property that defines the list of `look at` coordinates.
  List<LookAtModel> lookAtCoordinates;

  /// Property that defines the list of `POIs` names.
  List<String> poisNames;

  /// Property that defines the list of `all path points`.
  List<LatLng> allPathPoints = [];

  /// Property that defines the list of `interpolated points`.
  List<LatLng> interpolatedPoints = [];

  TourModel({
    required this.name,
    required this.numberOfPlaces,
    required this.lookAtCoordinates,
    // required this.ballonContentOfPlacemarks,
    required this.poisNames,
  });




  /// Property that defines the tour `styleOnlyTag` according to its current properties.
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

  /// Property that defines the tour `iconStyleOnlyTag` according to its current properties.
  String iconStyleOnlyTag(String hrefIcon, String styleID) {
    String content = '';
    //String placemarkIndex
    //<Style id="placemark-$placemarkIndex-style">
    content += '''
      <Style id="$styleID">
      <IconStyle>
        <Icon>
          <href>$hrefIcon</href>
        </Icon>
      </IconStyle>
    </Style>
''';
    return content;
  }
 
  /// Property that defines the tour `lineStyleOnlyTag` according to its current properties.
  String lineStyleOnlyTag() {
    String content = '';
    content += '''
 <Style id="lineID">
      <LineStyle>
        <color>ff0000ff</color> 
        <width>3</width> 
      </LineStyle>
    </Style>
    ''';
    return content;
  }

  ///  Property that defines the tour `flyToLookAtOnlyTag` according to its current properties.
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

  /// Property that defines the tour `flyToCameraOnlyTag` according to its current properties.
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

  /// Property that defines the tour `ballonVisibilityOnlyTag` according to its current properties.
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

  /// Property that defines the tour `waitOnlyTag` according to its current properties.
  String get waitOnlyTag => '''
 <gx:Wait>
    <gx:duration>6.0</gx:duration>
  </gx:Wait>
''';

 /// Property that defines the tour `placemarkOnlyTag` according to its current properties.
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

  /// Property that defines the tour `pointPlacemarkOnlyTag` according to its current properties.   
  String pointPlacemarkOnlyTag(
      String placemarkName, double lat, double long, String styleID) {
    String content = '';
    //  <styleUrl>#placemark-$placemarkIndex-style</styleUrl>
    content += '''
<Placemark>
      <name>$placemarkName</name>
      <styleUrl>#$styleID</styleUrl>
      <Point>
        <coordinates>$long,$lat,0</coordinates>
      </Point>
    </Placemark>
''';
    return content;
  }

  ///   Property that defines the tour `midPointPlacemarkOnlyTag` according to its current properties.
  String midPointPlacemarkOnlyTag(double lat, double long, String styleID) {
    String content = '';
    //  <styleUrl>#placemark-$placemarkIndex-style</styleUrl>
    content += '''
<Placemark>
      <styleUrl>#$styleID</styleUrl>
      <Point>
        <coordinates>$long,$lat,0</coordinates>
      </Point>
    </Placemark>
''';
    return content;
  }

  /// Property that defines the tour `linePlacemarkOnlyTag` according to its current properties.
  /// Returns the line placemark content.
  String linePlacemarkOnlyTag(List<LatLng> coordinates) {
    String content = '';
    String coordinatesString = '';
    for (int i = 0; i < coordinates.length; i++) {
      coordinatesString +=
          '${coordinates[i].longitude},${coordinates[i].latitude},0';
      coordinatesString += '\n';
    }
    print(coordinatesString);
    content += '''
<Placemark>
      <name>Path</name>
      <styleUrl>#lineID</styleUrl>
     <LineString>
        <coordinates>
        $coordinatesString
          </coordinates>
      </LineString>
    </Placemark>
''';
    return content;
  }

  /// Property that defines the tour `calculateDistance` according to its current properties.
  /// Returns the distance between two given points.
  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double dLat = _toRadians(end.latitude - start.latitude);
    double dLng = _toRadians(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(start.latitude)) *
            cos(_toRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in meters
  }


  /// Property that defines the tour `_toRadians` according to its current properties.
  /// Converts degrees to radians.
  double _toRadians(double degree) {
    return degree * pi / 180;
  }

   /// Property that defines the tour `determineNumPoints` according to its current properties.
   /// Returns the number of points to interpolate between two given points.
  int determineNumPoints(double distance) {
    print('distance:');
    if (distance > 10000000) {
      return 10;
    } else if (distance > 5000000) {
      return 5;
    } else {
      return 2;
    }
  }

  /// Property that defines the tour `interpolatePoints` according to its current properties.
  /// Returns a list of interpolated points between two given points.
  List<LatLng> interpolatePoints(LatLng start, LatLng end) {
    double distance = calculateDistance(start, end);
    int numPoints = determineNumPoints(distance);

    List<LatLng> interpolatedPoints = [];
    double dLat = (end.latitude - start.latitude) / (numPoints + 1);
    double dLng = (end.longitude - start.longitude) / (numPoints + 1);

    for (int i = 1; i <= numPoints; i++) {
      double lat = start.latitude + dLat * i;
      double lng = start.longitude + dLng * i;
      interpolatedPoints.add(LatLng(lat, lng));
    }

    return interpolatedPoints;
  }

  /// Property that defines the tour `setInterpolatedPath` according to its current properties.
  setInterpolatedPath() {
    //List<LatLng> allPoints = [];

    for (int i = 0; i < numberOfPlaces - 1; i++) {
      LatLng main_coords_i =
          LatLng(lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
      LatLng main_coords_i1 = LatLng(lookAtCoordinates[i + 1].latitude,
          lookAtCoordinates[i + 1].longitude);

      allPathPoints.add(main_coords_i);
      allPathPoints.addAll(interpolatePoints(main_coords_i, main_coords_i1));
      interpolatedPoints
          .addAll(interpolatePoints(main_coords_i, main_coords_i1));
    }

    // Add the last place
    allPathPoints.add(LatLng(lookAtCoordinates[numberOfPlaces - 1].latitude,
        lookAtCoordinates[numberOfPlaces - 1].longitude));
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// Tour Model for Line Tour
  List<dynamic> lineTourTag() {
    double tourDuration = 0;
    setInterpolatedPath();
    String content = '';

    //1. Style

    content += iconStyleOnlyTag(
        "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/airplane.png?raw=true",
        "lineIcon");

    content += iconStyleOnlyTag(
        "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true",
        "pointIcon");

    content += lineStyleOnlyTag();

    // // get interpolated points
    // List<List<LatLng>> allPoints = getInterpolatedPath();

    //2. Tour
    content += '''
    <gx:Tour>
        <name>App Tour</name>
        <gx:Playlist>
''';

    content += flyToLookAtOnlyTag(
        lookAtCoordinates[0].latitude,
        lookAtCoordinates[0].longitude,
        'bounce',
        1.0,
        '3000000',
        '30',
        '90',
        1000);
    tourDuration += 1;

    for (int i = 0; i < allPathPoints.length; i++) {
      double heading = 90; // Default heading

      if (i > 0) {
        // Calculate heading based on movement direction
        if (allPathPoints[i].longitude < allPathPoints[i - 1].longitude) {
          heading = 270; // Moving west
        } else {
          heading = 90; // Moving noth
        }
      }

      content += flyToLookAtOnlyTag(
        allPathPoints[i].latitude,
        allPathPoints[i].longitude,
        'smooth',
        2.0,
        '3000000',
        '30',
        heading.toString(),
        1000,
      );
      tourDuration += 2;
    }

    content += '''
      </gx:Playlist>
    </gx:Tour>
''';
    print('inside tour model');
    print(tourDuration);

    // 3. Places Placemarks
    // all points
    for (int i = 0; i < numberOfPlaces; i++) {
      content += pointPlacemarkOnlyTag(
          poisNames[i],
          lookAtCoordinates[i].latitude,
          lookAtCoordinates[i].longitude,
          'pointIcon');
    }
    // interpolated
    for (int i = 0; i < interpolatedPoints.length; i++) {
      content += midPointPlacemarkOnlyTag(
          allPathPoints[i].latitude, allPathPoints[i].longitude, 'lineIcon');
    }

    // 4. Line Placemarks
    content += linePlacemarkOnlyTag(allPathPoints);

    return [content, tourDuration];
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
