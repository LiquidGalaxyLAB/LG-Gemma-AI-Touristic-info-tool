import 'package:ai_touristic_info_tool/models/kml/look_at_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/custom_balloon_gm.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/map_types_choices_widget.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/map_type_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  final String? query;
  final double zoomValue;
  const GoogleMapWidget({
    super.key,
    required this.width,
    required this.height,
    required this.initialLatValue,
    required this.initialLongValue,
    required this.initialTiltValue,
    required this.initialBearingValue,
    required this.initialCenterValue,
    this.zoomValue=14.4746,
    this.query,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController mapController) {
    _mapController = mapController;
    //Provider.of<GoogleMapProvider>(context, listen: false).mapController = mapController;
    GoogleMapProvider gmp =
        Provider.of<GoogleMapProvider>(context, listen: false);
    gmp.mapController = mapController;
    gmp.updateCameraPosition(
      CameraPosition(
        target: widget.initialCenterValue,
        // zoom: 14.4746,
        zoom: widget.zoomValue,
        bearing: widget.initialBearingValue,
        tilt: widget.initialTiltValue,
      ),
    );
  }

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
    Provider.of<GoogleMapProvider>(context, listen: false)
        .updateCameraPosition(position);
  }

  void _onCameraIdle() async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    String rigcountString = LgService(sshData).getScreenAmount() ?? '5';
    int rigcount = int.parse(rigcountString);
    final mapProvider = Provider.of<GoogleMapProvider>(context, listen: false);
    motionControls(
        mapProvider.center.latitude,
        mapProvider.center.longitude,
        mapProvider.zoomvalue / rigcount,
        mapProvider.tilt,
        mapProvider.bearing);
    if (mapProvider.center.latitude != 0 &&
        mapProvider.center.longitude != 0 &&
        mapProvider.isWorld == false) {
      mapProvider.currentFullAddress = await GeocodingService()
          .getAddressFromLatLng(
              mapProvider.center.latitude, mapProvider.center.longitude);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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
                  child: Consumer2<MapTypeProvider, GoogleMapProvider>(builder:
                      (BuildContext context, MapTypeProvider value,
                          GoogleMapProvider mapProvider, Widget? child) {
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
                              //target: mapProvider.center,
                              target: widget.initialCenterValue,
                              // zoom: 14.4746,
                              zoom: widget.zoomValue,
                              bearing: widget.initialBearingValue,
                              tilt: widget.initialTiltValue,
                            ),
                            compassEnabled: true,
                            minMaxZoomPreference:
                                MinMaxZoomPreference.unbounded,
                            tiltGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            onCameraMove: _onCameraMove,
                            onCameraIdle: _onCameraIdle,
                            markers: mapProvider.markers,
                            onMapCreated: _onMapCreated,
                            onTap: (LatLng location) {
                              setState(() {
                                mapProvider.pinPillPosition =
                                    MediaQuery.of(context).size.height * 1;
                              });
                            }),
                        CustomBalloonGoogleMaps(
                          pinPillPosition: mapProvider.pinPillPosition,
                          poi: mapProvider.currentlySelectedPin,
                          query: widget.query ?? '',
                        ),
                        GestureDetector(
                          onTap: () {
                            print(mapProvider.markers);
                            setState(() {
                              mapProvider.clearMarkers();
                              mapProvider.pinPillPosition =
                                  MediaQuery.of(context).size.height * 1;
                            });

                            print(mapProvider.markers);
                            print('cleared');
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            child: const Icon(
                              Icons.cleaning_services,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
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
