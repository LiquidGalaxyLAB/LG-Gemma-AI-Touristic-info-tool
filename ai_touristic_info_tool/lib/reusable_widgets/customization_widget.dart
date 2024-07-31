import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomizationWidget extends StatefulWidget {
  final List<PlacesModel> chosenPlaces;
  const CustomizationWidget({super.key, required this.chosenPlaces});

  @override
  State<CustomizationWidget> createState() => _CustomizationWidgetState();
}

class _CustomizationWidgetState extends State<CustomizationWidget> {
  PlacesModel? _draggedPlace;
  final ScrollController _scrollController = ScrollController();
  List<PlacesModel> _tourPlaces = [];
  List<PlacesModel> displayedPlaces = [];

  @override
  void initState() {
    super.initState();
    displayedPlaces = List.from(widget.chosenPlaces);
  }

  void _onPlaceDropped() {
    GoogleMapProvider gmp =
        Provider.of<GoogleMapProvider>(context, listen: false);
    gmp.flyToLocation(
        LatLng(_draggedPlace!.latitude, _draggedPlace!.longitude));
    if (_draggedPlace != null) {
      gmp.addMarker(context, _draggedPlace!, removeAll: false);
      setState(() {
        displayedPlaces.remove(_draggedPlace);
        _draggedPlace = null;
      });
    }
  }

  void _onPlaceReturned() {
    String markerId = 'marker_${_draggedPlace!.id}.${_draggedPlace!.name}';
    GoogleMapProvider gmp =
        Provider.of<GoogleMapProvider>(context, listen: false);
    gmp.removeMarker(markerId);
    setState(() {
      displayedPlaces.add(_draggedPlace!);

      _draggedPlace = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontVal,
          ColorProvider colorVal, Widget? child) {
        return Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 20,
                  ),
                  child: Text(
                    'Drag and Drop places to and from map!',
                    style: TextStyle(
                        color: fontVal.fonts.primaryFontColor,
                        fontSize: fontVal.fonts.textSize + 5,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontType),
                  ),
                ),
                Row(
                  children: [
                    DragTarget<PlacesModel>(
                      onAcceptWithDetails: (details) {
                        // RenderBox renderBox = context.findRenderObject() as RenderBox;
                        // Offset offset = renderBox.globalToLocal(details.offset);

                        _onPlaceDropped();
                      },
                      builder: (
                        BuildContext context,
                        List<PlacesModel?> candidateData,
                        List<dynamic> rejectedData,
                      ) {
                        return GoogleMapWidget(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width * 0.65,
                          initialLatValue: widget.chosenPlaces[0].latitude,
                          initialLongValue: widget.chosenPlaces[0].longitude,
                          initialTiltValue: 41.82725143432617,
                          initialBearingValue: 61.403038024902344,
                          initialCenterValue: LatLng(
                              widget.chosenPlaces[0].latitude,
                              widget.chosenPlaces[0].longitude),
                          zoomValue: 10,
                        );
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.22,
                      decoration: BoxDecoration(
                        color: colorVal.colors.shadow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: RawScrollbar(
                        controller: _scrollController,
                        trackVisibility: true,
                        thumbVisibility: true,
                        thickness: 10,
                        trackColor: colorVal.colors.buttonColors,
                        thumbColor: Colors.white,
                        radius: const Radius.circular(10),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children:
                                          widget.chosenPlaces.map((place) {
                                        return Draggable<PlacesModel>(
                                          data: place,
                                          feedback: Material(
                                            child: Chip(
                                              label: Text(
                                                place.name,
                                                style: TextStyle(
                                                  fontSize:
                                                      fontVal.fonts.textSize -
                                                          5,
                                                  color: Colors.black,
                                                  fontFamily: fontType,
                                                ),
                                              ),
                                              backgroundColor:
                                                  colorVal.colors.accentColor,
                                            ),
                                          ),
                                          childWhenDragging: Opacity(
                                            opacity: 0.5,
                                            child: Chip(
                                              label: Text(
                                                place.name,
                                                style: TextStyle(
                                                  fontSize:
                                                      fontVal.fonts.textSize -
                                                          5,
                                                  color: Colors.black,
                                                  fontFamily: fontType,
                                                ),
                                              ),
                                              backgroundColor:
                                                  colorVal.colors.accentColor,
                                            ),
                                          ),
                                          onDragStarted: () {
                                            setState(() {
                                              _draggedPlace = place;
                                            });
                                          },
                                          onDragEnd: (details) {
                                            setState(() {
                                              _draggedPlace = null;
                                            });
                                          },
                                          child: Chip(
                                            label: Text(
                                              place.name,
                                              style: TextStyle(
                                                fontSize:
                                                    fontVal.fonts.textSize - 5,
                                                color: Colors.black,
                                                fontFamily: fontType,
                                              ),
                                            ),
                                            backgroundColor:
                                                colorVal.colors.accentColor,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current\nTour:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontVal.fonts.textSize,
                          fontWeight: FontWeight.bold,
                          color: fontVal.fonts.primaryFontColor,
                          fontFamily: fontType,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                          color: colorVal.colors.shadow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: TourRow(),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LgElevatedButton(
                            elevatedButtonContent: 'Reset',
                            buttonColor: colorVal.colors.buttonColors,
                            onpressed: () {},
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.1,
                            fontSize: fontVal.fonts.textSize,
                            fontColor: Colors.white,
                            isLoading: false,
                            isBold: false,
                            isPrefixIcon: false,
                            isSuffixIcon: false,
                            curvatureRadius: 30,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          LgElevatedButton(
                            elevatedButtonContent: 'Create',
                            buttonColor: colorVal.colors.buttonColors,
                            onpressed: () {},
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.1,
                            fontSize: fontVal.fonts.textSize,
                            fontColor: Colors.white,
                            isLoading: false,
                            isBold: false,
                            isPrefixIcon: false,
                            isSuffixIcon: false,
                            curvatureRadius: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> TourRow() {
    List<Widget> widgets = [];
    List<PlacesModel> places = _tourPlaces;

    for (int i = 0; i < places.length; i++) {
      widgets.add(
        Consumer2<FontsProvider, ColorProvider>(
          builder: (BuildContext context, FontsProvider fontVal,
              ColorProvider colorVal, Widget? child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.05,
              // width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: colorVal.colors.buttonColors,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                places[i].name,
                style: TextStyle(
                  fontSize: fontVal.fonts.textSize,
                  color: Colors.white,
                  fontFamily: fontType,
                ),
              ),
            );
          },
        ),
      );

      // Add an icon between places, but not after the last place
      if (i < places.length - 1) {
        widgets.add(
          Consumer2<ColorProvider, FontsProvider>(builder:
              (BuildContext context, ColorProvider colorVal,
                  FontsProvider fontVal, Widget? child) {
            return Row(
              children: [
                SizedBox(width: 30),
                Icon(CupertinoIcons.airplane,
                    color: colorVal.colors.buttonColors,
                    size: fontVal.fonts.textSize + 10),
                SizedBox(width: 30),
              ],
            );
          }),
        );
      }
    }

    return widgets;
  }
}
