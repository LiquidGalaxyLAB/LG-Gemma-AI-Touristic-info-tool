import 'dart:math';
import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/state_management/displayed_fav_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/utils/get_bytes_from_assets.dart';
import 'package:flutter/services.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

/// [GoogleMapProvider] is a provider class responsible for managing the state and logic 
/// related to Google Maps in the application. It provides methods to add, remove, and 
/// update markers on the map, as well as methods to update the camera position and
/// fly to a specific location. It also manages the state of the map controller, the
/// current full address, the pin pill position, and the custom tour mode.

class GoogleMapProvider with ChangeNotifier {

  /// [currentlySelectedPin] is a [PlacesModel] object that represents the currently selected pin on the map.
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
  /// [currentFullAddress] is a [Map] object that represents the current full address of the selected pin.
  Map<String, String?> _currentFullAddress = {};

  /// [pinPillPosition] is a [double] value that represents the position of the pin pill on the map.
  double _pinPillPosition = -1000;
  
  /// [_mapController] is a [GoogleMapController] object that represents the map controller.
  GoogleMapController? _mapController;

  /// [_markers] is a [Set] of [Marker] objects that represents the markers on the map.
  final Set<Marker> _markers = {};

  /// [_customTourMainMarkers] is a [Set] of [Marker] objects that represents the custom tour main markers on the map.
  final Set<Marker> _customTourMainMarkers = {};

  /// [_polylines] is a [Set] of [Polyline] objects that represents the polylines on the map.
  final Set<Polyline> _polylines = {};

  /// [_polylineMarkers] is a [Map] object that represents the polyline markers on the map.
  final Map<Polyline, List<Marker>> _polylineMarkers = {};

  /// [_center] is a [LatLng] object that represents the initial center of the map.
  LatLng _center = const LatLng(0, 0); // Initial center

  /// [_zoom] is a [double] value that represents the initial zoom of the map.
  double _zoom = 14.4746; // Initial zoom

  /// [_tilt] is a [double] value that represents the initial tilt of the map.
  double _tilt = 0;

  /// [_bearing] is a [double] value that represents the initial bearing of the map.
  double _bearing = 0;

  /// [_zoomvalue] is a [double] value that represents the initial zoom value of the map.
  double _zoomvalue = 591657550.500000 / pow(2, 14.4746);

  /// [_iconMarker] is a [BitmapDescriptor] object that represents the icon marker on the map.
  BitmapDescriptor? _iconMarker;

  /// [_isWorld] is a [bool] value that represents whether the map is in world mode.
  bool _isWorld = true;

  /// [_isTourOn] is a [bool] value that represents whether the tour is on.
  bool _isTourOn = false;

  /// [_allowSync] is a [bool] value that represents whether the map is allowed to sync with LG or not.
  bool _allowSync = true;

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
  double get pinPillPosition => _pinPillPosition;
  bool get isWorld => _isWorld;
  bool get isTourOn => _isTourOn;
  bool get allowSync => _allowSync;

  set allowSync(bool value) {
    _allowSync = value;
    notifyListeners();
  }

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

  /// [updateCameraPosition] method updates the camera position of the map.
  /// It takes a [CameraPosition] object representing the new camera position and updates the camera position of the map.
  /// The method is asynchronous and returns a [Future] of [void].
  void updateCameraPosition(CameraPosition position) {
    _center = position.target;
    _zoom = position.zoom;
    _zoomvalue = 591657550.500000 / pow(2, position.zoom);
    _tilt = position.tilt;
    _bearing = position.bearing;

    notifyListeners();
  }

  /// [flyToLocation] method animates the camera to fly to a specific location on the map.
  /// It takes a [LatLng] object representing the target location and animates the camera to fly to that location.
  /// The method is asynchronous and returns a [Future] of [void].
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
 
  /// [setBitmapDescriptor] method sets the bitmap descriptor for the icon marker on the map.
  /// It takes an [imagePath] parameter and sets the bitmap descriptor from the given image path.
  /// The image is converted to bytes and then set as the bitmap descriptor for the icon marker.
  /// The method is asynchronous and returns a [Future] of [void].
  Future<void> setBitmapDescriptor(String imagePath) async {
    final Uint8List dataBytes =
        await getBytesFromAsset(width: 50, path: imagePath);
    _iconMarker = BitmapDescriptor.fromBytes(dataBytes);
  }

  /// [addMarker] method adds a marker to the map.
  /// It takes a [BuildContext] object, a [PlacesModel] object, and optional parameters [removeAll] and [isFromFav].
  /// It adds a marker to the map with the given [poi] object and sets the marker's info window to display the name and description of the place.
  /// If [removeAll] is true, it removes all existing markers from the map before adding the new marker.
  /// If [isFromFav] is true, it adds the marker to the custom tour main markers set and removes the place from the displayed places list and adds it to the tour places list.
  Future<void> addMarker(BuildContext context, PlacesModel poi,
      {bool removeAll = true, bool isFromFav = false}) async {
    if (removeAll) {
      _markers.clear();
    }

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
          pinPillPosition = 10;
          currentlySelectedPin = poi;
        }
      },
      onDragEnd: (LatLng newPosition) {},
    );

    _markers.add(marker);
    //added this new if condition:
    if (isFromFav) {
      _customTourMainMarkers.add(marker);
      dlp.removeDisplayedPlace(poi);
      dlp.addTourPlace(poi);
    }

    notifyListeners();
  }



  /// [addPolylinesBetweenMarkers] method adds polylines between the markers on the map.
  /// It takes no parameters and adds polylines between the markers on the map.
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

  /// [interpolatePoints] method interpolates points between two given points.
  /// It takes two [LatLng] objects representing the start and end points, and an [int] value representing the number of points to interpolate.
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

  /// [addMarkersForPolylines] method adds markers for the polylines on the map.
  /// It takes no parameters and adds markers for the polylines on the map.
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
