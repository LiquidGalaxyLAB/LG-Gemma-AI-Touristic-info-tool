import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/screens/views/explore_location_tabview.dart';
import 'package:ai_touristic_info_tool/screens/views/explore_world_tabview.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final TabController _tabController;
  final _form1Key = GlobalKey<FormState>();

  final _prompt1Controller = TextEditingController();

  final _form2Key = GlobalKey<FormState>();
  final _prompt2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showHomeBallon();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        GoogleMapProvider gmp =
            Provider.of<GoogleMapProvider>(context, listen: false);
        if (_tabController.index == 0) {
          gmp.isWorld = true;
        } else {
          gmp.isWorld = false;
        }
      }
    });
  }

  _showHomeBallon() async {
    await buildAppBalloonOverlay(context);
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
              child: Text(
                //'Welcome to your Home page!',
                AppLocalizations.of(context)!.home_title,
                style: TextStyle(
                  fontFamily: fontType,
                  fontSize: fontProv.fonts.headingSize,
                  color: SettingsSharedPref.getTheme() == 'dark'
                      ? fontProv.fonts.primaryFontColor
                      : fontProv.fonts.secondaryFontColor,
                  fontWeight: FontWeight.bold,
                ),
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
                indicatorColor: value.colors.buttonColors,
                tabs: <Widget>[
                  Tab(
                    key: GlobalKeys.showcaseKeyExploreWorldwide,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.travel_explore,
                            color: value.colors.buttonColors, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          // 'Explore Worldwide',
                          AppLocalizations.of(context)!.home_exploreWorld,
                          style: TextStyle(
                            fontFamily: fontType,
                            fontSize: fontProv.fonts.textSize,
                            color: fontProv.fonts.primaryFontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    key: GlobalKeys.showcaseKeyExploreLocation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.place,
                            color: value.colors.buttonColors, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          // 'Explore certain Location',
                          AppLocalizations.of(context)!.home_explorelocation,
                          style: TextStyle(
                            fontFamily: fontType,
                            fontSize: fontProv.fonts.textSize,
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
        key: GlobalKeys.showcaseKeyViewHome,
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          ExploreWorldTabView(
              formKey: _form1Key, promptController: _prompt1Controller),
          ExploreLocationTabView(
              form2Key: _form2Key, prompt2Controller: _prompt2Controller),
        ],
      ))
    ]);
  }
}
