import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:flutter/material.dart';

class RecommendationContainer extends StatelessWidget {
  final String imagePath;
  final String title; //query
  final String? country; //query
  final String? city; //query
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
      this.description,
      required this.width,
      required this.height,
      required this.txtSize,
      this.descriptionSize,
      required this.bottomOpacity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()  {
        PromptsSharedPref.getPlaces(title).then((value) async {
          print('value: $value');
          print(value.isNotEmpty);
          if (value.isNotEmpty) {
            await buildQueryPlacemark(title, city, country, context);
            showVisualizationDialog(context, value, title, city, country);
          }
        });
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: PrimaryAppColors.buttonColors, width: 4),
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
      ),
    );
  }
}
