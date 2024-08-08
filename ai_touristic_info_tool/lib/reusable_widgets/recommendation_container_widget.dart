import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/services/langchain_service.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_gemini_dialog.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_local_dialog.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationContainer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ModelErrorProvider errProvider =
            Provider.of<ModelErrorProvider>(context, listen: false);
        errProvider.isError = false;
        print('query: $query');

        PromptsSharedPref.getPlaces(query).then((value) async {
          print('value: $value');
          print(value.isNotEmpty);
          if (value.isNotEmpty) {
            await buildQueryPlacemark(title, city, country, context);
            showVisualizationDialog(
                context, value, title, city, country, () {}, false);
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
            showStreamingGeminiDialog(context, query, city ?? '', country?? '');
          }
        });
      },
      child: Consumer<ColorProvider>(
        builder: (BuildContext context, ColorProvider value, Widget? child) {
          return Container(
            width: width,
            height: height,
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
                    imagePath,
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
                        Colors.black.withOpacity(bottomOpacity),
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
                        title,
                        style: TextStyle(
                          color: FontAppColors.secondaryFont,
                          fontWeight: FontWeight.bold,
                          fontSize: txtSize,
                          fontFamily: fontType,
                        ),
                      ),
                      if (description != null)
                        Text(
                          description!,
                          style: TextStyle(
                            color: FontAppColors.secondaryFont,
                            fontSize: txtSize,
                            fontFamily: fontType,
                          ),
                        ),
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
