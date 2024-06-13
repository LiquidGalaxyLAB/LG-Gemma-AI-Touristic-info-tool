import 'line_model.dart';
import 'look_at_model.dart';
import 'point_model.dart';
import 'tour_model.dart';

/// Class that defines the `placemark` entity, which contains its properties and methods.
class PlacemarkModel {
  /// Property that defines the placemark `id`.
  String id;

  ///property that defines the style `id`
  String? styleId;

  /// Property that defines the placemark `name`.
  String name;

  /// Property that defines the placemark `description`.
  String? description;

  /// Property that defines the placemark `icon` image URL.
  String? icon;

  /// Property that defines the placemark `balloon` content.
  String balloonContent;

  /// Property that defines the placemark `visibility`.
  bool visibility;

  /// Property that defines whether the placemark orbit is visible;
  bool viewOrbit;

  /// Property that defines the placemark `scale`.
  double scale;

  /// Property that defines the placemark `look at` entity.
  LookAtModel? lookAt;

  /// Property that defines the placemark `point` entity.
  PointModel? point;

  /// Property that defines the placemark `line` entity.
  LineModel? line;

  /// Property that defines the placemark `tour` entity.
  TourModel? tour;

  PlacemarkModel({
    this.description,
    this.icon,
    this.balloonContent = '',
    this.visibility = true,
    this.viewOrbit = true,
    this.scale = 2.5,
    this.lookAt,
    this.tour,
    required this.id,
    required this.name,
    this.point,
    this.line,
  });

  /// Property that defines the placemark `tag` according to its current properties.
  /// KML code for a placemark
  String get tag => '''
    <Style id="high-$id">
      <IconStyle>
        <scale>${scale + 0.5}</scale>
        <Icon>
          <href>http://lg1:81/$icon</href>
        </Icon>
        <hotSpot x="0.5" y="0.5" xunits="fraction" yunits="fraction" />
      </IconStyle>
    </Style>
    <Style id="normal-$id">
      <IconStyle>
        <scale>$scale</scale>
        <Icon>
          <href>http://lg1:81/$icon</href>
        </Icon>
        <hotSpot x="0.5" y="0.5" xunits="fraction" yunits="fraction" />
      </IconStyle>
      <BalloonStyle>
        <bgColor>ffffffff</bgColor>
        <text><![CDATA[
          $balloonContent
        ]]></text>
      </BalloonStyle>
    </Style>
    <Style id="line-$id">
      <LineStyle>
        <color>ff4444ff</color>
        <colorMode>normal</colorMode>
        <width>5.0</width>
        <gx:outerColor>ff4444ff</gx:outerColor>
        <gx:outerWidth>0.0</gx:outerWidth>
        <gx:physicalWidth>0.0</gx:physicalWidth>
        <gx:labelVisibility>0</gx:labelVisibility>
      </LineStyle>
      <PolyStyle>
        <color>00000000</color>
      </PolyStyle>
    </Style>
    <StyleMap id="$id">
      <Pair>
        <key>normal</key>
        <styleUrl>normal-$id</styleUrl>
      </Pair>
      <Pair>
        <key>highlight</key>
        <styleUrl>high-$id</styleUrl>
      </Pair>
    </StyleMap>
    <Placemark id="p-$id">
      <name>$name</name>
      <description><![CDATA[$description]]></description>
      ${lookAt == null ? '' : lookAt!.tag}
      <styleUrl>$id</styleUrl>
      ${point?.tag}
      <visibility>${visibility ? 1 : 0}</visibility>
      <gx:balloonVisibility>0</gx:balloonVisibility>
    </Placemark>
    ${viewOrbit ? orbitTag : ''}
    ${tour != null ? tour!.tag : ''}
  ''';

//https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/animalPin.png?raw=true
  String get styleTag => '''

<Style id="$styleId">
    <IconStyle id="mystyle">
      <Icon>
        <href>$icon</href>
        <scale>$scale</scale>
      </Icon>
    </IconStyle>
  </Style>

''';

  String get placemarkOnlyTag => '''
<Placemark id="$id">
    <name>$name</name>
    <description>
    $description
    </description>
    ${lookAt == null ? '' : lookAt!.tag}
    <styleUrl>#$styleId</styleUrl>
     ${point?.tag}
  </Placemark>
''';

  String get pinOnlyTag => '''
    <Placemark>
      <Style id="${id}_icon">
        <IconStyle>
        <scale>1.0</scale> <!-- increase the size of the icon by a factor of 10 -->
          <Icon>
            <href>$icon</href>
          </Icon>
        </IconStyle>
      </Style>
      <styleUrl>#${id}_icon</styleUrl>
      ${point?.tag}
    </Placemark>
   
  ''';

  String get orbitTag => '''
    <Placemark>
      <name>Orbit - $name</name>
      <styleUrl>line-$id</styleUrl>
      ${line!.tag}
    </Placemark>
  ''';

  /// Property that defines a placemark tag which contains only a balloon.
  /// FF537DC0
  String get balloonOnlyTag => '''
    <Style id="balloon-$id">
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
      <name>$name-Balloon</name>
      <styleUrl>#balloon-$id</styleUrl>
      ${point?.tag}
      <gx:balloonVisibility>${balloonContent.isEmpty ? 0 : 1}</gx:balloonVisibility>
    </Placemark>
  ''';

  /// Returns a [Map] from the current [PlacemarkModel].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description ?? '',
      'icon': icon ?? '',
      'visibility': visibility,
      'viewOrbit': viewOrbit,
      'scale': scale,
      'balloonContent': balloonContent,
      'lookAt': lookAt?.toMap(),
      'point': point?.toMap(),
      'line': line!.toMap(),
      'tour': tour?.toMap(),
    };
  }

  /// Returns a [PlacemarkModel] from the given [map].
  factory PlacemarkModel.fromMap(Map<String, dynamic> map) {
    return PlacemarkModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
      balloonContent: map['balloonContent'],
      visibility: map['visibility'],
      viewOrbit: map['viewOrbit'],
      scale: map['scale'],
      lookAt: map['lookAt'] != null ? LookAtModel.fromMap(map['lookAt']) : null,
      point: PointModel.fromMap(map['point']),
      line: LineModel.fromMap(map['line']),
      tour: map['tour'] != null ? TourModel.fromMap(map['tour']) : null,
    );
  }
}
