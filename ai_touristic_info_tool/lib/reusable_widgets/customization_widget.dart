import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/models/saved_tours_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/services/lg_functionalities.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/displayed_fav_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/ssh_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomizationWidget extends StatefulWidget {
  final List<PlacesModel> chosenPlaces;
  final double firstLat;
  final double firstLong;
  const CustomizationWidget(
      {super.key,
      required this.chosenPlaces,
      required this.firstLat,
      required this.firstLong});

  @override
  State<CustomizationWidget> createState() => _CustomizationWidgetState();
}

class _CustomizationWidgetState extends State<CustomizationWidget> {
  PlacesModel? _draggedPlace;
  late List<PlacesModel> _originalList;
  final ScrollController _scrollController = ScrollController();
  bool _isvisualizing = false;
  bool _isFav = false;
  // String _queryName = 'Custom Tour';
  // String _queryName= AppLocalizations.of(context)!.customapptour_queryNameTemp;
  String _queryName = 'Custom Tour';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _queryNameController = TextEditingController();
  double _tourDuration = 0;

  @override
  void initState() {
    super.initState();
    // Create a copy of chosenPlaces
    _originalList = List<PlacesModel>.from(widget.chosenPlaces);
  }

  void _onPlaceDropped() async {
    GoogleMapProvider gmp =
        Provider.of<GoogleMapProvider>(context, listen: false);
    DisplayedListProvider dlp =
        Provider.of<DisplayedListProvider>(context, listen: false);
    dlp.removeDisplayedPlace(_draggedPlace!);
    gmp.flyToLocation(
        LatLng(_draggedPlace!.latitude, _draggedPlace!.longitude));
    if (_draggedPlace != null) {
      gmp.addMarker(context, _draggedPlace!, removeAll: false, isFromFav: true);
      // await buildPlacePlacemark(_draggedPlace!, -1, 'Custom Tour', context);
      await buildPlacePlacemark(_draggedPlace!, -1, _queryName, context);
      setState(() {
        // displayedPlaces.remove(_draggedPlace);
        // _tourPlaces.add(_draggedPlace!);
        _draggedPlace = null;
      });
    }
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // 'Drag and Drop places to the map!',
                        AppLocalizations.of(context)!.customapptour_dragdrop,
                        style: TextStyle(
                            color: fontVal.fonts.primaryFontColor,
                            fontSize: fontVal.fonts.textSize + 5,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontType),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            LgElevatedButton(
                              // elevatedButtonContent: 'Reset',
                              elevatedButtonContent: AppLocalizations.of(context)!.defaults_reset,
                              buttonColor: colorVal.colors.buttonColors,
                              onpressed: () async {
                                DisplayedListProvider dlp =
                                    Provider.of<DisplayedListProvider>(context,
                                        listen: false);
                                // print('checking chosen places');
                                // print(dlp.selectedPlaces.length);
                                // print(widget.chosenPlaces);
                                dlp.setDisplayedList(
                                    List<PlacesModel>.from(_originalList));
                                dlp.setTourPlaces([]);
                                GoogleMapProvider gmp =
                                    Provider.of<GoogleMapProvider>(context,
                                        listen: false);
                                gmp.clearMarkers();
                                gmp.clearPolylines();
                                gmp.clearCustomMarkers();
                                gmp.clearPolylinesMap();
                                setState(() {});

                                final sshData = Provider.of<SSHprovider>(
                                    context,
                                    listen: false);

                                Connectionprovider connection =
                                    Provider.of<Connectionprovider>(context,
                                        listen: false);

                                if (sshData.client != null &&
                                    connection.isLgConnected) {
                                  await LgService(sshData).clearKml();
                                }
                              },
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
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            LgElevatedButton(
                              // elevatedButtonContent: 'Create',
                              elevatedButtonContent: AppLocalizations.of(context)!.defaults_create,
                              buttonColor: colorVal.colors.buttonColors,
                              onpressed: () async {
                                final sshData = Provider.of<SSHprovider>(
                                    context,
                                    listen: false);

                                Connectionprovider connection =
                                    Provider.of<Connectionprovider>(context,
                                        listen: false);

                                DisplayedListProvider dlp =
                                    Provider.of<DisplayedListProvider>(context,
                                        listen: false);

                                GoogleMapProvider gmp =
                                    Provider.of<GoogleMapProvider>(context,
                                        listen: false);
                                if (gmp.markers.length < 2) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            colorVal.colors.innerBackground,
                                        content: Text(
                                            // 'Please add more than one place to create a route.',
                                            AppLocalizations.of(context)!.customapptour_WarningToCreateRoute,
                                            style: TextStyle(
                                                color: fontVal
                                                    .fonts.primaryFontColor,
                                                fontSize:
                                                    fontVal.fonts.textSize,
                                                fontFamily: fontType)),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              // 'OK',
                                              AppLocalizations.of(context)!.defaults_ok,
                                                style: TextStyle(
                                                    color: LgAppColors.lgColor4,
                                                    fontSize:
                                                        fontVal.fonts.textSize,
                                                    fontFamily: fontType)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  gmp.addPolylinesBetweenMarkers();
                                  gmp.setBitmapDescriptor(
                                      "assets/images/airplane.png");
                                  gmp.addMarkersForPolylines();

                                  if (sshData.client != null &&
                                      connection.isLgConnected) {
                                    double dur = await buildCustomTour(
                                        context, dlp.tourPlaces);

                                    setState(() {
                                      _tourDuration = dur;
                                    });
                                    print('tour');
                                    print(_tourDuration);
                                  }
                                }
                              },
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
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            LgElevatedButton(
                              elevatedButtonContent:
                                  // _isvisualizing ? 'Stop' : 'Visualize',
                                  _isvisualizing ? AppLocalizations.of(context)!.defaults_stop : AppLocalizations.of(context)!.defaults_visualize,
                              buttonColor: colorVal.colors.buttonColors,
                              onpressed: () async {
                                final sshData = Provider.of<SSHprovider>(
                                    context,
                                    listen: false);
                                Connectionprovider connection =
                                    Provider.of<Connectionprovider>(context,
                                        listen: false);
                                GoogleMapProvider gmp =
                                    Provider.of<GoogleMapProvider>(context,
                                        listen: false);
                                gmp.allowSync = false;

                                if (_isvisualizing) {
                                  gmp.isTourOn = false;
                                  setState(() {
                                    _isvisualizing = false;
                                  });

                                  if (sshData.client != null &&
                                      connection.isLgConnected) {
                                    await LgService(sshData).stopTour();
                                  }
                                } else {
                                  setState(() {
                                    _isvisualizing = true;
                                  });

                                  gmp.isTourOn = true;

                                  if (sshData.client != null &&
                                      connection.isLgConnected) {
                                    await Future.wait([
                                      gmp.googleMapCustomTour(),
                                      LgService(sshData).startTour('App Tour'),
                                      Future.delayed(Duration(
                                          seconds: _tourDuration.toInt()))
                                    ]);
                                  } else {
                                    await gmp.googleMapCustomTour();
                                  }

                                  gmp.isTourOn = false;
                                  setState(() {
                                    _isvisualizing = false;
                                  });
                                }

                                gmp.allowSync = true;
                              },
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.14,
                              fontSize: fontVal.fonts.textSize,
                              fontColor: Colors.white,
                              isLoading: false,
                              isBold: false,
                              isPrefixIcon: false,
                              isSuffixIcon: true,
                              suffixIcon:
                                  _isvisualizing ? Icons.stop : Icons.flight,
                              suffixIconSize: fontVal.fonts.textSize,
                              suffixIconColor: Colors.white,
                              curvatureRadius: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                          // initialLatValue: widget.chosenPlaces[0].latitude,
                          // initialLongValue: widget.chosenPlaces[0].longitude,
                          initialLatValue: widget.firstLat,
                          initialLongValue: widget.firstLong,
                          initialTiltValue: 41.82725143432617,
                          initialBearingValue: 61.403038024902344,
                          initialCenterValue:
                              LatLng(widget.firstLat, widget.firstLong),
                          zoomValue: 10,
                          showCleaner: false,
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
                                    child: Consumer<DisplayedListProvider>(
                                      builder: (BuildContext context,
                                          DisplayedListProvider dlp,
                                          Widget? child) {
                                        return Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children:
                                              dlp.displayedList.map((place) {
                                            return Draggable<PlacesModel>(
                                              data: place,
                                              feedback: Material(
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
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.5,
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
                                                        fontVal.fonts.textSize -
                                                            5,
                                                    color: Colors.black,
                                                    fontFamily: fontType,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    colorVal.colors.accentColor,
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
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
                        // 'Current\nTour:',
                        AppLocalizations.of(context)!.customapptour_CurrTour,
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
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: colorVal.colors.shadow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Consumer<DisplayedListProvider>(
                              builder: (BuildContext context,
                                  DisplayedListProvider value, Widget? child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: TourRow(value.tourPlaces),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Tooltip(
                          message: _isFav
                              // ? 'Added to favorites'
                              ?  AppLocalizations.of(context)!.favs_addtofavsmessage
                              // : 'Removed from favorites',
                              :  AppLocalizations.of(context)!.favs_removefromfavsmessage,
                          triggerMode: TooltipTriggerMode.tap,
                          onTriggered: () async {
                            if (await FavoritesSharedPref()
                                .isTourExist(_queryName)) {
                              await FavoritesSharedPref()
                                  .removeTour(_queryName);
                              setState(() {
                                _isFav = false;
                              });
                            } else {
                              DisplayedListProvider dlp =
                                  Provider.of<DisplayedListProvider>(context,
                                      listen: false);
                              if (dlp.tourPlaces.length == 0) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          colorVal.colors.innerBackground,
                                      content: Text(
                                          // 'Please add places to create a tour.',
                                          AppLocalizations.of(context)!.customapptour_missingPlaces,
                                          style: TextStyle(
                                              color: fontVal
                                                  .fonts.primaryFontColor,
                                              fontSize: fontVal.fonts.textSize,
                                              fontFamily: fontType)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            // 'OK',
                                            AppLocalizations.of(context)!.defaults_ok,
                                              style: TextStyle(
                                                  color: LgAppColors.lgColor4,
                                                  fontSize:
                                                      fontVal.fonts.textSize,
                                                  fontFamily: fontType)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          colorVal.colors.innerBackground,
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                  // 'Choose a name for your tour:',
                                                  AppLocalizations.of(context)!.customapptour_chooseName,
                                                  style: TextStyle(
                                                      color: fontVal.fonts
                                                          .primaryFontColor,
                                                      fontSize: fontVal
                                                          .fonts.textSize,
                                                      fontFamily: fontType)),
                                              Center(
                                                child: TextFormFieldWidget(
                                                  // fontSize: textSize,
                                                  fontSize:
                                                      fontVal.fonts.textSize,
                                                  key: const ValueKey(
                                                      "custom-tour-name"),
                                                  textController:
                                                      _queryNameController,
                                                  isSuffixRequired: true,

                                                  isPassword: false,
                                                  maxLength: 100,
                                                  maxlines: 1,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.85,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await FavoritesSharedPref()
                                                  .addTour(SavedToursModel(
                                                query:
                                                    _queryNameController.text,
                                                places: dlp.tourPlaces,
                                                city: '',
                                                country: '',
                                                isGenerated: false,
                                              ));
                                              setState(() {
                                                _isFav = true;
                                                _queryName =
                                                    _queryNameController.text;
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text(
                                            // 'Done',
                                            AppLocalizations.of(context)!.defaults_done,
                                              style: TextStyle(
                                                  color: LgAppColors.lgColor4,
                                                  fontSize:
                                                      fontVal.fonts.textSize,
                                                  fontFamily: fontType)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Icon(
                              _isFav
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: LgAppColors.lgColor2,
                              size: fontVal.fonts.titleSize),
                        ),
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

  List<Widget> TourRow(List<PlacesModel> places) {
    List<Widget> widgets = [];

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
