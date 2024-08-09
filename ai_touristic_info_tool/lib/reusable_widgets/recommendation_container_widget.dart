import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/services/langchain_service.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/current_view_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_gemini_dialog.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_local_dialog.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationContainer extends StatefulWidget {
  final String imagePath;
  final String title; //query
  final String? country; //query
  final String? city; //query
  final String query;
  final String? description;
  final double width;
  final double height;
  final double txtSize;
  final double? descriptionSize;
  final double bottomOpacity;
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
        ModelErrorProvider errProvider =
            Provider.of<ModelErrorProvider>(context, listen: false);
        errProvider.isError = false;
        print('query: ${widget.query}');

        PromptsSharedPref.getPlaces(widget.query).then((value) async {
          print('value: $value');
          print(value.isNotEmpty);
          if (value.isNotEmpty) {
            await buildQueryPlacemark(
                widget.title, widget.city, widget.country, context);
            showVisualizationDialog(context, value, widget.title, widget.city,
                widget.country, () {}, false);
          } else {
            Connectionprovider connection =
                Provider.of<Connectionprovider>(context, listen: false);
            //Local:
            // if (!connection.isAiConnected) {
            //   dialogBuilder(
            //       context,
            //       'NOT connected to AI Server!!\nPlease Connect!',
            //       true,
            //       'OK',
            //       null,
            //       null);
            // } else {
            // showStreamingDialog(context, query, city ?? '', country ?? '');
            // }
            // With Gemini:
            //  Map<String, dynamic> result =
            //   await LangchainService().generateAnswer(query);
            // print(result);
            //result["places"][i]["name"]
            // name address city country description pricing rating amenities source

            ApiKeyModel? apiKeyModel =
                await APIKeySharedPref.getDefaultApiKey('Gemini');

            String apiKey;
            if (apiKeyModel == null) {
              //snackbar:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: LgAppColors.lgColor2,
                    content: Consumer<FontsProvider>(
                      builder: (BuildContext context, FontsProvider value,
                          Widget? child) {
                        return Text(
                          'Please add a default API Key for Gemini in the settings!',
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
              apiKey = apiKeyModel.key;
              setState(() {
                _isLoading = true;
              });
              String res = await LangchainService().checkAPIValidity(apiKey);
              setState(() {
                _isLoading = false;
              });
              if (res == '') {
                showStreamingGeminiDialog(context, widget.query,
                    widget.city ?? '', widget.country ?? '', apiKey);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: LgAppColors.lgColor2,
                      content: Consumer<FontsProvider>(
                        builder: (BuildContext context, FontsProvider value,
                            Widget? child) {
                          return Text(
                            res,
                            style: TextStyle(
                              fontSize: value.fonts.textSize,
                              color: Colors.white,
                              fontFamily: fontType,
                            ),
                          );
                        },
                      )),
                );
              }
            }
          }
        });
      },
      child: Consumer<ColorProvider>(
        builder: (BuildContext context, ColorProvider value, Widget? child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(
                  // color: PrimaryAppColors.buttonColors,
                  color: value.colors.buttonColors,
                  width: 4),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,

                          // valueColor: AlwaysStoppedAnimation<Color>(
                          //   value.colors.buttonColors,
                          // ),
                        ),
                        Text('Loading...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: fontType,
                            ))
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
