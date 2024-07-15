import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/drop_down_list_component.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/google_maps_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:ai_touristic_info_tool/state_management/connection_provider.dart';
import 'package:ai_touristic_info_tool/state_management/gmaps_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/dialog_builder.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/show_stream_dialog.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:flutter/material.dart';
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
  bool useMap = true;

  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: countries[0]);
  String? _chosenCountry;
  String _city = '';
  String _country = '';
  String _address = '';
  String _addressQuery = '';
  String _whatToDoQuery = '';

  final _addressFormKey = GlobalKey<FormState>();

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
                    useMap = true;
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
              LgElevatedButton(
                elevatedButtonContent: 'Type\nAddress',
                buttonColor: ButtonColors.promptButton,
                onpressed: () {
                  setState(() {
                    showAddressFields = true;
                    useMap = false;
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
              child: Container(
                decoration: BoxDecoration(
                  color: PrimaryAppColors.buttonColors,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _addressFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text('Address Details',
                            style: TextStyle(
                                fontSize: textSize + 10,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold,
                                color: FontAppColors.secondaryFont)),
                        TextFormFieldWidget(
                          hint: 'Enter address, or leave empty',
                          fontSize: textSize,
                          key: const ValueKey("address"),
                          textController: _addressController,
                          isSuffixRequired: false,
                          // isHidden: false,
                          isPassword: false,
                          maxLength: 100,
                          maxlines: 1,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                        ),
                        Text('City',
                            style: TextStyle(
                                fontSize: textSize + 10,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold,
                                color: FontAppColors.secondaryFont)),
                        TextFormFieldWidget(
                          hint: 'Enter city',
                          fontSize: textSize,
                          key: const ValueKey("city"),
                          textController: _cityController,
                          isSuffixRequired: true,
                          // isHidden: false,
                          isPassword: false,
                          maxLength: 100,
                          maxlines: 1,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                        ),
                        Text('Country',
                            style: TextStyle(
                                fontSize: textSize + 10,
                                fontFamily: fontType,
                                fontWeight: FontWeight.bold,
                                color: FontAppColors.secondaryFont)),
                        DropDownListWidget(
                          key: const ValueKey("countries"),
                          fontSize: textSize,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        LgElevatedButton(
                            elevatedButtonContent: 'Save',
                            buttonColor: PrimaryAppColors.innerBackground,
                            fontColor: FontAppColors.primaryFont,
                            onpressed: () async {
                              if (_addressFormKey.currentState!.validate()) {
                                setState(() {
                                  _city = _cityController.text;
                                  _country = _chosenCountry ?? '';
                                  _address = _addressController.text;
                                  _addressQuery = '$_address $_city $_country';
                                  useMap = false;
                                });

                                MyLatLng myLatLng = await GeocodingService()
                                    .getCoordinates(_addressQuery);
                                double lat = myLatLng.latitude;
                                double long = myLatLng.longitude;
                                print('Lat: $lat , long: $long');

                                // GoogleMapProvider gmp =
                                //     Provider.of<GoogleMapProvider>(context,
                                //         listen: false);

                                LatLng newLocation = LatLng(lat, long);
                                final mapProvider =
                                    Provider.of<GoogleMapProvider>(context,
                                        listen: false);
                                mapProvider.currentFullAddress = {
                                  'city': _city,
                                  'country': _country,
                                  'address': _address
                                };

                                mapProvider.updateZoom(18.4746);
                                mapProvider.updateBearing(90);
                                mapProvider.updateTilt(45);
                                print('before fly to');
                                mapProvider.flyToLocation(newLocation);

                                // gmp.updateCameraPosition(CameraPosition(
                                //     target: LatLng(lat, long), zoom: 14.4746));
                                // gmp.flyToLocation(LatLng(lat, long));

                                print('Lat: $lat , long: $long');
                                print('after fly to');
                              }
                            },
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.1,
                            fontSize: textSize,
                            isLoading: false,
                            isBold: true,
                            isPrefixIcon: false,
                            isSuffixIcon: false,
                            curvatureRadius: 10)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          if (useMap)
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
          if (!useMap)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 20),
              child: Text(
                'Click on Use Map button to navigate if you want!',
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
                print(useMap);
                if (useMap) {
                  _address = value.currentFullAddress['address'] ?? '';
                  _city = value.currentFullAddress['city'] ?? '';
                  _country = value.currentFullAddress['country'] ?? '';
                  _addressQuery = '$_address $_city $_country';
                  print(_addressQuery);
                }

                return Text(
                  'You are in $_addressQuery',
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
              child: Consumer<GoogleMapProvider>(builder: (BuildContext context,
                  GoogleMapProvider value, Widget? child) {
                return GridView.count(
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
                      query: !useMap
                          ? 'landmarks in $_addressQuery'
                          : 'landmarks in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/restaurants.jpeg',
                      title: 'Restaurants and Cafes',
                      query: !useMap
                          ? 'Restaurants and Cafes in $_addressQuery'
                          : 'Restaurants and Cafes in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/art.jpeg',
                      title: 'Art and Culture',
                      query: !useMap
                          ? 'Art and Culture in $_addressQuery'
                          : 'Art and Culture in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/shopping.jpeg',
                      title: 'Shopping Malls',
                      query: !useMap
                          ? 'Shopping Malls in $_addressQuery'
                          : 'Shopping Malls in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/sports.jpeg',
                      title: 'Sports and Recreation',
                      query: !useMap
                          ? 'Sports and Recreation in $_addressQuery'
                          : 'Sports and Recreation in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/spa.webp',
                      title: 'Spa and Wellness',
                      query: !useMap
                          ? 'Spa and Wellness in $_addressQuery'
                          : 'Spa and Wellness in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/outdoor.jpeg',
                      title: 'Outdoor Activities',
                      query: !useMap
                          ? 'Outdoor Activities in $_addressQuery'
                          : 'Outdoor Activities in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/pizza.jpeg',
                      title: 'Top Pizza Places',
                      query: !useMap
                          ? 'Top Pizza Places in $_addressQuery'
                          : 'Top Pizza Places in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/history.jpg',
                      title: 'Historical Sites',
                      query: !useMap
                          ? 'Historical Sites in $_addressQuery'
                          : 'Historical Sites in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/parks.webp',
                      title: 'Local Parks',
                      query: !useMap
                          ? 'Local Parks in $_addressQuery'
                          : 'Local Parks in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/cinema.jpeg',
                      title: 'Cinemas',
                      query: !useMap
                          ? 'Cinemas in $_addressQuery'
                          : 'Cinemas in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/library.jpeg',
                      title: 'Libraries',
                      query: !useMap
                          ? 'Libraries in $_addressQuery'
                          : 'Libraries in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/dancing.jpeg',
                      title: 'Dancing Studios',
                      query: !useMap
                          ? 'Dancing Studios in $_addressQuery'
                          : 'Dancing Studios in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/yoga.jpg',
                      title: 'Yoga Studios',
                      query: !useMap
                          ? 'Yoga Studios in $_addressQuery'
                          : 'Yoga Studios in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/education.jpeg',
                      title: 'Educational Institutions',
                      query: !useMap
                          ? 'Educational Institutions in $_addressQuery'
                          : 'Educational Institutions in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.1,
                      imagePath: 'assets/images/salons.jpeg',
                      title: 'Beauty Salons',
                      query: !useMap
                          ? 'Beauty Salons in $_addressQuery'
                          : 'Beauty Salons in ${value.currentFullAddress['address'] ?? ''}, ${value.currentFullAddress['city'] ?? ''}, ${value.currentFullAddress['country'] ?? ''}',
                      city: _city,
                      country: _country,
                      txtSize: textSize + 2,
                      bottomOpacity: 1,
                    ),
                  ],
                );
              }),
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
                    onpressed: () async {
                      ModelErrorProvider errProvider =
                          Provider.of<ModelErrorProvider>(context,
                              listen: false);
                      errProvider.isError = false;
                      if (widget._form2Key.currentState!.validate()) {
                        GoogleMapProvider gmp = Provider.of<GoogleMapProvider>(
                            context,
                            listen: false);
                        _whatToDoQuery = widget._prompt2Controller.text;
                        String query;
                        if (useMap) {
                          query =
                              '$_whatToDoQuery in ${gmp.currentFullAddress['address']}, ${gmp.currentFullAddress['city']}, ${gmp.currentFullAddress['country']}';
                        } else {
                          query = '$_whatToDoQuery in $_addressQuery';
                        }

                        print('query: $query');
                        PromptsSharedPref.getPlaces(query).then((value) async {
                          print('value: $value');
                          print(value.isNotEmpty);
                          if (value.isNotEmpty) {
                            await buildQueryPlacemark(
                                query, _city, _country, context);

                            showVisualizationDialog(
                                context, value, query, _city, _country);
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
                              showStreamingDialog(context, query, _city, _country);
                            }
                          }
                        });
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



/*
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
*/