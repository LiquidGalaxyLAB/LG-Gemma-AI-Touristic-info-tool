import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/models/kml/orbit_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  String iconStyleOnlyTag(String hrefIcon) {
    String content = '';
    //String placemarkIndex
    //<Style id="placemark-$placemarkIndex-style">
    content += '''
      <Style id="pointIcon">
      <IconStyle>
        <Icon>
          <href>$hrefIcon</href>
        </Icon>
      </IconStyle>
    </Style>
''';
    return content;
  }

  String lineStyleOnlyTag() {
    String content = '';
    content += '''
 <Style id="lineIcon">
      <LineStyle>
        <color>ff0000ff</color> 
        <width>3</width> 
      </LineStyle>
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

  String pointPlacemarkOnlyTag(
      String placemarkIndex, String placemarkName, double lat, double long) {
    String content = '';
    //  <styleUrl>#placemark-$placemarkIndex-style</styleUrl>
    content += '''
<Placemark id="placemark-$placemarkIndex-Id">
      <name>$placemarkName</name>
      <styleUrl>#pointIcon</styleUrl>
      <Point>
        <coordinates>$long,$lat,0</coordinates>
      </Point>
    </Placemark>
''';
    return content;
  }

  String linePlacemarkOnlyTag(List<LatLng> coordinates) {
    String content = '';
    List<String> coordinatesString = [];
    for (int i = 0; i < coordinates.length; i++) {
      coordinatesString
          .add('${coordinates[i].longitude},${coordinates[i].latitude},0');
    }
    content += '''
<Placemark id="=line-string-Id">
      <name>Line Path</name>
      <styleUrl>#lineIcon</styleUrl>
     <LineString>
        <coordinates>
        $coordinates
          </coordinates>
      </LineString>
    </Placemark>
''';
    return content;
  }

  List<LatLng> interpolatePoints(LatLng start, LatLng end) {
    List<LatLng> interpolatedPoints = [];
    double dLat = (end.latitude - start.latitude) / (20 + 1);
    double dLng = (end.longitude - start.longitude) / (20 + 1);

    for (int i = 1; i <= 20; i++) {
      double lat = start.latitude + dLat * i;
      double lng = start.longitude + dLng * i;
      interpolatedPoints.add(LatLng(lat, lng));
    }

    return interpolatedPoints;
  }

  List<LatLng> getInterpolatedPath() {
    List<LatLng> allPoints = [];

    for (int i = 0; i < numberOfPlaces - 1; i++) {
      LatLng main_coords_i =
          LatLng(lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
      LatLng main_coords_i1 = LatLng(lookAtCoordinates[i + 1].latitude,
          lookAtCoordinates[i + 1].longitude);

      allPoints.add(main_coords_i);
      allPoints.addAll(interpolatePoints(main_coords_i, main_coords_i1));
    }

    // Add the last place
    allPoints.add(LatLng(lookAtCoordinates[numberOfPlaces - 1].latitude,
        lookAtCoordinates[numberOfPlaces - 1].longitude));

    return allPoints;
  }

  String tourTag() {
    String content = '';

    //1. Style
    for (int i = 0; i < numberOfPlaces; i++) {
      // content += iconStyleOnlyTag(i.toString());
      content += iconStyleOnlyTag(
          "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true");
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
      content += pointPlacemarkOnlyTag(i.toString(), poisNames[i],
          lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
    }

    return content;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////
  String lineTourTag() {
    String content = '';

    //1. Style
    for (int i = 0; i < numberOfPlaces; i++) {
      content += iconStyleOnlyTag(
          "https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true");
    }
    for (int i = 0; i < numberOfPlaces; i++) {
      content += lineStyleOnlyTag();
    }

    //2. Tour
    content += '''
    <gx:Tour>
        <name>App Tour</name>
        <gx:Playlist>
''';

    for (int i = 0; i < numberOfPlaces; i++) {
      content += flyToLookAtOnlyTag(lookAtCoordinates[i].latitude,
          lookAtCoordinates[i].longitude, 'smooth', 5.0, '500', '45', '300', 0);
    }

    content += '''
      </gx:Playlist>
    </gx:Tour>
''';

    // 3. Places Placemarks
    for (int i = 0; i < numberOfPlaces; i++) {
      content += pointPlacemarkOnlyTag(i.toString(), poisNames[i],
          lookAtCoordinates[i].latitude, lookAtCoordinates[i].longitude);
    }

    // 4. Line Placemarks
    content += linePlacemarkOnlyTag(getInterpolatedPath());

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
