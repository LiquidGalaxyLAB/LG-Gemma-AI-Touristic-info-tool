import 'dart:async';
import 'dart:math';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/map_types_choices_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/map_type_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  Set<Circle> _circles = {};

  double zoomvalue = 591657550.500000 / pow(2, 13.15393352508545);
  double latvalue = 28.65665656297236;
  double longvalue = -17.885454520583153;
  double tiltvalue = 41.82725143432617;
  double bearingvalue = 61.403038024902344;

  LatLng _center = const LatLng(28.65665656297236, -17.885454520583153);

  // final CameraPosition _kGoogle = const CameraPosition(
  //   target: LatLng(22.5726, 88.3639),
  //   zoom: 14.4746,
  //   bearing: 61.403038024902344,
  //   tilt: 41.82725143432617,
  // );

  motionControls(double updownflag, double rightleftflag, double zoomflag,
      double tiltflag, double bearingflag) async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);

    ///checking the connection status first

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
    bearingvalue = position.bearing; // 2D angle
    longvalue = position.target.longitude; // lat lng
    latvalue = position.target.latitude;
    tiltvalue = position.tilt; // 3D angle
    zoomvalue = 591657550.500000 / pow(2, position.zoom);
  }

  void _onCameraIdle() {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    String rigcountString = LgService(sshData).getScreenAmount() ?? '5';
    int rigcount = int.parse(rigcountString);
    motionControls(
        latvalue, longvalue, zoomvalue / rigcount, tiltvalue, bearingvalue);
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBarWidget(
          child: Center(
            child: Text(
              'Welcome to your Home page!',
              style: TextStyle(
                fontFamily: fontType,
                fontSize: headingSize,
                color: FontAppColors.secondaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Consumer<MapTypeProvider>(builder:
                        (BuildContext context, MapTypeProvider value,
                            Widget? child) {
                      return Stack(
                        children: [
                          GoogleMap(
                            mapType: value.currentView == 'normal'
                                ? MapType.normal
                                : value.currentView == 'satellite'
                                    ? MapType.satellite
                                    : MapType.terrain,
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 14.4746,
                              bearing: bearingvalue,
                              tilt: tiltvalue,
                            ),
                            compassEnabled: true,
                            onTap: (LatLng latLng) {
                              print('Tapped: $latLng');
                              setState(() {
                                _center = latLng;
                              });
                            },
                            minMaxZoomPreference:
                                MinMaxZoomPreference.unbounded,
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
                          Container(
                            alignment: Alignment.topRight,
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            child: Column(
                              children: [
                                FloatingActionButton(
                                  onPressed: _addMarker,
                                  child: const Icon(Icons.add_location),
                                ),
                                // FloatingActionButton(
                                //   onPressed: _addPolygon,
                                //   child: const Icon(Icons.add),
                                // ),
                                // FloatingActionButton(
                                //   onPressed: _addCircle,
                                //   child: const Icon(Icons.add_circle),
                                // ),
                              ],
                            ),
                          )
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
        const MapTypeChoicesWidget()
      ],
    );
  }
}
