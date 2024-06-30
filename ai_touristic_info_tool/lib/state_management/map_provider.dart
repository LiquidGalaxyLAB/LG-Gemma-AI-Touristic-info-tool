// import 'package:ai_touristic_info_tool/models/places_model.dart';
// import 'package:ai_touristic_info_tool/services/map_services.dart';
// import 'package:ai_touristic_info_tool/utils/custom_marker.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/services.dart' show Uint8List;

// class MapProvider with ChangeNotifier {
//   final MapService _mapService = MapService();

//   final List<PlacesModel> pois = [];
//   LatLng? _center;

//   LatLng? get center => _center;

//   set center(LatLng? center) {
//     _center = center;
//     notifyListeners();
//   }

//   PlacesModel? _selectedPoi;
//   PlacesModel? get selectedPoi => _selectedPoi;
//   set selectedPoi(PlacesModel? poi) => throw "error";

//   final List<Marker> _markers = [];
//   Set<Marker> get markers => {..._markers};
//   set markers(Set<Marker> s) => throw "error";

//   BitmapDescriptor? _unselectedIconMarker;
//   BitmapDescriptor? _selectedIconMarker;

//   Future<void> init() async {
//     await _setBitmapDescriptor();
//     _setIconMarkers();
//     print('here inside init');
//   }

//   Future<void> _setBitmapDescriptor() async {
//     final Uint8List unselected = await _mapService.getBytesFromAsset(
//         width: 100, path: "assets/images/placemark_pin.png");
//     _unselectedIconMarker = BitmapDescriptor.fromBytes(unselected);
//     final Uint8List selected = await _mapService.getBytesFromAsset(
//         width: 140, path: "assets/images/placemark_pin.png");
//     _selectedIconMarker = BitmapDescriptor.fromBytes(selected);
//   }

//   void _setIconMarkers() {
//     if (_unselectedIconMarker == null) return;
//     for (int i = 0; i < pois.length; i++) {
//       PlacesModel poi = pois[i];
//       _markers.add(CustomMarker(
//           icon: _unselectedIconMarker!,
//           poi: poi,
//           onTapPlace: onTapPoi,
//           id: (i + 1)));
//     }
//     notifyListeners();
//   }

//   Future<void> onTapPoi(PlacesModel poi) async {
//     _selectedPoi = poi;
//     if (_selectedIconMarker == null) return;
//     _markers.removeWhere(
//         (Marker marker) => marker.markerId.value == poi.id.toString());
//     _markers.add(CustomMarker(
//         icon: _selectedIconMarker!,
//         id: poi.id,
//         poi: poi,
//         onTapPlace: onTapPoi));
//     notifyListeners();
//   }

//   void addPoi(PlacesModel poi) {
//     pois.add(poi);
//     _markers.add(CustomMarker(
//         icon: _unselectedIconMarker!,
//         poi: poi,
//         onTapPlace: onTapPoi,
//         id: pois.length));
//     notifyListeners();
//   }

//   void removePoi(PlacesModel poi) {
//     pois.remove(poi);
//     _markers
//         .removeWhere((marker) => marker.markerId.value == poi.id.toString());
//     notifyListeners();
//   }
// }
