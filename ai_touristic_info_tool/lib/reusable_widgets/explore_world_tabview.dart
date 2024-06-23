import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ExploreWorldTabView extends StatelessWidget {
  const ExploreWorldTabView({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController promptController,
  }) : _formKey = formKey, _promptController = promptController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _promptController;

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
                    imagePath: 'assets/images/rec-egypt1.jpg',
                    title: 'Nile River Cruise in Egypt',
                    country: 'Egypt',
                    description:
                        'Sail along the historic Nile River, visiting ancient temples and monuments.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-egypt2.jpg',
                    title:
                        'Dive the Pristine Coral Reefs of the Red Sea, Egypt',
                    country: 'Egypt',
                    description:
                        'Experience world-class diving with vibrant marine life and stunning coral reefs.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-scotland.jpg',
                    title:
                        'Highland Adventure in the Scottish Highlands',
                    country: 'Scotland',
                    description:
                        'Explore rugged landscapes, historic castles, and scenic lochs in Scotland.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-spain.jpg',
                    title: 'Art and Architecture Tour in Spain',
                    country: 'Spain',
                    description:
                        'Discover Spain\'s rich artistic heritage and architectural marvels, including Gaudí’s works.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-iceland.jpg',
                    title: 'Volcano Trekking in Iceland',
                    country: 'Iceland',
                    description:
                        'Trek across lava fields, hot springs, and stunning volcanic landscapes.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-europe.jpg',
                    title: 'Cycling Tour in Europe',
                    country: 'Europe',
                    description:
                        'Enjoy a cycling adventure through picturesque landscapes and historic towns in Europe.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-uae.jpg',
                    title: 'Desert Safari in UAE',
                    country: 'UAE',
                    description:
                        'Experience thrilling dune bashing, camel rides, and a taste of Bedouin culture.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-paris.png',
                    title: 'City Tour in Paris, France',
                    country: 'France',
                    description:
                        'Explore iconic landmarks like the Eiffel Tower, Louvre Museum, and Notre-Dame Cathedral.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-norway.jpg',
                    title: 'Aurora Borealis Viewing in Norway',
                    country: 'Norway',
                    description:
                        'Witness the stunning Northern Lights in one of the best viewing spots on Earth.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-japan.jpg',
                    title: 'Cultural Tour in Kyoto, Japan',
                    country: 'Japan',
                    description:
                        'Discover ancient temples, traditional tea houses, and the serene beauty of Kyoto\'s gardens.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-india2.jpeg',
                    title: 'Yoga and Wellness Retreats in India',
                    country: 'India',
                    description:
                        'Engage in rejuvenating yoga sessions and meditation practices in serene settings.'),
                RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    imagePath: 'assets/images/rec-london.jpg',
                    title: 'Historical Tour of London',
                    country: 'London',
                    description:
                        'Visit iconic sites such as the Tower of London, Buckingham Palace, and the British Museum.'),
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
                    imagePath: 'assets/images/landmark.png',
                    title: 'Visting Major Landmarks',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/beach.png',
                    title: 'Beach Holidays',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/sightseeing.png',
                    title: 'City Sightseeing Tours',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/museum.png',
                    title: 'Museums and Historical Sites',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/wildlife.png',
                    title: 'Nature and Wildlife Tours',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/adventure.jpg',
                    title: 'Adventure Sports',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/themepark.jpg',
                    title: 'Theme Parks',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/food.jpg',
                    title: 'Food and Culinary Tours',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/hiking.jpg',
                    title: 'Hiking and Trekking',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/Kayaking.webp',
                    title: 'Kayaking',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/cycling.jpg',
                    title: 'Cycling Tours',
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.width * 0.02),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.25,
                    imagePath: 'assets/images/football.jpg',
                    title: 'Football Stadium Tours and Matches',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 50, bottom: 20),
            child: Text(
              'Ask AI model, Gemma whatever you want to explore worldwide: ',
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
                    isHidden: false,
                    maxLength: 100,
                    maxlines: 1,
                    width: MediaQuery.sizeOf(context).width * 0.85,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 40.0, top: 20),
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
                    onpressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(_promptController.text);
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
