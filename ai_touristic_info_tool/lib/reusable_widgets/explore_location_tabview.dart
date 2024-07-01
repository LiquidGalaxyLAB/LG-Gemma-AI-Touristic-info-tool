import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/drop_down_list_component.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ExploreLocationTabView extends StatefulWidget {
  const ExploreLocationTabView({
    super.key,
    required GlobalKey<FormState> form2Key,
    required TextEditingController prompt2Controller,
  })  : _form2Key = form2Key,
        _prompt2Controller = prompt2Controller;

  final GlobalKey<FormState> _form2Key;
  final TextEditingController _prompt2Controller;

  @override
  State<ExploreLocationTabView> createState() => _ExploreLocationTabViewState();
}

class _ExploreLocationTabViewState extends State<ExploreLocationTabView> {
  Map<String, String?> fullAdddress = {};
  bool showAddressFields = false;

  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: countries[0]);
  String? _chosenCountry;
  String addressQuery = '';
  String whatToDoQuery = '';
  String fullQuery = '';

  // Future<void> _getAddressFromCoordinates() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   final Map<String, String?> result = await GeocodingService()
  //       .getAddressFromLatLng(position.latitude, position.longitude);
  //   setState(() {
  //     fullAdddress['city'] = result['city'];
  //     fullAdddress['country'] = result['country'];
  //     fullAdddress['address'] = result['address'];
  //   });
  //   GoogleMapProvider gmp =
  //       Provider.of<GoogleMapProvider>(context, listen: false);
  //   gmp.currentFullAddress = fullAdddress;
  //   gmp.updateCameraPosition(CameraPosition(
  //       target: LatLng(position.latitude, position.longitude), zoom: 14.4746));
  // }

  Future<LatLng> getCoordinates(
      String? address, String city, String country) async {
    // MyLatLng myLatLng = await GeocodingService()
    //     .getCoordinates('${address ?? ''} $city $country');
    MyLatLng myLatLng = await GeocodingService().getCoordinates('Italy, Rome');
    double lat = myLatLng.latitude;
    double long = myLatLng.longitude;
    return LatLng(lat, long);
  }

  @override
  Widget build(BuildContext context) {
    int countryIndex = countries.indexOf(_countryController.text);
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
                onpressed: () {
                  setState(() {
                    showAddressFields = false;
                  });
                },
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
              // LgElevatedButton(
              //   elevatedButtonContent: 'Detect\nLocation',
              //   buttonColor: ButtonColors.locationButton,
              //   onpressed: () {
              //    // _getAddressFromCoordinates();
              //   },
              //   height: MediaQuery.of(context).size.height * 0.1,
              //   width: MediaQuery.of(context).size.width * 0.14,
              //   fontSize: textSize,
              //   fontColor: FontAppColors.secondaryFont,
              //   isLoading: false,
              //   isBold: false,
              //   isPrefixIcon: true,
              //   prefixIcon: Icons.location_on_outlined,
              //   prefixIconColor: Colors.white,
              //   prefixIconSize: 30,
              //   isSuffixIcon: false,
              //   curvatureRadius: 10,
              // ),
              LgElevatedButton(
                elevatedButtonContent: 'Type\nAddress',
                buttonColor: ButtonColors.promptButton,
                onpressed: () {
                  setState(() {
                    showAddressFields = true;
                  });
                },
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
          if (showAddressFields)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextFormFieldWidget(
                    label: 'Address',
                    fontSize: textSize,
                    key: const ValueKey("address"),
                    textController: _addressController,
                    isSuffixRequired: false,
                    isHidden: false,
                    maxLength: 100,
                    maxlines: 1,
                    width: MediaQuery.sizeOf(context).width * 0.85,
                  ),
                  TextFormFieldWidget(
                    label: 'City',
                    fontSize: textSize,
                    key: const ValueKey("city"),
                    textController: _cityController,
                    isSuffixRequired: true,
                    isHidden: false,
                    maxLength: 100,
                    maxlines: 1,
                    width: MediaQuery.sizeOf(context).width * 0.85,
                  ),
                  DropDownListWidget(
                    key: const ValueKey("countries"),
                    fontSize: 16,
                    items: countries,
                    selectedValue: countryIndex != -1
                        ? countries[countryIndex]
                        : countries[0],
                    hinttext: 'Country',
                    onChanged: (value) {
                      setState(() {
                        _countryController.text = value;
                        _chosenCountry = value;
                      });
                    },
                  ),
                ],
              ),
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
            initialLatValue: 40.416775,
            initialLongValue: -3.703790,
            initialTiltValue: 41.82725143432617,
            initialBearingValue: 61.403038024902344,
            initialCenterValue: const LatLng(40.416775, -3.703790),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Center(
            child: Consumer<GoogleMapProvider>(
              builder: (BuildContext context, GoogleMapProvider value,
                  Widget? child) {
                String? city;
                String? country;
                String? address;
                if (showAddressFields) {
                  city = _cityController.text;
                  country = _chosenCountry;
                  address = _addressController.text;
                } else {
                  city = value.currentFullAddress['city'];
                  country = value.currentFullAddress['country'];
                  address = value.currentFullAddress['address'];
                }

                if (city != null && country != null) {
                  addressQuery = '${address ?? ''}${city} ${country}';
                  print('address query');
                  print(addressQuery);
                  getCoordinates(address ?? '', city, country).then((value) {
                    print('value: $value');
                    setState(() {
                      GoogleMapProvider gmp = Provider.of<GoogleMapProvider>(
                          context,
                          listen: false);
                      gmp.updateCameraPosition(CameraPosition(
                          target: LatLng(value.latitude, value.longitude),
                          zoom: 14.4746));
                    });
                  });
                }

                return Text(
                  'You are in${address ?? ''} ${city ?? ''} ${country ?? ''}',
                  style: TextStyle(
                    fontSize: textSize + 8,
                    fontFamily: fontType,
                    color: FontAppColors.primaryFont,
                  ),
                );
              },
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
                    query: 'landmarks in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/restaurants.jpeg',
                    title: 'Restaurants and Cafes',
                    query: 'Restaurants and Cafes in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/art.jpeg',
                    title: 'Art and Culture',
                    query: 'Art and Culture in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/shopping.jpeg',
                    title: 'Shopping Malls',
                    query: 'Shopping Malls in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/sports.jpeg',
                    title: 'Sports and Recreation',
                    query: 'Sports and Recreation in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/spa.webp',
                    title: 'Spa and Wellness',
                    query: 'Spa and Wellness in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/outdoor.jpeg',
                    title: 'Outdoor Activities',
                    query: 'Outdoor Activities in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/pizza.jpeg',
                    title: 'Top Pizza Places',
                    query: 'Top Pizza Places in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/history.jpg',
                    title: 'Historical Sites',
                    query: 'Historical Sites in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/parks.webp',
                    title: 'Local Parks',
                    query: 'Local Parks in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/cinema.jpeg',
                    title: 'Cinemas',
                    query: 'Cinemas in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/library.jpeg',
                    title: 'Libraries',
                    query: 'Libraries in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/dancing.jpeg',
                    title: 'Dancing Studios',
                    query: 'Dancing Studios in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/yoga.jpg',
                    title: 'Yoga Studios',
                    query: 'Yoga Studios in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/education.jpeg',
                    title: 'Educational Institutions',
                    query: 'Educational Institutions in$addressQuery',
                    txtSize: textSize + 2,
                    bottomOpacity: 1,
                  ),
                  RecommendationContainer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    imagePath: 'assets/images/salons.jpeg',
                    title: 'Beauty Salons',
                    query: 'Beauty Salons in$addressQuery',
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
            key: widget._form2Key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: TextFormFieldWidget(
                    fontSize: textSize,
                    key: const ValueKey("location-prompt"),
                    textController: widget._prompt2Controller,
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
                      if (widget._form2Key.currentState!.validate()) {
                        print(widget._prompt2Controller.text);
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
