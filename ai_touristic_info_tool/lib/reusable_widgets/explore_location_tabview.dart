import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_map_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExploreLocationTabView extends StatelessWidget {
  const ExploreLocationTabView({
    super.key,
    required GlobalKey<FormState> form2Key,
    required TextEditingController prompt2Controller,
  })  : _form2Key = form2Key,
        _prompt2Controller = prompt2Controller;

  final GlobalKey<FormState> _form2Key;
  final TextEditingController _prompt2Controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //options: map, prompt, song, audio, photo, detect location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LgElevatedButton(
                elevatedButtonContent: 'Use\nMap',
                buttonColor: ButtonColors.mapButton,
                onpressed: () {},
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.14,
                fontSize: textSize,
                fontColor: FontAppColors.secondaryFont,
                isLoading: false,
                isBold: false,
                isPrefixIcon: true,
                prefixIcon: Icons.map_outlined,
                prefixIconColor: Colors.white,
                prefixIconSize: 30,
                isSuffixIcon: false,
                curvatureRadius: 10,
              ),
              LgElevatedButton(
                elevatedButtonContent: 'Detect\nLocation',
                buttonColor: ButtonColors.locationButton,
                onpressed: () {},
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.14,
                fontSize: textSize,
                fontColor: FontAppColors.secondaryFont,
                isLoading: false,
                isBold: false,
                isPrefixIcon: true,
                prefixIcon: Icons.location_on_outlined,
                prefixIconColor: Colors.white,
                prefixIconSize: 30,
                isSuffixIcon: false,
                curvatureRadius: 10,
              ),
              LgElevatedButton(
                elevatedButtonContent: 'Type\nAddress',
                buttonColor: ButtonColors.promptButton,
                onpressed: () {},
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.14,
                fontSize: textSize,
                fontColor: FontAppColors.secondaryFont,
                isLoading: false,
                isBold: false,
                isPrefixIcon: true,
                prefixIcon: Icons.text_fields_outlined,
                prefixIconColor: Colors.white,
                prefixIconSize: 30,
                isSuffixIcon: false,
                curvatureRadius: 10,
              ),
              LgElevatedButton(
                elevatedButtonContent: 'Upload\nMusic',
                buttonColor: ButtonColors.musicButton,
                onpressed: () {},
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.14,
                fontSize: textSize,
                fontColor: FontAppColors.secondaryFont,
                isLoading: false,
                isBold: false,
                isPrefixIcon: true,
                prefixIcon: Icons.music_note_outlined,
                prefixIconColor: Colors.white,
                prefixIconSize: 30,
                isSuffixIcon: false,
                curvatureRadius: 10,
              ),
              LgElevatedButton(
                elevatedButtonContent: 'Record\nAudio',
                buttonColor: ButtonColors.audioButton,
                onpressed: () {},
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.14,
                fontSize: textSize,
                fontColor: FontAppColors.secondaryFont,
                isLoading: false,
                isBold: false,
                isPrefixIcon: true,
                prefixIcon: Icons.mic_outlined,
                prefixIconColor: Colors.white,
                prefixIconSize: 30,
                isSuffixIcon: false,
                curvatureRadius: 10,
              ),
              LgElevatedButton(
                elevatedButtonContent: 'Upload\nPhoto',
                buttonColor: ButtonColors.photoButton,
                onpressed: () {},
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.14,
                fontSize: textSize,
                fontColor: FontAppColors.secondaryFont,
                isLoading: false,
                isBold: false,
                isPrefixIcon: true,
                prefixIcon: Icons.photo_camera_outlined,
                prefixIconColor: Colors.white,
                prefixIconSize: 30,
                isSuffixIcon: false,
                curvatureRadius: 10,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20),
            child: Text(
              'Navigate till you find your desired location!',
              style: TextStyle(
                  fontSize: textSize + 10,
                  fontFamily: fontType,
                  fontWeight: FontWeight.bold,
                  color: FontAppColors.primaryFont),
            ),
          ),
          GoogleMapWidget(
            height: MediaQuery.of(context).size.height * 0.5,
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
            padding: const EdgeInsets.only(left: 20.0, top: 50, bottom: 20),
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
            padding: const EdgeInsets.only(left: 20.0, top: 30, bottom: 20),
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
                    curvatureRadius: 50,
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
    );
  }
}
