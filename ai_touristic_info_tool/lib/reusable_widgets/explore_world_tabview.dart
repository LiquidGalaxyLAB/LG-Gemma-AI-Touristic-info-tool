import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_dialog.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreWorldTabView extends StatelessWidget {
  const ExploreWorldTabView({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController promptController,
  })  : _formKey = formKey,
        _promptController = promptController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _promptController;

  //init:
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'AI Touristic Recommendations WorldWide',
              style: TextStyle(
                  fontSize: textSize + 10,
                  fontFamily: fontType,
                  fontWeight: FontWeight.bold,
                  color: FontAppColors.primaryFont),
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
                  title: 'Attractions in London, UK',
                  query: 'Attractions in London, UK',
                  country: 'United Kingdom',
                  city: 'London',
                  description:
                      'Visit iconic sites such as the Tower of London, Buckingham Palace, and the British Museum.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-egypt1.jpg',
                  title: 'Nile River Cruise in Egypt',
                  query: 'Nile River Cruise in Egypt',
                  country: 'Egypt',
                  description:
                      'Sail along the historic Nile River, visiting ancient temples and monuments.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-egypt2.jpg',
                  title: 'Dive the Pristine Coral Reefs of the Red Sea, Egypt',
                  query: 'Dive the Pristine Coral Reefs of the Red Sea, Egypt',
                  country: 'Egypt',
                  description:
                      'Experience world-class diving with vibrant marine life and stunning coral reefs.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-scotland.jpg',
                  title: 'Highland Adventure in the Scottish Highlands',
                  query: 'Highland Adventure in the Scottish Highlands',
                  country: 'Scotland',
                  description:
                      'Explore rugged landscapes, historic castles, and scenic lochs in Scotland.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-spain.jpg',
                  title: 'Art and Architecture Tour in Spain',
                  query: 'Art and Architecture Tour in Spain',
                  country: 'Spain',
                  description:
                      'Discover Spain\'s rich artistic heritage and architectural marvels, including Gaudí’s works.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-iceland.jpg',
                  title: 'Volcano Trekking in Iceland',
                  query: 'Volcano Trekking in Iceland',
                  country: 'Iceland',
                  description:
                      'Trek across lava fields, hot springs, and stunning volcanic landscapes.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-europe.jpg',
                  title: 'Cycling Tour in Europe',
                  query: 'Cycling Tour in Europe',
                  country: 'Europe',
                  description:
                      'Enjoy a cycling adventure through picturesque landscapes and historic towns in Europe.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-uae.jpg',
                  title: 'Desert Safari in UAE',
                  query: 'Desert Safari in UAE',
                  country: 'UAE',
                  description:
                      'Experience thrilling dune bashing, camel rides, and a taste of Bedouin culture.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-paris.png',
                  title: 'City Tour in Paris, France',
                  query: 'City Tour in Paris, France',
                  country: 'France',
                  description:
                      'Explore iconic landmarks like the Eiffel Tower, Louvre Museum, and Notre-Dame Cathedral.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-norway.jpg',
                  title: 'Aurora Borealis Viewing in Norway',
                  query: 'Aurora Borealis Viewing in Norway',
                  country: 'Norway',
                  description:
                      'Witness the stunning Northern Lights in one of the best viewing spots on Earth.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-japan.jpg',
                  title: 'Cultural Tour in Kyoto, Japan',
                  query: 'Cultural Tour in Kyoto, Japan',
                  country: 'Japan',
                  description:
                      'Discover ancient temples, traditional tea houses, and the serene beauty of Kyoto\'s gardens.',
                  txtSize: textSize + 6,
                  descriptionSize: textSize + 2,
                ),
                RecommendationContainer(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  bottomOpacity: 0.6,
                  imagePath: 'assets/images/rec-india2.jpeg',
                  title: 'Yoga and Wellness Retreats in India',
                  query: 'Yoga and Wellness Retreats in India',
                  country: 'India',
                  description:
                      'Engage in rejuvenating yoga sessions and meditation practices in serene settings.',
                  txtSize: textSize + 6,
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
              'Most Popular Activities WorldWide',
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/landmark.png',
                    title: 'Visting Major Landmarks',
                    query: 'Visting Major Landmarks Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/beach.png',
                    title: 'Beach Holidays',
                    query: 'Beach Holidays Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/sightseeing.png',
                    title: 'City Sightseeing Tours',
                    query: 'City Sightseeing Tours Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/museum.png',
                    title: 'Museums and Historical Sites',
                    query: 'Museums and Historical Sites Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/wildlife.png',
                    title: 'Nature and Wildlife Tours',
                    query: 'Nature and Wildlife Tours Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/adventure.jpg',
                    title: 'Adventure Sports',
                    query: 'Adventure Sports Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/themepark.jpg',
                    title: 'Theme Parks',
                    query: 'Theme Parks Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/food.jpg',
                    title: 'Food and Culinary Tours',
                    query: 'Food and Culinary Tours Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/hiking.jpg',
                    title: 'Hiking and Trekking',
                    query: 'Hiking and Trekking Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/Kayaking.webp',
                    title: 'Kayaking',
                    query: 'Kayaking Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/cycling.jpg',
                    title: 'Cycling Tours',
                    query: 'Cycling Tours Worldwide',
                    txtSize: textSize + 6,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    bottomOpacity: 0.6,
                    imagePath: 'assets/images/football.jpg',
                    title: 'Football Stadium Tours and Matches',
                    query: 'Football Stadium Tours and Matches Worldwide',
                    txtSize: textSize + 6,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 50, bottom: 20),
            child: Text(
              'Explore anything worldwide with Gemma. Ask away! ',
              style: TextStyle(
                  fontSize: textSize + 10,
                  fontFamily: fontType,
                  fontWeight: FontWeight.bold,
                  color: FontAppColors.primaryFont),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: TextFormFieldWidget(
                    fontSize: textSize,
                    key: const ValueKey("world-prompt"),
                    textController: _promptController,
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
                  child: LgElevatedButton(
                    key: const ValueKey("world-prompt-button"),
                    height: MediaQuery.sizeOf(context).height * 0.05,
                    width: MediaQuery.sizeOf(context).width * 0.2,
                    buttonColor: PrimaryAppColors.buttonColors,
                    fontSize: textSize,
                    fontColor: FontAppColors.secondaryFont,
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
                      if (_formKey.currentState!.validate()) {
                        String query = '${_promptController.text} Worldwide';
                        print(query);

                        PromptsSharedPref.getPlaces(query).then((value) async {
                          print('value: $value');
                          print(value.isNotEmpty);
                          if (value.isNotEmpty) {
                            await buildQueryPlacemark(query, '', '', context);
                            showVisualizationDialog(
                                context, value, query, '', '');
                          } else {
                            Connectionprovider connection =
                                Provider.of<Connectionprovider>(context,
                                    listen: false);
                            if (!connection.isAiConnected) {
                              dialogBuilder(
                                  context,
                                  'NOT connected to AI Server!!\nPlease Connect!',
                                  true,
                                  'OK',
                                  null,
                                  null);
                            } else {
                              showStreamingDialog(context, query, '', '');
                            }
                          }
                        });
                        // showStreamingDialog(context, query);
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
          ),
        ],
      ),
    );
  }
}
