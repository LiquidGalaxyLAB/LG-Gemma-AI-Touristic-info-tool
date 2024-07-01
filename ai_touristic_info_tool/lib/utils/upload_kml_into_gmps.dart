import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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