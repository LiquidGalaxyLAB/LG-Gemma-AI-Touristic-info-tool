import 'dart:math';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:flutter/services.dart' show Uint8List;
import 'package:ai_touristic_info_tool/services/map_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapProvider with ChangeNotifier {
  final MapService _mapService = MapService();

  PlacesModel currentlySelectedPin = PlacesModel(
    id: -1,
    name: '',
    address: '',
    city: '',
    country: '',
    description: '',
    ratings: 0.0,
    amenities: '',
    price: '',
    latitude: 0.0,
    longitude: 0.0,
  );
  Map<String, String?> _currentFullAddress = {};
  double _pinPillPosition = -1000;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng _center = const LatLng(0, 0); // Initial center
  double _zoom = 14.4746; // Initial zoom
  double _tilt = 0;
  double _bearing = 0;
  double _zoomvalue = 591657550.500000 / pow(2, 14.4746);
  BitmapDescriptor? _iconMarker;
  //MarkerId? _currentOpenMarkerId;

  // Getters for camera values

  
  Map<String, String?> get currentFullAddress => _currentFullAddress;
  LatLng get center => _center;
  double get zoom => _zoom;
  double get tilt => _tilt;
  double get bearing => _bearing;
  double get zoomvalue => _zoomvalue;
  Set<Marker> get markers => _markers;
  double get pinPillPosition => _pinPillPosition;

  set currentFullAddress(Map<String, String?> address) {
    _currentFullAddress = address;
    notifyListeners();
  }

  set pinPillPosition(double position) {
    _pinPillPosition = position;
    notifyListeners();
  }

  // Setter for the map controller
  set mapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void updateZoom(double zoom) {
    _zoom = zoom;
    _zoomvalue = 591657550.500000 / pow(2, zoom);
    notifyListeners();
  }

  void updateTilt(double tilt) {
    _tilt = tilt;
    notifyListeners();
  }

  void updateBearing(double bearing) {
    _bearing = bearing;
    notifyListeners();
  }

  // Method to update camera position
  void updateCameraPosition(CameraPosition position) {
    _center = position.target;
    _zoom = position.zoom;
    _zoomvalue = 591657550.500000 / pow(2, position.zoom);
    _tilt = position.tilt;
    _bearing = position.bearing;
    
    notifyListeners(); // Notify listeners of changes
  }

  // Fly to location method
  void flyToLocation(LatLng targetLocation) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: targetLocation,
          //zoom: 14.4746,
          zoom: _zoom,
          bearing: _bearing,
          tilt: _tilt,
        ),
      ),
    );
    notifyListeners();
  }

  Future<void> setBitmapDescriptor() async {
    final Uint8List unselected = await _mapService.getBytesFromAsset(
        width: 100, path: "assets/images/placemark_pin.png");
    _iconMarker = BitmapDescriptor.fromBytes(unselected);
  }

  // Add a marker
  Future<void> addMarker(BuildContext context, PlacesModel poi,
      {bool removeAll = true}) async {
    if (removeAll) {
      _markers.clear(); // Remove all existing markers
    }

    final String markerId = 'marker_${_markers.length}';

    final Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(poi.latitude, poi.longitude),
      consumeTapEvents: true,
      infoWindow: InfoWindow(
        title: poi.name,
        snippet: poi.description,
        onTap: () {
          print('Info window tapped: ${poi.name}');
          pinPillPosition = 10;
          currentlySelectedPin = poi;
        },
      ),
      icon: _iconMarker ?? BitmapDescriptor.defaultMarker,
      onTap: () {
        print('Marker tapped: ${poi.name}');
        pinPillPosition = 10;
        currentlySelectedPin = poi;
      },
    );

    _markers.add(marker);

    notifyListeners();
  }

  // Remove a marker
  void removeMarker(String markerId) {
    _markers.removeWhere((marker) => marker.markerId.value == markerId);
    notifyListeners();
  }

  // Clear all markers
  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }
}
