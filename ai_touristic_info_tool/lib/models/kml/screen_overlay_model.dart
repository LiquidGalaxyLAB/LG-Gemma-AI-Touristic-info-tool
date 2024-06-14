/// Class that defines the `screen overlay` entity, which contains its properties and methods.
/// Used for displaying the ballons and the logos
library;

class ScreenOverlayModel {
  /// Property that defines the screen overlay `name`.
  String name;

  /// Property that defines the screen overlay `icon url`.
  String icon;

  /// Property that defines the screen overlay `overlayX`.
  double overlayX;

  /// Property that defines the screen overlay `overlayY`.
  double overlayY;

  /// Property that defines the screen overlay `screenX`.
  double screenX;

  /// Property that defines the screen overlay `screenY`.
  double screenY;

  /// Property that defines the screen overlay `sizeX`.
  double sizeX;

  /// Property that defines the screen overlay `sizeY`.
  double sizeY;

  ScreenOverlayModel({
    required this.name,
    this.icon = '',
    required this.overlayX,
    required this.overlayY,
    required this.screenX,
    required this.screenY,
    required this.sizeX,
    required this.sizeY,
  });

  /// Property that defines the screen overlay `tag` according to its current
  /// properties.
  ///
  /// Example
  /// ```
  /// ScreenOverlay screenOverlay = ScreenOverlay(
  ///   name: "Overlay",
  ///   this.icon = 'https://google.com/...',
  ///   overlayX = 0,
  ///   overlayY = 0,
  ///   screenX = 0,
  ///   screenY = 0,
  ///   sizeX = 0,
  ///   sizeY = 0,
  /// )
  ///
  /// screenOverlay.tag => '''
  ///   <ScreenOverlay>
  ///     <name>Overlay</name>
  ///     <Icon>
  ///       <href>https://google.com/...</href>
  ///     </Icon>
  ///     <overlayXY x="0" y="0" xunits="fraction" yunits="fraction"/>
  ///     <screenXY x="0" y="0" xunits="fraction" yunits="fraction"/>
  ///     <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
  ///     <size x="0" y="0" xunits="pixels" yunits="pixels"/>
  ///   </ScreenOverlay>
  /// '''
  /// ```
  String get tag => '''
      <ScreenOverlay>
        <name>$name</name>
        <Icon>
          <href>$icon</href>
        </Icon>
        <color>ffffffff</color>
        <overlayXY x="$overlayX" y="$overlayY" xunits="fraction" yunits="fraction"/>
        <screenXY x="$screenX" y="$screenY" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="$sizeX" y="$sizeY" xunits="pixels" yunits="pixels"/>
      </ScreenOverlay>
    ''';

  /// Generates a [ScreenOverlayModel] with the logos data in it.
  factory ScreenOverlayModel.logos() {
    return ScreenOverlayModel(
      name: 'LogoSO',
      icon:
          'https://github.com/Mahy02/LG-KISS-AI-App/blob/main/assets/images/Logos_Screen.jpg?raw=true',
//1980 × 1080 px  710 × 387 px
      overlayX: 0,
      overlayY: 1,
      screenX: 0.02,
      screenY: 0.95,
      // sizeX: 710,
      // sizeY: 387,

      sizeX: 355.5, // reduce the size by 50%
      sizeY: 193.5, // reduce the size by 50%
    );
  }
}
