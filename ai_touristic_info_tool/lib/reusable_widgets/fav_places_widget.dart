import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class FavPlacesWidget extends StatefulWidget {
  const FavPlacesWidget({super.key});

  @override
  State<FavPlacesWidget> createState() => _FavPlacesWidgetState();
}

class _FavPlacesWidgetState extends State<FavPlacesWidget> {
  List<PlacesModel> _favPlaces = [];
  List<Marker> _markers = [];
  PlacesModel? _draggedPlace;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    List<PlacesModel> retrievedPlaces =
        await FavoritesSharedPref().getPlacesList();
    setState(() {
      _favPlaces = retrievedPlaces;
    });
  }

  Map<String, List<PlacesModel>> _groupPlacesByCountry() {
    Map<String, List<PlacesModel>> groupedPlaces = {};
    for (var place in _favPlaces) {
      if (!groupedPlaces.containsKey(place.country)) {
        groupedPlaces[place.country ?? 'Worldwide'] = [];
      }
      groupedPlaces[place.country]!.add(place);
    }
    return groupedPlaces;
  }

  void _onPlaceDropped(LatLng position) {
    if (_draggedPlace != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(_draggedPlace!.name),
            position: position,
            infoWindow: InfoWindow(
              title: _draggedPlace!.name,
            ),
          ),
        );
        _draggedPlace = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontVal,
          ColorProvider colorVal, Widget? child) {
        var groupedPlaces = _groupPlacesByCountry();

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20,
                left: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorVal.colors.buttonColors.withOpacity(0.5),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Drag and drop your favorite places to the map',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontVal.fonts.textSize + 5,
                                color: Colors.white,
                                fontFamily: fontType,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.26,
                            width: MediaQuery.of(context).size.width * 0.38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  colorVal.colors.buttonColors.withOpacity(0.5),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: groupedPlaces.keys.map((country) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            country,
                                            style: TextStyle(
                                              fontSize: fontVal.fonts.textSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: fontType,
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: groupedPlaces[country]!
                                                .map((place) {
                                              return Draggable<PlacesModel>(
                                                data: place,
                                                feedback: Material(
                                                  child: Chip(
                                                    label: Text(
                                                      place.name,
                                                      style: TextStyle(
                                                        fontSize: fontVal.fonts
                                                                .textSize -
                                                            5,
                                                        color: Colors.black,
                                                        fontFamily: fontType,
                                                      ),
                                                    ),
                                                    backgroundColor: colorVal
                                                        .colors.accentColor,
                                                  ),
                                                ),
                                                childWhenDragging: Opacity(
                                                  opacity: 0.5,
                                                  child: Chip(
                                                    label: Text(
                                                      place.name,
                                                      style: TextStyle(
                                                        fontSize: fontVal.fonts
                                                                .textSize -
                                                            5,
                                                        color: Colors.black,
                                                        fontFamily: fontType,
                                                      ),
                                                    ),
                                                    backgroundColor: colorVal
                                                        .colors.accentColor,
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
                                                      fontSize: fontVal
                                                              .fonts.textSize -
                                                          5,
                                                      color: Colors.black,
                                                      fontFamily: fontType,
                                                    ),
                                                  ),
                                                  backgroundColor: colorVal
                                                      .colors.accentColor,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorVal.colors.buttonColors.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DragTarget<PlacesModel>(
                onAcceptWithDetails: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset offset = renderBox.globalToLocal(details.offset);
                  LatLng latLng = LatLng(
                    // Convert the offset to latitude and longitude
                    // This is a placeholder conversion, replace with your actual map's conversion logic
                    40.416775, -3.703790,
                  );
                  _onPlaceDropped(latLng);
                },
                builder: (
                  BuildContext context,
                  List<PlacesModel?> candidateData,
                  List<dynamic> rejectedData,
                ) {
                  return GoogleMapWidget(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 0.4,
                    initialLatValue: 40.416775,
                    initialLongValue: -3.703790,
                    initialTiltValue: 41.82725143432617,
                    initialBearingValue: 61.403038024902344,
                    initialCenterValue: const LatLng(40.416775, -3.703790),
                    // markers: Set<Marker>.of(_markers),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
