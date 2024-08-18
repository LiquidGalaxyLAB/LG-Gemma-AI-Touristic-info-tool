import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/visualization_dialog.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/state_management/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows a dialog with visualizations for the provided places.
///
/// This function displays a `VisualizationDialog` with information about
/// the places based on the given parameters. It also handles location
/// retrieval for the provided city and country if necessary.
///
/// [context] - The BuildContext used to show the dialog.
/// [places] - A list of `PlacesModel` objects representing the places to visualize.
/// [query] - The search query that generated the list of places.
/// [city] - The city to use for geocoding, or null if not applicable.
/// [country] - The country to use for geocoding, or null if not applicable.
/// [onItemRemoved] - Callback function to be executed when an item is removed from the list.
/// [fromFav] - Boolean indicating if the visualization is clicked from the favorites list.
///
/// Returns a Future that completes when the dialog is closed


void showVisualizationDialog(
  BuildContext context,
  List<PlacesModel> places,
  String query,
  String? city,
  String? country,
  VoidCallback onItemRemoved,
  bool fromFav,
) async{
  MyLatLng myLatLng;
  if (country == '' || country == null) {
      myLatLng =
          MyLatLng(places[0].latitude, places[0].longitude);
    } else {
      myLatLng = await GeocodingService()
          .getCoordinates('$city, $country');
    }
    double lat = myLatLng.latitude;
    double long = myLatLng.longitude;
  SearchProvider srch = Provider.of<SearchProvider>(context, listen: false);
  srch.showMap = true;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return VisualizationDialog(
        places: places,
        query: query,
        city: city,
        country: country,
        onItemRemoved: onItemRemoved,
        fromFav: fromFav,
        initialLat: lat,
        initialLong:long,
      );
    },
  );
}


