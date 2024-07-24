import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/fav_places_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/saved_tours_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Consumer2<ColorProvider, FontsProvider>(
        builder: (BuildContext context, ColorProvider value,
            FontsProvider fontProv, Widget? child) {
          return TopBarWidget(
            grad1: SettingsSharedPref.getTheme() == 'light'
                ? value.colors.buttonColors
                : value.colors.gradient1,
            grad2: SettingsSharedPref.getTheme() == 'light'
                ? value.colors.buttonColors
                : value.colors.gradient2,
            grad3: SettingsSharedPref.getTheme() == 'light'
                ? value.colors.buttonColors
                : value.colors.gradient3,
            grad4: SettingsSharedPref.getTheme() == 'light'
                ? value.colors.buttonColors
                : value.colors.gradient4,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.bookmark,
                      color: FontAppColors.secondaryFont,
                      size: fontProv.fonts.headingSize),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Text(
                    'All your favorite tours and POIs in one place',
                    style: TextStyle(
                      fontFamily: fontType,
                      fontSize: fontProv.fonts.headingSize,
                      color: SettingsSharedPref.getTheme() == 'dark'
                          ? fontProv.fonts.primaryFontColor
                          : fontProv.fonts.secondaryFontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
      Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Consumer2<ColorProvider, FontsProvider>(
            builder: (BuildContext context, ColorProvider value,
                FontsProvider fontProv, Widget? child) {
              return TabBar(
                controller: _tabController,
                // indicatorColor: PrimaryAppColors.buttonColors,
                indicatorColor: value.colors.buttonColors,
                tabs: <Widget>[
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.airplane,
                            // color: PrimaryAppColors.buttonColors,
                            // color: value.colors.buttonColors,
                            color: value.colors.buttonColors,
                            size: 30),
                        const SizedBox(width: 10),
                        Text(
                          'All Saved Tours',
                          style: TextStyle(
                            fontFamily: fontType,
                            // fontSize: textSize,
                            fontSize: fontProv.fonts.textSize,
                            // color: PrimaryAppColors.buttonColors,
                            // color: value.colors.buttonColors,
                            color: fontProv.fonts.primaryFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.location_circle,
                            // color: PrimaryAppColors.buttonColors,
                            color: value.colors.buttonColors,
                            size: 30),
                        const SizedBox(width: 10),
                        Text(
                          'Favorite places',
                          style: TextStyle(
                            fontFamily: fontType,
                            // fontSize: textSize,
                            fontSize: fontProv.fonts.textSize,
                            // color: PrimaryAppColors.buttonColors,
                            // color: value.colors.buttonColors,
                            color: fontProv.fonts.primaryFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
      Expanded(
          child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          SavedToursWidget(),
          FavPlacesWidget(),
        ],
      ))
    ]);
  }
}
