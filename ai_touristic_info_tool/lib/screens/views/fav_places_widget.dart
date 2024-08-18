import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/dialogs/dialog_builder.dart';
import 'package:ai_touristic_info_tool/dialogs/show_customization_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavPlacesWidget extends StatefulWidget {
  const FavPlacesWidget({super.key});

  @override
  State<FavPlacesWidget> createState() => _FavPlacesWidgetState();
}

class _FavPlacesWidgetState extends State<FavPlacesWidget> {
  List<PlacesModel> _favPlaces = [];
  List<PlacesModel> _selectedPlaces = [];
  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(builder:
        (BuildContext context, FontsProvider fontVal, ColorProvider colorVal,
            Widget? child) {
      var groupedPlaces = _groupPlacesByCountry();

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                // 'All your favorite places worldwide in one place!',
                AppLocalizations.of(context)!.favPlaces_title,
                style: TextStyle(
                  fontSize: fontVal.fonts.textSize + 5,
                  fontWeight: FontWeight.bold,
                  color: fontVal.fonts.primaryFontColor,
                  fontFamily: fontType,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                // 'To customize a tour, please select at least 2 places',
                AppLocalizations.of(context)!.favPlaces_customizeSubhead,
                style: TextStyle(
                  fontSize: fontVal.fonts.textSize,
                  color: fontVal.fonts.primaryFontColor,
                  fontFamily: fontType,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                // 'To customize a tour, please select at least 2 places',
                // 'Long press on a place to remove it',
                AppLocalizations.of(context)!.favPlaces_customizeSubhead2,
                style: TextStyle(
                  fontSize: fontVal.fonts.textSize,
                  color: fontVal.fonts.primaryFontColor,
                  fontFamily: fontType,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.32,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  color: colorVal.colors.shadow.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                      child: !groupedPlaces.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: groupedPlaces.keys.map((country) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        country,
                                        style: TextStyle(
                                          fontSize: fontVal.fonts.textSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: fontType,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                          color: colorVal.colors.darkShadow,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: groupedPlaces[country]!
                                                .map((place) {
                                              return GestureDetector(
                                                onLongPress: () {
                                                  dialogBuilder(
                                                      context,
                                                      // 'Are you sure you want to remove this place?',
                                                      AppLocalizations.of(
                                                              context)!
                                                          .favPlaces_removeConfirm,
                                                      false,
                                                      AppLocalizations.of(
                                                              context)!
                                                          .defaults_yes, () {
                                                    setState(() {
                                                      _favPlaces.remove(place);

                                                      FavoritesSharedPref()
                                                          .savePlacesList(
                                                              _favPlaces);
                                                      _loadPlaces();
                                                    });
                                                  }, () {});
                                                },
                                                onTap: () {
                                                  setState(() {
                                                    if (_selectedPlaces
                                                        .contains(place)) {
                                                      _selectedPlaces
                                                          .remove(place);
                                                    } else {
                                                      _selectedPlaces
                                                          .add(place);
                                                    }
                                                  });
                                                },
                                                child: Chip(
                                                  label: Text(
                                                    place.name,
                                                    style: TextStyle(
                                                      fontSize: fontVal
                                                              .fonts.textSize -
                                                          5,
                                                      color: _selectedPlaces
                                                              .contains(place)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontFamily: fontType,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      _selectedPlaces
                                                              .contains(place)
                                                          ? colorVal.colors
                                                              .buttonColors
                                                          : colorVal.colors
                                                              .accentColor,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                // }
                              }).toList(),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Center(
                                child: Text(
                                  // 'No favorite places added yet\nPlease save some places to customize a tour',
                                  AppLocalizations.of(context)!.favPlaces_none,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontVal.fonts.textSize,
                                    fontWeight: FontWeight.bold,
                                    color: LgAppColors.lgColor2,
                                    fontFamily: fontType,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.0,
              right: MediaQuery.of(context).size.width * 0.02,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    backgroundColor: colorVal.colors.buttonColors,
                    onPressed: () {
                      if (_selectedPlaces.length < 2) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                // 'Please select at least 2 places to customize a tour',
                                AppLocalizations.of(context)!
                                    .favPlaces_customizeError,
                                style: TextStyle(
                                  fontSize: fontVal.fonts.textSize - 5,
                                  color: Colors.white,
                                  fontFamily: fontType,
                                ),
                              ),
                              backgroundColor: LgAppColors.lgColor2),
                        );
                      } else {
                        final List<PlacesModel> places = _selectedPlaces;

                        showCustomizationDialog(context, places);
                      }
                    },
                    child: Image.asset(
                      'assets/images/custom.png',
                    ),
                  ),
                  Text(
                    // 'Customize',
                    AppLocalizations.of(context)!.defaults_customize,
                    style: TextStyle(
                        fontSize: fontVal.fonts.textSize - 5,
                        color: fontVal.fonts.primaryFontColor,
                        fontFamily: fontType),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
