import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/explore_world_tabview.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_map_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      TopBarWidget(
        child: Center(
          child: Text(
            'Welcome to your Home page!',
            style: TextStyle(
              fontFamily: fontType,
              fontSize: headingSize,
              color: FontAppColors.secondaryFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.04,
      ),
      Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.8,
          child: TabBar(
            controller: _tabController,
            indicatorColor: PrimaryAppColors.buttonColors,
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.travel_explore,
                        color: PrimaryAppColors.buttonColors, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      'Explore Worldwide',
                      style: TextStyle(
                        fontFamily: fontType,
                        fontSize: textSize,
                        color: PrimaryAppColors.buttonColors,
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
                    const Icon(Icons.place,
                        color: PrimaryAppColors.buttonColors, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      'Explore certain Location',
                      style: TextStyle(
                        fontFamily: fontType,
                        fontSize: textSize,
                        color: PrimaryAppColors.buttonColors,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                  child: Text(
                    'Navigate to your desired location!',
                    style: TextStyle(
                        fontSize: textSize + 10,
                        fontFamily: fontType,
                        fontWeight: FontWeight.bold,
                        color: FontAppColors.primaryFont),
                  ),
                ),
                GoogleMapWidget(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.8,
                  initialLatValue: 28.65665656297236,
                  initialLongValue: -17.885454520583153,
                  initialTiltValue: 41.82725143432617,
                  initialBearingValue: 61.403038024902344,
                  initialCenterValue:
                      const LatLng(28.65665656297236, -17.885454520583153),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Center(
                  child: Text(
                    'You are in City, Country',
                    style: TextStyle(
                      fontSize: textSize + 8,
                      fontFamily: fontType,
                      color: FontAppColors.primaryFont,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 50, bottom: 20),
                  child: Text(
                    'AI-Recommended Things To Do nearby',
                    style: TextStyle(
                        fontSize: textSize + 10,
                        fontFamily: fontType,
                        fontWeight: FontWeight.bold,
                        color: FontAppColors.primaryFont),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: GridView.count(
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 2,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: <Widget>[
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/landmarkss.jpg',
                          title: 'Landmarks',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/restaurants.jpeg',
                          title: 'Restaurants and Cafes',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/art.jpeg',
                          title: 'Art and Culture',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/shopping.jpeg',
                          title: 'Shopping Malls',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/sports.jpeg',
                          title: 'Sports and Recreation',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/spa.webp',
                          title: 'Spa and Wellness',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/outdoor.jpeg',
                          title: 'Outdoor Activities',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/pizza.jpeg',
                          title: 'Top Pizza Places',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/history.jpg',
                          title: 'Historical Sites',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/parks.webp',
                          title: 'Local Parks',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/cinema.jpeg',
                          title: 'Cinemas',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/library.jpeg',
                          title: 'Libraries',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/dancing.jpeg',
                          title: 'Dancing Studios',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/yoga.jpg',
                          title: 'Yoga Studios',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/education.jpeg',
                          title: 'Educational Institutions',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                        RecommendationContainer(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.1,
                          imagePath: 'assets/images/salons.jpeg',
                          title: 'Beauty Salons',
                          txtSize: textSize + 2,
                          bottomOpacity: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 30, bottom: 20),
                  child: Text(
                    'Ask Gemma anything you want to know nearby:',
                    style: TextStyle(
                        fontSize: textSize + 10,
                        fontFamily: fontType,
                        fontWeight: FontWeight.bold,
                        color: FontAppColors.primaryFont),
                  ),
                ),
                Form(
                  key: _form2Key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: TextFormFieldWidget(
                          fontSize: textSize,
                          key: const ValueKey("location-prompt"),
                          textController: _prompt2Controller,
                          isSuffixRequired: false,
                          isHidden: false,
                          maxLength: 100,
                          maxlines: 1,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0, top: 20),
                        child: LgElevatedButton(
                          key: const ValueKey("location-prompt-button"),
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          buttonColor: PrimaryAppColors.buttonColors,
                          fontSize: textSize,
                          fontColor: FontAppColors.secondaryFont,
                          isBold: true,
                          isLoading: false,
                          isPrefixIcon: false,
                          isSuffixIcon: false,
                          onpressed: () {
                            if (_form2Key.currentState!.validate()) {
                              print(_prompt2Controller.text);
                            }
                          },
                          elevatedButtonContent: 'GENERATE',
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.05,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
