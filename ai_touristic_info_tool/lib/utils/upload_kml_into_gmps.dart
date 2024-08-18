import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


/// Adds a KML (Keyhole Markup Language) layer to the Google Map managed by the given [mapController].
///
/// This function interacts with platform-specific code to load and display a KML layer on the map.
/// It uses method channels to communicate with the native Android or iOS code.
///
/// Parameters:
/// - [mapController]: The [GoogleMapController] that manages the Google Map instance.
///
/// Throws:
/// - A [PlatformException] if there is an issue with invoking the method to add the KML layer.
/// - A general exception if any other error occurs during the process.
///
/// Usage:
/// ```dart
/// await addKml(mapController);
/// ```
/// 
Future<void> addKml(GoogleMapController mapController) async {
    print('addKml');
    var mapId = mapController.mapId;
    const MethodChannel channel = MethodChannel('flutter.native/helper');
    final MethodChannel kmlchannel = MethodChannel('plugins.flutter.dev/google_maps_android_${mapId}');
    try {
      int kmlResourceId = await channel.invokeMethod('map#addKML');
 
      var c = kmlchannel.invokeMethod("map#addKML", <String, dynamic>{
        'resourceId': kmlResourceId,
      });
      print('addKml done${c}');
    } on PlatformException catch (e) {
      throw 'Unable to plot map: ${e.message}';
    }catch(e){
      print("error");
      throw 'Unable to plot map${e}';
    }
  }