import 'dart:math';

import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/map_types_choices_widget.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/map_type_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapWidget extends StatefulWidget {
  final double width;
  final double height;
  final double initialLatValue;
  final double initialLongValue;
  final double initialTiltValue;
  final double initialBearingValue;
  final LatLng initialCenterValue;
  const GoogleMapWidget({
    super.key,
    required this.width,
    required this.height,
    required this.initialLatValue,
    required this.initialLongValue,
    required this.initialTiltValue,
    required this.initialBearingValue,
    required this.initialCenterValue,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  Set<Circle> _circles = {};

  double _zoomvalue = 591657550.500000 / pow(2, 13.15393352508545);
  late double _latvalue;
  late double _longvalue;
  late double _tiltvalue;
  late double _bearingvalue;
  late LatLng _center;

  motionControls(double updownflag, double rightleftflag, double zoomflag,
      double tiltflag, double bearingflag) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    LookAtModel flyto = LookAtModel(
      longitude: rightleftflag,
      latitude: updownflag,
      range: zoomflag.toString(),
      tilt: tiltflag.toString(),
      heading: bearingflag.toString(),
    );
    try {
      await LgService(sshData).flyTo(flyto);
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  void _onCameraMove(CameraPosition position) {
    _bearingvalue = position.bearing; // 2D angle
    _longvalue = position.target.longitude; // lat lng
    _latvalue = position.target.latitude;
    _tiltvalue = position.tilt; // 3D angle
    _zoomvalue = 591657550.500000 / pow(2, position.zoom);
  }

  void _onCameraIdle() {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    String rigcountString = LgService(sshData).getScreenAmount() ?? '5';
    int rigcount = int.parse(rigcountString);
    motionControls(_latvalue, _longvalue, _zoomvalue / rigcount, _tiltvalue,
        _bearingvalue);
  }

  void _onMapCreated(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void _addMarker() {
    setState(() {
      _clearShapes();
      _markers.add(Marker(
        markerId: MarkerId("marker"),
        position: _center,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _addPolygon() {
    _clearShapes();
    _polygons.add(Polygon(
      polygonId: PolygonId('polygon'),
      points: _createPoints(),
      strokeWidth: 2,
      strokeColor: Colors.red,
      fillColor: Colors.blue.withOpacity(0.5),
    ));
  }

  List<LatLng> _createPoints() {
    List<LatLng> points = [];

    points.add(LatLng(22.5726, 88.3639));
    points.add(LatLng(22.5726, 88.3739));
    points.add(LatLng(22.5826, 88.3739));
    points.add(LatLng(22.5826, 88.3639));
    points.add(LatLng(22.5726, 88.3639));

    return points;
  }

  void _addCircle() {
    setState(() {
      _clearShapes();
      _circles.add(Circle(
        circleId: CircleId('circle'),
        center: _center,
        radius: 2000,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 3,
        strokeColor: Colors.red,
      ));
    });
  }

  void _clearShapes() {
    setState(() {
      _markers.clear();
      _polygons.clear();
      _circles.clear();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _latvalue = widget.initialLatValue;
    _longvalue = widget.initialLongValue;
    _tiltvalue = widget.initialTiltValue;
    _bearingvalue = widget.initialBearingValue;
    _center = widget.initialCenterValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AnimationLimiter(
        child: Row(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(seconds: 10),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 5,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              SizedBox(
                height: widget.height,
                width: widget.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Consumer<MapTypeProvider>(builder:
                      (BuildContext context, MapTypeProvider value,
                          Widget? child) {
                    return Stack(
                      children: [
                        GoogleMap(
                          gestureRecognizers: Set()
                            ..add(Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer())),
                          mapType: value.currentView == 'normal'
                              ? MapType.normal
                              : value.currentView == 'satellite'
                                  ? MapType.satellite
                                  : MapType.terrain,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 14.4746,
                            bearing: _bearingvalue,
                            tilt: _tiltvalue,
                          ),
                          compassEnabled: true,
                          onTap: (LatLng latLng) {
                            print('Tapped: $latLng');
                            setState(() {
                              _center = latLng;
                            });
                          },
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          tiltGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          onCameraMove: _onCameraMove,
                          onCameraIdle: _onCameraIdle,
                          circles: _circles,
                          polygons: _polygons,
                          markers: _markers,
                          onMapCreated: _onMapCreated,
                        ),
                        // Container(
                        //   alignment: Alignment.topRight,
                        //   margin: const EdgeInsets.only(top: 10, right: 10),
                        //   child: Column(
                        //     children: [
                        //       FloatingActionButton(
                        //         onPressed: _addMarker,
                        //         child: const Icon(Icons.add_location),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      SizedBox(width: widget.width, child: const MapTypeChoicesWidget()),
    ]);
  }
}
