import 'dart:math';
import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/state_management/displayed_fav_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/services.dart' show Uint8List;
import 'package:ai_touristic_info_tool/services/map_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
  final Set<Marker> _customTourMainMarkers = {};
  final Set<Polyline> _polylines = {};
  final Map<Polyline, List<Marker>> _polylineMarkers = {};
  LatLng _center = const LatLng(0, 0); // Initial center
  double _zoom = 14.4746; // Initial zoom
  double _tilt = 0;
  double _bearing = 0;
  double _zoomvalue = 591657550.500000 / pow(2, 14.4746);
  BitmapDescriptor? _iconMarker;
  bool _isWorld = true;
  bool _isTourOn = false;

  // Getters for camera values

  Map<String, String?> get currentFullAddress => _currentFullAddress;
  LatLng get center => _center;
  double get zoom => _zoom;
  double get tilt => _tilt;
  double get bearing => _bearing;
  double get zoomvalue => _zoomvalue;
  Set<Marker> get markers => _markers;
  Set<Marker> get customTourMainMarkers => _customTourMainMarkers;
  Set<Polyline> get polylines => _polylines;
  Map<Polyline, List<Marker>> get polylineMarkers => _polylineMarkers;
  // PolylinePoints get polylinePoints => _polylinePoints;
  double get pinPillPosition => _pinPillPosition;
  bool get isWorld => _isWorld;
  bool get isTourOn => _isTourOn;

  set isTourOn(bool value) {
    _isTourOn = value;
    notifyListeners();
  }

  set isWorld(bool value) {
    _isWorld = value;
    notifyListeners();
  }

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

  Future<void> setBitmapDescriptor(String imagePath) async {
    final Uint8List unselected =
        await _mapService.getBytesFromAsset(width: 50, path: imagePath);
    _iconMarker = BitmapDescriptor.fromBytes(unselected);
  }

  // Add a marker
  Future<void> addMarker(BuildContext context, PlacesModel poi,
      {bool removeAll = true, bool isFromFav = false}) async {
    if (removeAll) {
      _markers.clear(); // Remove all existing markers
    }

    // final String markerId = 'marker_${_markers.length}';
    final String markerId = 'marker_${poi.id}.${poi.name}';

    DisplayedListProvider dlp =
        Provider.of<DisplayedListProvider>(context, listen: false);

    final Marker marker = Marker(
      draggable: true,
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
        if (isFromFav) {
          showDialog(
              context: context,
              builder: (context) => Consumer2<FontsProvider, ColorProvider>(
                    builder: (BuildContext context, FontsProvider value,
                        ColorProvider value2, Widget? child) {
                      return AlertDialog(
                        backgroundColor: value2.colors.innerBackground,
                        title: Text('Remove from favorites?',
                            style: TextStyle(
                              color: value.fonts.primaryFontColor,
                              fontFamily: fontType,
                              fontSize: value.fonts.textSize,
                              fontWeight: FontWeight.bold,
                            )),
                        content: Text(
                          'Do you want to remove ${poi.name} from tour?',
                          style: TextStyle(
                            color: value.fonts.primaryFontColor,
                            fontFamily: fontType,
                            fontSize: value.fonts.textSize,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                  color: LgAppColors.lgColor2,
                                  fontFamily: fontType,
                                  fontSize: value.fonts.textSize,
                                )),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              removeMarker(markerId);

                              dlp.addDisplayedPlace(poi);
                              dlp.removeTourPlace(poi);
                            },
                            child: Text('Remove',
                                style: TextStyle(
                                  color: value.fonts.primaryFontColor,
                                  fontFamily: fontType,
                                  fontSize: value.fonts.textSize,
                                )),
                          ),
                        ],
                      );
                    },
                  ));
        } else {
          print('Marker tapped: ${poi.name}');
          pinPillPosition = 10;
          currentlySelectedPin = poi;
        }
      },
      onDragEnd: (LatLng newPosition) {},
    );

    _markers.add(marker);
    _customTourMainMarkers.add(marker);
    dlp.removeDisplayedPlace(poi);
    dlp.addTourPlace(poi);
    print(dlp.displayedList);

    notifyListeners();
  }

  // // Add a polyline
  // void addPolyline(List<LatLng> polylineCoordinates) {
  //   PolylineId id = PolylineId("poly");
  //   _polylines.add(Polyline(
  //     polylineId: id,
  //     color: Colors.blue,
  //     points: polylineCoordinates,
  //     width: 4,
  //   ));
  //   notifyListeners();
  // }

  void addPolylinesBetweenMarkers() {
    List<Marker> markers = _markers.toList();
    if (markers.length < 2) return;

    _polylines.clear();

    for (int i = 0; i < markers.length - 1; i++) {
      LatLng start = markers[i].position;
      LatLng end = markers[i + 1].position;

      List<LatLng> polylineCoordinates = [start, end];

      PolylineId id = PolylineId("poly_${i}_${i + 1}");
      _polylines.add(Polyline(
        polylineId: id,
        color: LgAppColors.lgColor2,
        points: polylineCoordinates,
        width: 4,
        visible: true,
      ));
    }

    notifyListeners();
  }

  // interpolation between 2 points to get rest of straight line
  List<LatLng> interpolatePoints(LatLng start, LatLng end, int numPoints) {
    List<LatLng> points = [];
    double latStep = (end.latitude - start.latitude) / (numPoints - 1);
    double lngStep = (end.longitude - start.longitude) / (numPoints - 1);

    for (int i = 0; i < numPoints; i++) {
      double lat = start.latitude + i * latStep;
      double lng = start.longitude + i * lngStep;
      points.add(LatLng(lat, lng));
    }

    return points;
  }

  // add polyline markers for each polyline:
  void addMarkersForPolylines() {
    for (Polyline polyline in _polylines) {
      List<LatLng> polylinePoints = polyline.points;

      // Check if polyline has exactly 2 points
      if (polylinePoints.length == 2) {
        LatLng start = polylinePoints[0];
        LatLng end = polylinePoints[1];

        // Interpolate points
        List<LatLng> intermediatePoints = interpolatePoints(start, end, 5);

        // Create markers for each interpolated point
        for (LatLng point in intermediatePoints) {
          final markerId = 'marker_${point.latitude}_${point.longitude}';
          final marker = Marker(
            markerId: MarkerId(markerId),
            position: point,
            icon: _iconMarker ?? BitmapDescriptor.defaultMarker,
          );

          _markers.add(marker);
          if (_polylineMarkers[polyline] == null) {
            _polylineMarkers[polyline] = [marker];
          } else {
            _polylineMarkers[polyline]!.add(marker);
          }
        }
      }
    }

    notifyListeners();
  }

  // Clear all polylines
  void clearPolylines() {
    _polylines.clear();
    notifyListeners();
  }

  //clear custom markers
  void clearCustomMarkers() {
    _customTourMainMarkers.clear();
    notifyListeners();
  }

  //clear map
  void clearPolylinesMap() {
    _markers.clear();
    _customTourMainMarkers.clear();
    _polylines.clear();
    notifyListeners();
  }

  // Remove a marker
  void removeMarker(String markerId) {
    Marker? markerToRemove;
    for (Marker marker in _markers) {
      if (marker.markerId.value == markerId) {
        markerToRemove = marker;
        break;
      }
    }
    if (markerToRemove == null) {
      print('Marker not found');
      return;
    }

    _markers.remove(markerToRemove);

    for (Marker marker in _customTourMainMarkers) {
      if (marker.markerId.value == markerId) {
        _customTourMainMarkers.remove(marker);
        break;
      }
    }

    List<Marker> polyLineMarkersToRemove = [];

    // _markers.removeWhere((marker) => marker.markerId.value == markerId);
    List<PolylineId> polylinesToRemove = [];
    for (Polyline polyline in _polylines) {
      LatLng start = polyline.points.first;
      LatLng end = polyline.points.last;

      if ((start.latitude == markerToRemove.position.latitude &&
              start.longitude == markerToRemove.position.longitude) ||
          (end.latitude == markerToRemove.position.latitude &&
              end.longitude == markerToRemove.position.longitude)) {
        polylinesToRemove.add(polyline.polylineId);
        if (polylineMarkers[polyline] == null) continue;

        for (Marker mrkr in polylineMarkers[polyline]!) {
          polyLineMarkersToRemove.add(mrkr);
        }
      }
    }

    for (PolylineId polylineId in polylinesToRemove) {
      _polylines.removeWhere((polyline) => polyline.polylineId == polylineId);
    }

    for (Marker mrkr in polyLineMarkersToRemove) {
      _markers.remove(mrkr);
    }
    addPolylinesBetweenMarkers();

    notifyListeners();
  }

  //make a small tour-like :
  Future<void> googleMapCustomTour() async {
    List<LatLng> points = [];
    for (Marker marker in _customTourMainMarkers) {
      points.add(marker.position);
      if (_isTourOn) {
        continue;
      } else {
        break;
      }
    }
    for (LatLng point in points) {
      flyToLocation(point);
      await Future.delayed(Duration(seconds: 3));
      if (_isTourOn) {
        continue;
      } else {
        break;
      }
    }
  }

  // Clear all markers
  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }
}
