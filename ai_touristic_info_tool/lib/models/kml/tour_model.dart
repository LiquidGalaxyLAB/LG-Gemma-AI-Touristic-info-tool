/// Class that defines the `tour` entity, which contains its properties and methods.
class TourModel {
  /// Property that defines the tour [name].
  String name;

  /// Property that defines the animated [placemark] id.
  String placemarkId;

  /// Property that defines the tour [initial coordinate].
  Map<String, double> initialCoordinate;

  /// Property that defines the placemark tour [coordinates].
  List<Map<String, double>> coordinates;

  TourModel({
    required this.name,
    required this.placemarkId,
    required this.initialCoordinate,
    required this.coordinates,
  });

  /// Returns a KML based on the current tour.
  String get tourKml => '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>Tour</name>
    <open>1</open>
    <Folder>
      $tag
    </Folder>
  </Document>
</kml>
  ''';

  /// Gets the tour tag according to its [name], [placemarkId] and [coordinates].
  String get tag => '''
    <gx:Tour>
      <name>$name</name>
      <gx:Playlist>
        $_updates
      </gx:Playlist>
    </gx:Tour>
  ''';

  /// Gets all animation updates from the current [placemarkId] and [coordinates].
  String get _updates {
    String updates = '';

    double heading = 0;
    double? last;

    int changedIterations = 0;

    for (var coord in coordinates) {
      if (heading >= 360) {
        heading -= 360;
      }

      double? lng = coord['lng'];
      final lat = coord['lat'];
      final alt = coord['altitude'];

      bool changed = false;

      if (last != null && (lng! - last).abs() > 20 && changedIterations == 0) {
        changed = true;
      }

      if (last != null &&
          ((lng! < 0 && last > 0) || (lng > 0 && last < 0)) &&
          lat!.abs() > 70) {
        changedIterations++;
        heading += (heading >= 180 ? -180 : 180);
      }

      heading += 1;
      updates += '''
        <gx:FlyTo>
          <gx:duration>0.4</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>$lng</longitude>
            <latitude>$lat</latitude>
            <altitude>$alt</altitude>
            <heading>$heading</heading>
            <tilt>30</tilt>
            <range>10000000</range>
            <gx:altitudeMode>absolute</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <gx:duration>${changed ? 0 : 0.7}</gx:duration>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="$placemarkId">
                <Point>
                  <coordinates>$lng,$lat,$alt</coordinates>
                </Point>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>
      ''';

      if (changedIterations > 0 && changedIterations < 11) {
        changedIterations++;
      } else {
        changedIterations = 0;
      }

      last = lng;
    }

    updates += '''
        <gx:Wait>
          <gx:duration>2</gx:duration>
        </gx:Wait>

        <gx:AnimatedUpdate>
          <gx:duration>0</gx:duration>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="$placemarkId">
                <Point>
                  <coordinates>${initialCoordinate['lng']},${initialCoordinate['lat']},${initialCoordinate['altitude']}</coordinates>
                </Point>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>5</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>${initialCoordinate['lng']}</longitude>
            <latitude>${initialCoordinate['lat']}</latitude>
            <altitude>${initialCoordinate['altitude']}</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>4000000</range>
            <gx:altitudeMode>relativeToGround</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>
    ''';

    return updates;
  }

  /// Returns a [Map] from the current [TourModel].
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'placemarkId': placemarkId,
      'initialCoordinate': initialCoordinate,
      'coordinates': coordinates,
    };
  }

  /// Returns a [TourModel] from the given [map].
  factory TourModel.fromMap(Map<String, dynamic> map) {
    return TourModel(
      name: map['name'],
      placemarkId: map['placemarkId'],
      initialCoordinate: map['initialCoordinate'],
      coordinates: map['coordinates'],
    );
  }
}




/*

<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2"
 xmlns:gx="http://www.google.com/kml/ext/2.2">
  
  <Document>
    <name>balloonVisibility Example</name>
    <open>1</open>

    <gx:Tour>
      <name>Play me</name>
      <gx:Playlist>
 
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <!-- bounce is the default flyToMode -->
          <LookAt>
            <longitude>-119.748584</longitude>
            <latitude>33.736266</latitude>
            <altitude>0</altitude>
            <heading>-9.295926</heading>
            <tilt>84.0957450</tilt>
            <range>4469.850414</range>
            <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <!-- the default duration is 0.0 -->
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater1">
                <gx:balloonVisibility>1</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:Wait>
          <gx:duration>4.0</gx:duration>
        </gx:Wait>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater1">
                <gx:balloonVisibility>0</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>-119.782630</longitude>
            <latitude>33.862855</latitude>
            <altitude>0</altitude>
            <heading>-19.314858</heading>
            <tilt>84.117317</tilt>
            <range>6792.665540</range>
            <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater2">
                <gx:balloonVisibility>1</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:Wait>
          <gx:duration>4.0</gx:duration>
        </gx:Wait>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="underwater2">
                <gx:balloonVisibility>0</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>-119.849578</longitude>
            <latitude>33.968515</latitude>
            <altitude>0</altitude>
            <heading>-173.948935</heading>
            <tilt>23.063392</tilt>
            <range>3733.666023</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:AnimatedUpdate>
          <Update>
            <targetHref/>
            <Change>
              <Placemark targetId="onland">
                <gx:balloonVisibility>1</gx:balloonVisibility>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:Wait>
          <gx:duration>4.0</gx:duration>
        </gx:Wait>

      </gx:Playlist>
    </gx:Tour>

    <Placemark id="underwater1">
      <name>Underwater off the California Coast</name>
      <description>
        The tour begins near the Santa Cruz Canyon, 
        off the coast of California, USA.
      </description>
      <Point>
        <gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>
        <coordinates>-119.749531,33.715059,0</coordinates>
      </Point>
    </Placemark>

    <Placemark id="underwater2">
      <name>Still swimming...</name>
      <description>We're about to leave the ocean, and visit the coast...</description>
      <Point>
        <gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>
        <coordinates>-119.779550,33.829268,0</coordinates>
      </Point>
    </Placemark>

    <Placemark id="onland">
      <name>The end</name>
      <description>
        <![CDATA[The end of our simple tour. 
        Use <gx:balloonVisibility>1</gx:balloonVisibility> 
        to show description balloons.]]>
      </description>
      <Point>
        <coordinates>-119.849578,33.968515,0</coordinates>
      </Point>
    </Placemark>

  </Document>
</kml>

*/