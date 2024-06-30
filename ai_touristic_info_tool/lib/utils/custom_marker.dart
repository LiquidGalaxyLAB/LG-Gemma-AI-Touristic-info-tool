import 'dart:async';
import 'dart:ui';

import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker extends Marker {
  final PlacesModel poi;
  final int id;
  final FutureOr<void> Function(PlacesModel poi) onTapPlace;

  CustomMarker(
      {required this.poi,
      required super.icon,
      required this.id,
      bool hasBubble = false,
      required this.onTapPlace})
      : super(
          markerId: MarkerId(id.toString()),
          position: LatLng(poi.latitude, poi.longitude),
          consumeTapEvents: true,

          /// do avoid camera moving
          anchor: !hasBubble ? const Offset(0.5, 0.5) : const Offset(0.1, 0.8),
          onTap: () async => await onTapPlace(poi),
        );
}
