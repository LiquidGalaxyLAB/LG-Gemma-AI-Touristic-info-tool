import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';

class TourModel {
  String name;
  int numberOfPlaces;
  List<LookAtModel> lookAtCoordinates;
  List<String> ballonContentOfPlacemarks;
  List<String> poisNames;

  TourModel({
    required this.name,
    required this.numberOfPlaces,
    required this.lookAtCoordinates,
    required this.ballonContentOfPlacemarks,
    required this.poisNames,
  });

  String styleOnlyTag(String balloonContent, String placemarkIndex) {
    String content = '';
    content += '''
      <Style id="placemark-$placemarkIndex-style">
      <IconStyle>
        <Icon>
          <href>https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/placemark_pin.png?raw=true</href>
        </Icon>
      </IconStyle>
      <BalloonStyle>
        <bgColor>ffffffff</bgColor>
        <text><![CDATA[
        $balloonContent
        ]]></text>
      </BalloonStyle>
    </Style>
''';
    return content;
  }

  String flyToOnlyTag(double lat, double long, String mode, double duration) {
    String content = '';
    content += '''
 <gx:FlyTo>
          <gx:duration>$duration</gx:duration>
          <gx:flyToMode>$mode</gx:flyToMode>
          <LookAt>
            <longitude>$long</longitude>
            <latitude>$lat</latitude>
            <altitude>0</altitude>
            <heading>-173.948935</heading>
            <tilt>23.063392</tilt>
            <range>3733.666023</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>
''';

    return content;
  }

  String ballonVisibilityOnlyTag(String placemarkIndex, int visibility) {
    String content = '';
    content += '''
        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="placemark-$placemarkIndex-Id">
                <gx:balloonVisibility>$visibility</gx:balloonVisibility>
              </Placemark>
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
      content += styleOnlyTag(ballonContentOfPlacemarks[i], i.toString());
    }

    //2. Tour
    content += '''
    <gx:Tour>
        <name>App Tour</name>
        <gx:Playlist>
''';

    for (int i = 0; i < numberOfPlaces; i++) {
      if (i == 0) {
        content += flyToOnlyTag(lookAtCoordinates[i].latitude,
            lookAtCoordinates[i].longitude, 'bounce', 5);
      } else {
        content += flyToOnlyTag(lookAtCoordinates[i].latitude,
            lookAtCoordinates[i].longitude, 'smooth', 3);
      }
      content += ballonVisibilityOnlyTag(i.toString(), 1);
      content += waitOnlyTag;
      content += ballonVisibilityOnlyTag(i.toString(), 0);
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
      'ballonContentOfPlacemarks': ballonContentOfPlacemarks,
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
      ballonContentOfPlacemarks:
          List<String>.from(map['ballonContentOfPlacemarks']),
      poisNames: List<String>.from(map['poisNames']),
    );
  }
}
