import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_map_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/map_types_choices_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
        GoogleMapWidget(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.7,
          initialLatValue: 28.65665656297236,
          initialLongValue: -17.885454520583153,
          initialTiltValue: 41.82725143432617,
          initialBearingValue: 61.403038024902344,
          initialCenterValue:
              const LatLng(28.65665656297236, -17.885454520583153),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        const MapTypeChoicesWidget()
      ],
    );
  }
}
