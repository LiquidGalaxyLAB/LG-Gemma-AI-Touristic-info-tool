import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/services/langchain_service.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_gemini_dialog.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_local_dialog.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreWorldTabView extends StatefulWidget {
  const ExploreWorldTabView({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController promptController,
  })  : _formKey = formKey,
        _promptController = promptController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _promptController;

  @override
  State<ExploreWorldTabView> createState() => _ExploreWorldTabViewState();
}

class _ExploreWorldTabViewState extends State<ExploreWorldTabView> {
  bool _isLoading = false;
  //init:
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<FontsProvider>(
        builder:
            (BuildContext context, FontsProvider fontsProv, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  // 'AI Touristic Recommendations WorldWide',
                  AppLocalizations.of(context)!.exploreWorld_aiRecommendation,
                  style: TextStyle(
                    // fontSize: textSize + 10,
                    fontSize: fontsProv.fonts.textSize + 10,
                    fontFamily: fontType,
                    fontWeight: FontWeight.bold,
                    // color: FontAppColors.primaryFont,
                    color: fontsProv.fonts.primaryFontColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 80),
                child: CarouselSlider(
                  items: [
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-london.jpg',
                      // title: 'Attractions in London, UK',
                      title: AppLocalizations.of(context)!.exploreWorld_londonTitle,
                      query: 'Attractions in London, UK',
                      country: 'United Kingdom',
                      city: 'London',
                      // description:
                      //     'Visit iconic sites such as the Tower of London, Buckingham Palace, and the British Museum.',
                      description: AppLocalizations.of(context)!.exploreWorld_londonDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-egypt1.jpg',
                      // title: 'Nile River Cruise in Egypt',
                      title: AppLocalizations.of(context)!.exploreWorld_nileEgyptTitle,
                      query: 'Nile River Cruise in Egypt',
                      country: 'Egypt',
                      // description:
                      //     'Sail along the historic Nile River, visiting ancient temples and monuments.',
                      description: AppLocalizations.of(context)!.exploreWorld_nileEgyptDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-egypt2.jpg',
                      // title:
                      //     'Dive the Pristine Coral Reefs of the Red Sea, Egypt',
                      title: AppLocalizations.of(context)!.exploreWorld_redSeaEgyptTitle,
                      query:
                          'Dive the Pristine Coral Reefs of the Red Sea, Egypt',
                      country: 'Egypt',
                      // description:
                      //     'Experience world-class diving with vibrant marine life and stunning coral reefs.',
                      description: AppLocalizations.of(context)!.exploreWorld_redSeaEgyptDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-scotland.jpg',
                      // title: 'Highland Adventure in the Scottish Highlands',
                      title: AppLocalizations.of(context)!.exploreWorld_scotlandTitle,
                      query: 'Highland Adventure in the Scottish Highlands',
                      country: 'Scotland',
                      // description:
                      //     'Explore rugged landscapes, historic castles, and scenic lochs in Scotland.',
                     description: AppLocalizations.of(context)!.exploreWorld_scotlandDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-spain.jpg',
                      // title: 'Art and Architecture Tour in Spain',
                      title: AppLocalizations.of(context)!.exploreWorld_spainTitle,
                      query: 'Art and Architecture Tour in Spain',
                      country: 'Spain',
                      // description:
                      //     'Discover Spain\'s rich artistic heritage and architectural marvels, including Gaudí’s works.',
                      description: AppLocalizations.of(context)!.exploreWorld_spainDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-iceland.jpg',
                      // title: 'Volcano Trekking in Iceland',
                      title: AppLocalizations.of(context)!.exploreWorld_icelandTitle,

                      query: 'Volcano Trekking in Iceland',
                      country: 'Iceland',
                      // description:
                      //     'Trek across lava fields, hot springs, and stunning volcanic landscapes.',
                      description: AppLocalizations.of(context)!.exploreWorld_icelandDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-europe.jpg',
                      // title: 'Cycling Tour in Europe',
                      title: AppLocalizations.of(context)!.exploreWorld_europeTitle,
                      query: 'Cycling Tour in Europe',
                      country: 'Europe',
                      // description:
                      //     'Enjoy a cycling adventure through picturesque landscapes and historic towns in Europe.',
                      description: AppLocalizations.of(context)!.exploreWorld_europeDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-uae.jpg',
                      // title: 'Desert Safari in UAE',
                      title: AppLocalizations.of(context)!.exploreWorld_uaeTitle,
                      query: 'Desert Safari in UAE',
                      country: 'UAE',
                      // description:
                      //     'Experience thrilling dune bashing, camel rides, and a taste of Bedouin culture.',
                     description: AppLocalizations.of(context)!.exploreWorld_uaeDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-paris.png',
                      // title: 'City Tour in Paris, France',
                      title: AppLocalizations.of(context)!.exploreWorld_parisTitle,
                      query: 'City Tour in Paris, France',
                      country: 'France',
                      // description:
                      //     'Explore iconic landmarks like the Eiffel Tower, Louvre Museum, and Notre-Dame Cathedral.',
                      description: AppLocalizations.of(context)!.exploreWorld_parisDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-norway.jpg',
                      // title: 'Aurora Borealis Viewing in Norway',
                      title: AppLocalizations.of(context)!.exploreWorld_norwayTitle,
                      query: 'Aurora Borealis Viewing in Norway',
                      country: 'Norway',
                      // description:
                      //     'Witness the stunning Northern Lights in one of the best viewing spots on Earth.',
                      description: AppLocalizations.of(context)!.exploreWorld_norwayDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-japan.jpg',
                      // title: 'Cultural Tour in Kyoto, Japan',
                      title: AppLocalizations.of(context)!.exploreWorld_japanTitle,
                      query: 'Cultural Tour in Kyoto, Japan',
                      country: 'Japan',
                      // description:
                      //     'Discover ancient temples, traditional tea houses, and the serene beauty of Kyoto\'s gardens.',
                      description: AppLocalizations.of(context)!.exploreWorld_japanDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-india2.jpeg',
                      // title: 'Yoga and Wellness Retreats in India',
                      title: AppLocalizations.of(context)!.exploreWorld_indiaTitle,
                      query: 'Yoga and Wellness Retreats in India',
                      country: 'India',
                      // description:
                      //     'Engage in rejuvenating yoga sessions and meditation practices in serene settings.',
                      description: AppLocalizations.of(context)!.exploreWorld_indiaDesc,
                      txtSize: textSize + 6,
                      // txtSize: fontsProv.fonts.textSize + 6,
                      descriptionSize: textSize + 2,
                    ),
                  ],
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.4,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  // 'Most Popular Activities WorldWide',
                  AppLocalizations.of(context)!.exploreWorld_popular,
                  style: TextStyle(
                    // fontSize: textSize + 10,
                    fontSize: fontsProv.fonts.textSize + 10,
                    fontFamily: fontType,
                    fontWeight: FontWeight.bold,
                    // color: FontAppColors.primaryFont
                    color: fontsProv.fonts.primaryFontColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/landmark.png',
                        // title: 'Visting Major Landmarks',
                        title: AppLocalizations.of(context)!.exploreWorld_landmarks,
                        query: 'Visting Major Landmarks Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/beach.png',
                        // title: 'Beach Holidays',
                        title: AppLocalizations.of(context)!.exploreWorld_beach,
                        query: 'Beach Holidays Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/sightseeing.png',
                        // title: 'City Sightseeing Tours',
                        title: AppLocalizations.of(context)!.exploreWorld_sightseeing,
                        query: 'City Sightseeing Tours Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/museum.png',
                        // title: 'Museums and Historical Sites',
                        title: AppLocalizations.of(context)!.exploreWorld_museums,
                        query: 'Museums and Historical Sites Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/wildlife.png',
                        // title: 'Nature and Wildlife Tours',
                        title: AppLocalizations.of(context)!.exploreWorld_nature,
                        query: 'Nature and Wildlife Tours Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/adventure.jpg',
                        // title: 'Adventure Sports',
                        title: AppLocalizations.of(context)!.exploreWorld_adventure,
                        query: 'Adventure Sports Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/themepark.jpg',
                        // title: 'Theme Parks',
                        title: AppLocalizations.of(context)!.exploreWorld_theme,
                        query: 'Theme Parks Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/food.jpg',
                        // title: 'Food and Culinary Tours',
                        title: AppLocalizations.of(context)!.exploreWorld_food,
                        query: 'Food and Culinary Tours Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/hiking.jpg',
                        // title: 'Hiking and Trekking',
                        title: AppLocalizations.of(context)!.exploreWorld_hike,
                        query: 'Hiking and Trekking Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/Kayaking.webp',
                        // title: 'Kayaking',
                        title: AppLocalizations.of(context)!.exploreWorld_kayak,
                        query: 'Kayaking Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/cycling.jpg',
                        // title: 'Cycling Tours',
                        title: AppLocalizations.of(context)!.exploreWorld_cycle,
                        query: 'Cycling Tours Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/football.jpg',
                        // title: 'Football Stadium Tours and Matches',
                        title: AppLocalizations.of(context)!.exploreWorld_football,
                        query: 'Football Stadium Tours and Matches Worldwide',
                        txtSize: textSize + 6,
                        // txtSize: fontsProv.fonts.textSize + 6,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 50, bottom: 20),
                child: Text(
                  //Local:
                  // 'Explore anything worldwide with Gemma. Ask away! ',
                  //Gemini
                  // 'Explore anything worldwide with Gemini. Ask away! ',
                  AppLocalizations.of(context)!.exploreWorld_askGemini,
                  style: TextStyle(
                    // fontSize: textSize + 10,
                    fontSize: fontsProv.fonts.textSize + 10,
                    fontFamily: fontType,
                    fontWeight: FontWeight.bold,
                    // color: FontAppColors.primaryFont
                    color: fontsProv.fonts.primaryFontColor,
                  ),
                ),
              ),
              Form(
                key: widget._formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: TextFormFieldWidget(
                        // fontSize: textSize,
                        fontSize: fontsProv.fonts.textSize,
                        key: const ValueKey("world-prompt"),
                        textController: widget._promptController,
                        isSuffixRequired: false,
                        // isHidden: false,
                        isPassword: false,
                        maxLength: 100,
                        maxlines: 1,
                        width: MediaQuery.sizeOf(context).width * 0.85,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0, top: 20),
                      child: Consumer<ColorProvider>(
                        builder: (BuildContext context, ColorProvider value,
                            Widget? child) {
                          return LgElevatedButton(
                            key: const ValueKey("world-prompt-button"),
                            height: MediaQuery.sizeOf(context).height * 0.05,
                            width: MediaQuery.sizeOf(context).width * 0.2,
                            // buttonColor: PrimaryAppColors.buttonColors,
                            buttonColor: value.colors.buttonColors,
                            // fontSize: textSize,
                            fontSize: fontsProv.fonts.textSize,
                            fontColor: Colors.white,
                            // fontColor: FontAppColors.secondaryFont,
                            isBold: true,
                            isLoading: false,
                            isPrefixIcon: false,
                            isSuffixIcon: false,
                            curvatureRadius: 50,
                            onpressed: () {
                              ModelErrorProvider errProvider =
                                  Provider.of<ModelErrorProvider>(context,
                                      listen: false);
                              errProvider.isError = false;
                              if (widget._formKey.currentState!.validate()) {
                                String query =
                                    '${widget._promptController.text} Worldwide';
                                print(query);

                                PromptsSharedPref.getPlaces(query)
                                    .then((value) async {
                                  print('value: $value');
                                  print(value.isNotEmpty);
                                  if (value.isNotEmpty) {
                                    await buildQueryPlacemark(
                                        query, '', '', context);
                                    showVisualizationDialog(context, value,
                                        query, '', '', () {}, false);
                                  } else {
                                    //Local
                                    // Connectionprovider connection =
                                    //     Provider.of<Connectionprovider>(context,
                                    //         listen: false);
                                    // if (!connection.isAiConnected) {
                                    //   dialogBuilder(
                                    //       context,
                                    //       'NOT connected to AI Server!!\nPlease Connect!',
                                    //       true,
                                    //       'OK',
                                    //       null,
                                    //       null);
                                    // } else {
                                    //   showStreamingDialog(
                                    //       context, query, '', '');
                                    // }
                                    //Gemini:
                                    ApiKeyModel? apiKeyModel =
                                        await APIKeySharedPref.getDefaultApiKey(
                                            'Gemini');
                                    String apiKey;
                                    if (apiKeyModel == null) {
                                      //snackbar:
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                LgAppColors.lgColor2,
                                            content: Consumer<FontsProvider>(
                                              builder: (BuildContext context,
                                                  FontsProvider value,
                                                  Widget? child) {
                                                return Text(
                                                  // 'Please add a default API Key for Gemini in the settings!',
                                                   AppLocalizations.of(context)!.settings_apiKeyNotSetDefaultError,
                                                  style: TextStyle(
                                                    fontSize:
                                                        value.fonts.textSize,
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
                                      String res = await LangchainService()
                                          .checkAPIValidity(apiKey, context);

                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (res == '') {
                                         Locale locale= await SettingsSharedPref.getLocale();
                                        showStreamingGeminiDialog(
                                            context, query, '', '', apiKey, locale);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor:
                                                  LgAppColors.lgColor2,
                                              content: Consumer<FontsProvider>(
                                                builder: (BuildContext context,
                                                    FontsProvider value,
                                                    Widget? child) {
                                                  return Text(
                                                    res,
                                                    style: TextStyle(
                                                      fontSize:
                                                          value.fonts.textSize,
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
                              }
                            },
                            elevatedButtonContent:
                                // _isLoading ? 'Loading..' : ' GENERATE',
                                _isLoading
                                    ? AppLocalizations.of(context)!.defaults_loading
                                    : AppLocalizations.of(context)!.defaults_generate,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
