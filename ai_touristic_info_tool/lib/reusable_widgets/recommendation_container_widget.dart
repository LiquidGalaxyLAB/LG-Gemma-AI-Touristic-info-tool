import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/dialogs/dialog_builder.dart';
import 'package:ai_touristic_info_tool/dialogs/show_stream_local_dialog.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/services/gemini_services.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/dialogs/show_stream_gemini_dialog.dart';
import 'package:ai_touristic_info_tool/dialogs/visualization_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendationContainer extends StatefulWidget {
  final String imagePath;
  final String title;
  final String? country;
  final String? city;
  final String query;
  final String? addressQuery;
  final String? description;
  final double width;
  final double height;
  final double txtSize;
  final double? descriptionSize;
  final double bottomOpacity;
  final bool isFromWorldwide;
  const RecommendationContainer(
      {super.key,
      required this.imagePath,
      required this.title,
      this.country,
      this.city,
      required this.query,
      this.description,
      required this.width,
      required this.height,
      required this.txtSize,
      this.descriptionSize,
      this.addressQuery = '',
      this.isFromWorldwide = true,
      required this.bottomOpacity});

  @override
  State<RecommendationContainer> createState() =>
      _RecommendationContainerState();
}

class _RecommendationContainerState extends State<RecommendationContainer> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.addressQuery == '' && widget.isFromWorldwide == false) {
          //show snackbar:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: LgAppColors.lgColor2,
                content: Consumer<FontsProvider>(
                  builder: (BuildContext context, FontsProvider value,
                      Widget? child) {
                    return Text(
                      // 'Please enter an address first above or use map!',
                      AppLocalizations.of(context)!
                          .exploreLocation_missingAddress,
                      style: TextStyle(
                        fontSize: value.fonts.textSize,
                        color: Colors.white,
                        fontFamily: fontType,
                      ),
                    );
                  },
                )),
          );
        } else {
          ModelErrorProvider errProvider =
              Provider.of<ModelErrorProvider>(context, listen: false);
          errProvider.isError = false;
          PromptsSharedPref.getPlaces(widget.query).then((value) async {
            if (value.isNotEmpty) {
              await buildQueryPlacemark(
                  widget.title, widget.city, widget.country, context);
              showVisualizationDialog(context, value, widget.title, widget.city,
                  widget.country, () {}, false);
            } else {
          
              //Local:
                  Connectionprovider connection =
                  Provider.of<Connectionprovider>(context, listen: false);
              if (!connection.isAiConnected) {
                dialogBuilder(
                    context,
                    'NOT connected to AI Server!!\nPlease Connect!',
                    true,
                    'OK',
                    null,
                    null);
              } else {
              showStreamingDialog(context, widget.query, widget.city ?? '', widget.country ?? '');
          
              }
              // With Gemini:

              // ApiKeyModel? apiKeyModel =
              //     await APIKeySharedPref.getDefaultApiKey('Gemini');

              // String apiKey;
            //   if (apiKeyModel == null) {
            //     //snackbar:
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //           backgroundColor: LgAppColors.lgColor2,
            //           content: Consumer<FontsProvider>(
            //             builder: (BuildContext context, FontsProvider value,
            //                 Widget? child) {
            //               return Text(
            //                 // 'Please add a default API Key for Gemini in the settings!',
            //                 AppLocalizations.of(context)!
            //                     .settings_apiKeyNotSetDefaultError,
            //                 style: TextStyle(
            //                   fontSize: value.fonts.textSize,
            //                   color: Colors.white,
            //                   fontFamily: fontType,
            //                 ),
            //               );
            //             },
            //           )),
            //     );
            //   } else {
            //     apiKey = apiKeyModel.key;
            //     if (mounted) {
            //       setState(() {
            //         _isLoading = true;
            //       });
            //     }
            //     String res =
            //         await GeminiServices().checkAPIValidity(apiKey, context);
            //     if (mounted) {
            //       setState(() {
            //         _isLoading = false;
            //       });
            //     }
            //     if (res == '') {
            //       Locale locale = await SettingsSharedPref.getLocale();
            //       showStreamingGeminiDialog(context, widget.query,
            //           widget.city ?? '', widget.country ?? '', apiKey, locale);
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //             backgroundColor: LgAppColors.lgColor2,
            //             content: Consumer<FontsProvider>(
            //               builder: (BuildContext context, FontsProvider value,
            //                   Widget? child) {
            //                 return Text(
            //                   res,
            //                   style: TextStyle(
            //                     fontSize: value.fonts.textSize,
            //                     color: Colors.white,
            //                     fontFamily: fontType,
            //                   ),
            //                 );
            //               },
            //             )),
            //       );
            //     }
            //   }
            }
          });
        }
      },
      child: Consumer<ColorProvider>(
        builder: (BuildContext context, ColorProvider value, Widget? child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: value.colors.buttonColors, width: 4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(widget.bottomOpacity),
                        Colors.black.withOpacity(0.1),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: FontAppColors.secondaryFont,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.txtSize,
                          fontFamily: fontType,
                        ),
                      ),
                      if (widget.description != null)
                        Text(
                          widget.description!,
                          style: TextStyle(
                            color: FontAppColors.secondaryFont,
                            fontSize: widget.txtSize,
                            fontFamily: fontType,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_isLoading)
                  Center(
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    // Expanded(
                    //   child: Text(
                    //       // 'Loading...',
                    //       AppLocalizations.of(context)!.defaults_loading,
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 20,
                    //         overflow: TextOverflow.ellipsis,
                    //         fontFamily: fontType,
                    //       )),
                    // )
                    // ],
                    // ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
