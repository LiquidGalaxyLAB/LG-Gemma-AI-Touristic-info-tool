import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/explore_location_tabview.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/explore_world_tabview.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
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

    // ModelErrorProvider errProvider =
    //     Provider.of<ModelErrorProvider>(context, listen: false);
    // errProvider.isError = false;
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
                  // fontSize: headingSize,
                  fontSize: fontProv.fonts.headingSize,
                  // color: FontAppColors.secondaryFont,
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
                // indicatorColor: PrimaryAppColors.buttonColors,
                indicatorColor: value.colors.buttonColors,
                tabs: <Widget>[
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.travel_explore,
                            // color: PrimaryAppColors.buttonColors,
                            // color: value.colors.buttonColors,
                            color: value.colors.buttonColors,
                            size: 30),
                        const SizedBox(width: 10),
                        Text(
                          // 'Explore Worldwide',
                          AppLocalizations.of(context)!.home_exploreWorld,
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
                        Icon(Icons.place,
                            // color: PrimaryAppColors.buttonColors,
                            color: value.colors.buttonColors,
                            size: 30),
                        const SizedBox(width: 10),
                        Text(
                          // 'Explore certain Location',
                          AppLocalizations.of(context)!.home_explorelocation,
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
          ExploreWorldTabView(
              formKey: _form1Key, promptController: _prompt1Controller),
          ExploreLocationTabView(
              form2Key: _form2Key, prompt2Controller: _prompt2Controller),
        ],
      ))
    ]);
  }
}


/*

Recommended Things To Do nearby:
---------------------------------
Shopping
Art and Culture
Sports and Recreation
Spa and Wellness
Outdoor Activities
Dining and Cafes
Pizza Places
Historical Sites
Local Parks
Sushi Places
Cinemas
Libraries
Landmarks
Dancing Studios
Yoga Studios

Most Popular/Common Activities Worldwide
---------------------------------------

Visiting Major Landmarks
Examples: The Eiffel Tower, Statue of Liberty, Great Wall of China.

Beach Holidays
Popular Destinations: Maldives, Caribbean, Hawaii.

City Sightseeing Tours
Explore cities like New York, London, Tokyo with guided tours or hop-on-hop-off buses.

Museums and Historical Sites
Famous Museums: The Louvre, British Museum, Metropolitan Museum of Art.

Nature and Wildlife Tours
Examples: Amazon Rainforest, African Safaris, Galapagos Islands.

Adventure Sports
Popular Activities: Skydiving, Bungee Jumping, Paragliding.

Theme Parks
Popular Parks: Disneyland, Universal Studios, Legoland.

Food and Culinary Tours
Explore local cuisines and cooking classes in destinations like Italy, Thailand, Mexico.

Hiking and Trekking
Famous Trails: Inca Trail (Peru), Appalachian Trail (USA), Tour du Mont Blanc (Europe).

Kayaking

Cycling Tours
Iconic Routes: Tour de France (France), Giro d'Italia (Italy), Coast to Coast (USA).


Football Stadium Tours and Matches
*/

/*
Recommended Activities
----------------------
Cultural Tour in Kyoto, Japan
Discover ancient temples, traditional tea houses, and the serene beauty of Kyoto's gardens.

Aurora Borealis Viewing in Norway
Witness the stunning Northern Lights in one of the best viewing spots on Earth.

City Tour in Paris, France
Explore iconic landmarks like the Eiffel Tower, Louvre Museum, and Notre-Dame Cathedral.

Desert Safari in UAE
Experience thrilling dune bashing, camel rides, and a taste of Bedouin culture.

Cycling Tour in Europe
Enjoy a cycling adventure through picturesque landscapes and historic towns in Europe.

Volcano Trekking in Iceland
Trek across lava fields, hot springs, and stunning volcanic landscapes.

Yoga and Wellness Retreats in India
Engage in rejuvenating yoga sessions and meditation practices in serene settings.

Art and Architecture Tour in Spain
Discover Spain's rich artistic heritage and architectural marvels, including Gaudí’s works.

Highland Adventure in the Scottish Highlands
Explore rugged landscapes, historic castles, and scenic lochs in Scotland.

Historical Tour of London
Visit iconic sites such as the Tower of London, Buckingham Palace, and the British Museum.

Dive the Pristine Coral Reefs of the Red Sea, Egypt
Experience world-class diving with vibrant marine life and stunning coral reefs.

Nile River Cruise in Egypt
Sail along the historic Nile River, visiting ancient temples and monuments.
*/
/*
  GoogleMapWidget(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.7,
          initialLatValue: 28.65665656297236,
          initialLongValue: -17.885454520583153,
          initialTiltValue: 41.82725143432617,
          initialBearingValue: 61.403038024902344,
          initialCenterValue:
              const LatLng(28.65665656297236, -17.885454520583153),
        ),
*/
