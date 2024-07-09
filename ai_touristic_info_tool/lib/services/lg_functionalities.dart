

import '../models/kml/KMLModel.dart';
import '../models/kml/look_at_model.dart';
import '../models/kml/screen_overlay_model.dart';
import '../state_management/ssh_provider.dart';
import 'kml_file_services.dart';

///This class is responsible for the connection between the LG machine and the Tablet application
///The LG service needed such as shutting down the LG, Rebooting the LG, Relaunching the LG
///As well as common functionalities assosiated with the LG such as Fly-to, orbit, sending KML files, Clearing KML, Shwowing Ballons and Logos

class LgService {
  /// An instance of [SSHprovider] class
  final SSHprovider _sshData;
  LgService(this._sshData);

  /// An instance of [FileService] class
  final _fileService = FileService();

  /// Property that defines the master rig url.
  final String _url = 'http://lg1:81';

  /// Property that defines number of screens. Defaults to `5`.
  int screenAmount = 5;

  /// Lg order:  if 5 => 5 4 1 2 3   if 3 => 3 1 2

  /// Property that defines the logo slave screen number according to the [screenAmount] property. (Most left screen)
  int get logoScreen {
    int sA = int.parse(getScreenAmount()!);
    if (sA == 1) {
      return 1;
    }

    // Gets the most left screen.
    return (sA / 2).floor() + 2;
  }

  /// Property that defines the balloon slave screen number according to the [screenAmount] property. (Most right screen)
  int get balloonScreen {
    int sA = int.parse(getScreenAmount()!);
    if (sA == 1) {
      return 1;
    }

    // Gets the most right screen.
    return (sA / 2).floor() + 1;
  }

  ///Liquid Galaxy Services:
  ///-----------------------

  /// Gets the Liquid Galaxy rig screen amount. Returns a [String] that represents the screen amount.
  String? getScreenAmount() {
    int numberOfScreen = _sshData.numberOfScreens!;
    screenAmount = numberOfScreen;
    String? result = numberOfScreen.toString();
    return result;
  }

  /// Relaunching the Liquid Galaxy System:
  /// We used to type: --lg-relaunch  in terminal
  Future<void> relaunch() async {
    final pw = _sshData.passwordOrKey;
    final user = _sshData.username;

    final result = await getScreenAmount();
    if (result != null) {
      screenAmount = int.parse(result);
    }

    for (var i = screenAmount; i >= 1; i--) {
      try {
        final relaunchCommand = """RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  echo $pw | sudo -S service \\\${SERVICE} start
else
  echo $pw | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p $pw ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        await _sshData.client!
            .execute("'/home/$user/bin/lg-relaunch' > /home/$user/log.txt");

        await _sshData.client!.execute(relaunchCommand);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Reboots the Liquid Galaxy system.
  /// We used to write sudo reboot  in the terminal, but we need a way to add the password and the LG number too here
  Future<void> reboot() async {
    final pw = _sshData.passwordOrKey;

    final result = await getScreenAmount();
    if (result != null) {
      screenAmount = int.parse(result);
    }

    for (var i = screenAmount; i > 1; i--) {
      try {
        await _sshData
            .execute('sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    try {
      await _sshData
          .execute('sshpass -p $pw ssh -t lg1 "echo $pw | sudo -S reboot"');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /// Shuts down the Liquid Galaxy system.
  Future<void> shutdown() async {
    final pw = _sshData.passwordOrKey;

    final result = await getScreenAmount();
    if (result != null) {
      screenAmount = int.parse(result);
    }

    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _sshData.execute(
            'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"');
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  /// Setups the Google Earth in slave screens to refresh every 2 seconds.
  Future<void> setRefresh() async {
    final pw = _sshData.passwordOrKey;

    const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
    const replace =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    final command =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    final clear =
        'echo $pw | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= screenAmount; i++) {
      final clearCmd = clear.replaceAll('{{slave}}', i.toString());
      final cmd = command.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'{{cmd}}\'';

      try {
        await _sshData.execute(query.replaceAll('{{cmd}}', clearCmd));
        await _sshData.execute(query.replaceAll('{{cmd}}', cmd));
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    await reboot();
  }

  /// Setups the Google Earth in slave screens to stop refreshing.
  Future<void> resetRefresh() async {
    final pw = _sshData.passwordOrKey;

    const search =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    const replace = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';

    final clear =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= screenAmount; i++) {
      final cmd = clear.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'$cmd\'';

      try {
        await _sshData.execute(query);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    await reboot();
  }

  /// Puts the given [content] into the `/tmp/query.txt` file.
  Future<void> query(String content) async {
    await _sshData.execute('echo "$content" > /tmp/query.txt');
  }

  ///Fly to functionality:
  /// Command to fly to a certain location: 'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt'
  /// Uses the [query] method to fly to some place in Google Earth according to the given [lookAt].
  /// See [LookAtModel].
  Future<void> flyTo(LookAtModel lookAt) async {
    try {
      await query('flytoview=${lookAt.linearTag}');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  ///Orbit functionality:
  /// Uses the [query] method to play some tour in Google Earth according to  the given [tourName].
  /// Command: 'echo "playtour=Orbit" > /tmp/query.txt'
  Future<void> startTour(String tourName) async {
    try {
      print('here play tour');
      await query('playtour=$tourName');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /// Uses the [query] method to stop all tours in Google Earth.
  Future<void> stopTour() async {
    try {
      await query('exittour=true');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  ///KML services:
  ///------------

  ///Visualizing the uploaded KML on LG command: echo "http://lg1:81/$projectname.kml" > /var/www/html/kmls.txt'
  ///Sending tour to the Google Earth using the KML file and the tourname ex: Orbit
  /// Sends and starts a `tour` into the Google Earth.
  Future<void> sendTour(String tourKml, String tourName) async {
    final fileName = '$tourName.kml';
    try {
      final kmlFile = await _fileService.createFile(fileName, tourKml);

      await _sshData.uploadKml(kmlFile, fileName);
      print('kml uploaded');

      await _sshData
          .execute('echo "\n$_url/$fileName" >> /var/www/html/kmls.txt');
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  /// Sets the logos KML into the Liquid Galaxy rig. A KML [name] and [content] may be passed, but it's not required.
  Future<void> setLogos({
    String name = 'App-logos',
    String content = '<name>Logos</name>',
  }) async {
    final screenOverlay = ScreenOverlayModel.logos();

    final kml = KMLModel(
      name: name,
      content: content,
      screenOverlay: screenOverlay.tag,
    );
    try {
      await sendKMLToSlave(logoScreen, kml.body);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /// Sends a KML [content] to the given slave [screen].
  Future<void> sendKMLToSlave(int screen, String content) async {
    print('inside kml slave');
    try {
      await _sshData
          .execute("echo '$content' > /var/www/html/kml/slave_$screen.kml");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateKMLonSlave(int screen, String content) async {
    try {
      await _sshData
          .execute("echo '$content' >> /var/www/html/kml/slave_$screen.kml");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /// Sends a the given [kml] to the Liquid Galaxy system.
  ///
  /// It also accepts a [List] of images represents by [Map]s. The [images] must
  /// have the following pattern:
  /// ```
  /// [
  ///   {
  ///     'name': 'img-1.png',
  ///     'path': 'path/to/img-1'
  ///   },
  ///   {
  ///     'name': 'img-2.png',
  ///     'path': 'path/to/img-2'
  ///   }
  /// ]
  /// ```
  Future<void> sendKml(KMLModel kml,
      {List<Map<String, String>> images = const []}) async {
    final fileName = '${kml.name}.kml';

    for (var img in images) {
      final image = await _fileService.createImage(img['name']!, img['path']!);
      String imageName = img['name']!;
      try {
        await _sshData.uploadKml(image, imageName);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
    try {
      final kmlFile = await _fileService.createFile(fileName, kml.body);
      await _sshData.uploadKml(kmlFile, fileName);
      await _sshData.execute('echo "$_url/$fileName" > /var/www/html/kmls.txt');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> sendKmlPlacemarks(String kml, String placemarkName) async {
    print(' inside kml placemarks');
    final fileName = '$placemarkName.kml';
    try {
      final kmlFile = await _fileService.createFile(fileName, kml);
    

      await _sshData.uploadKml(kmlFile, fileName);

      await _sshData
          .execute('echo "\n$_url/$fileName" > /var/www/html/kmls.txt');
      print('after execute');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  /// Clears all `KMLs` from the Google Earth. The [keepLogos] keeps the logos
  /// after clearing (default to `true`).
  Future<void> clearKml({bool keepLogos = true}) async {
    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';
    for (var i = 2; i <= screenAmount; i++) {
      String blankKml = KMLModel.generateBlank('slave_$i');
      query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
    }

    if (keepLogos) {
      final kml = KMLModel(
        name: 'HAPIS-logos',
        content: '<name>Logos</name>',
        screenOverlay: ScreenOverlayModel.logos().tag,
      );

      query +=
          " && echo '${kml.body}' > /var/www/html/kml/slave_$logoScreen.kml";
    }
    try {
      await _sshData.execute(query);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
