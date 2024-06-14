import 'dart:async';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  // GoogleMapController _googleMapController;
  // Marker _origin;
  // Marker _destination;

  // @override
  // void dispose() {
  //   _googleMapController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
        child: Column(
            children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(seconds: 10),
                childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 5,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
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
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ],
              ),
            ),
          )
        ])));

    // Column(
    //   children: [
    //     TopBarWidget(
    //       child: Center(
    //         child: Text(
    //           'Welcome to your Home page!',
    //           style: TextStyle(
    //             fontFamily: fontType,
    //             fontSize: headingSize,
    //             color: FontAppColors.secondaryFont,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 20),
    //     Expanded(
    //       child: Container(
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(40),
    //           color: PrimaryAppColors.innerBackground,
    //         ),
    //         child: GoogleMap(
    //           mapType: MapType.hybrid,
    //           initialCameraPosition: _kGooglePlex,
    //           onMapCreated: (GoogleMapController controller) {
    //             _controller.complete(controller);
    //           },
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 20),
    //   ],
    // );
  }
}
