/// Class that defines the `look at` entity, which contains its properties and methods.
class LookAtModel {
  /// Property that defines the look at `longitude`. ( east-west )
  double longitude;

  /// Property that defines the look at `latitude`. ( north-south )
  double latitude;

  /// Property that defines the look at `altitude`. ( height above sea level )
  double altitude;

  /// Property that defines the look at `range`. ( or Zoom Level: The distance from the camera to the location. It determines how zoomed in or zoomed out the view appears. )
  String range;

  /// Property that defines the look at `tilt`. ( The angle of the camera with respect to the Earth's surface )
  String tilt;

  /// Property that defines the look at `heading`. ( The direction in which the camera is pointing )
  String heading;

  /// Property that defines the look at `altitude mode`. Defaults to `relativeToGround`.
  String altitudeMode;

  LookAtModel(
      {required this.longitude,
      required this.latitude,
      required this.range,
      required this.tilt,
      required this.heading,
      this.altitude = 0,
      this.altitudeMode = 'relativeToGround'});

  /// Property that defines the look at `tag` according to its current properties.
  ///
  /// Example
  /// ```
  /// lookAt.tag => '''
  ///   <LookAt>
  ///     <longitude>-74</longitude>
  ///     <latitude>30</latitude>
  ///     <altitude>0</altitude>
  ///     <range>1492.66</range>
  ///     <tilt>45</tilt>
  ///     <heading>0</heading>
  ///     <gx:altitudeMode>relativeToGround</gx:altitudeMode>
  ///   </LookAt>
  /// '''
  /// ```
  String get tag => '''
      <LookAt>
        <longitude>$longitude</longitude>
        <latitude>$latitude</latitude>
        <altitude>$altitude</altitude>
        <range>$range</range>
        <tilt>$tilt</tilt>
        <heading>$heading</heading>
        <gx:altitudeMode>$altitudeMode</gx:altitudeMode>
      </LookAt>
    ''';

  /// Property that defines the look at `linear string` according to its current properties.
  ///
  /// Example
  /// ```
  /// lookAt.lineadTag => '<LookAt><longitude>-74</longitude><latitude>30</latitude><altitude>0</altitude><range>1492.66</range><tilt>45</tilt><heading>0</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>'
  /// ```
  String get linearTag =>
      '<LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><altitude>$altitude</altitude><range>$range</range><tilt>$tilt</tilt><heading>$heading</heading><gx:altitudeMode>$altitudeMode</gx:altitudeMode></LookAt>';

  /// Returns a [Map] from the current [LookAtModel].
  toMap() {
    return {
      'lng': longitude,
      'lat': latitude,
      'altitude': altitude,
      'range': range,
      'tilt': tilt,
      'heading': heading,
      'altitudeMode': altitudeMode
    };
  }

  /// Returns a [LookAtModel] from the given [map].
  factory LookAtModel.fromMap(Map<String, dynamic> map) {
    return LookAtModel(
        longitude: map['lng'],
        latitude: map['lat'],
        altitude: map['altitude'],
        range: map['range'],
        tilt: map['tilt'],
        heading: map['heading'],
        altitudeMode: map['altitudeMode']);
  }
}