import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/favs_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/saved_tours_model.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/dialogs/visualization_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavedToursWidget extends StatefulWidget {
  const SavedToursWidget({super.key});

  @override
  State<SavedToursWidget> createState() => _SavedToursWidgetState();
}

class _SavedToursWidgetState extends State<SavedToursWidget> {
  List<SavedToursModel> _favTours = [];

  final List<String> _imagePaths = [
    "assets/images/travel1.jpg",
    "assets/images/travel2.jpg",
    "assets/images/travel3.jpg",
    "assets/images/travel4.webp",
    "assets/images/travel5.jpg",
    "assets/images/travel6.webp",
    "assets/images/travel7.jpg",
    "assets/images/travel8.webp",
  ];

  @override
  void initState() {
    super.initState();
    _loadTours();
  }

  Future<void> _loadTours() async {
    List<SavedToursModel> retrieved_tours =
        await FavoritesSharedPref().getToursList();
    if (mounted) {
      setState(() {
        _favTours = retrieved_tours;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer2<FontsProvider, ColorProvider>(
        builder: (BuildContext context, FontsProvider value,
            ColorProvider value2, Widget? child) {
          return Column(
            children: [
              _favTours.length == 0
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          // 'No saved tours yet\nPlease save a tour to view it here',
                          AppLocalizations.of(context)!.favTours_none,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: value.fonts.textSize + 5,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontType,
                            color: LgAppColors.lgColor2,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _favTours.length,
                      itemBuilder: (BuildContext context, int index) {
                        int imageIndex = index % _imagePaths.length;

                        return ListTile(
                          title: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color:
                                  value2.colors.buttonColors.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image:
                                            AssetImage(_imagePaths[imageIndex]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _favTours[index].query,
                                        style: TextStyle(
                                          fontSize: value.fonts.textSize + 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: fontType,
                                          color: value.fonts.primaryFontColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        softWrap: true,
                                        maxLines: 5,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _favTours[index].isGenerated
                                            //Local:
                                            // ? 'Generated by Gemma'
                                            //Gemini:
                                            // ? 'Generated by Gemini'
                                            // : 'Customized Tour',
                                            ?
                                            //  AppLocalizations.of(context)!
                                            //     .favTours_generatedByGemini
                                            AppLocalizations.of(context)!
                                                .favTours_generatedByGemma
                                            : AppLocalizations.of(context)!
                                                .favTours_customized,
                                        style: TextStyle(
                                          fontSize: value.fonts.textSize,
                                          fontFamily: fontType,
                                          color: value.fonts.primaryFontColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await buildQueryPlacemark(
                                                _favTours[index].query,
                                                _favTours[index].city,
                                                _favTours[index].country,
                                                context);
                                            showVisualizationDialog(
                                                context,
                                                _favTours[index].places,
                                                _favTours[index].query,
                                                _favTours[index].city,
                                                _favTours[index].country, () {
                                              if (mounted) {
                                                setState(() {
                                                  FavoritesSharedPref()
                                                      .removeTour(
                                                          _favTours[index]
                                                              .query);
                                                  _favTours.removeAt(index);
                                                });
                                              }
                                            }, true);
                                          },
                                          icon: Icon(
                                            CupertinoIcons.eye,
                                            size: value.fonts.headingSize,
                                            color: value.fonts.primaryFontColor,
                                          ),
                                        ),
                                        Text(
                                            // 'Visualize',
                                            AppLocalizations.of(context)!
                                                .defaults_visualize,
                                            style: TextStyle(
                                              fontSize:
                                                  value.fonts.textSize - 10,
                                              fontFamily: fontType,
                                              color:
                                                  value.fonts.primaryFontColor,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                FavoritesSharedPref()
                                                    .removeTour(
                                                        _favTours[index].query);
                                                _favTours.removeAt(index);
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: LgAppColors.lgColor2,
                                            size: value.fonts.headingSize,
                                          ),
                                        ),
                                        Text(
                                            // 'Remove',
                                            AppLocalizations.of(context)!
                                                .defaults_remove,
                                            style: TextStyle(
                                              fontSize:
                                                  value.fonts.textSize - 10,
                                              fontFamily: fontType,
                                              color:
                                                  value.fonts.primaryFontColor,
                                            ))
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
            ],
          );
        },
      ),
    );
  }
}
