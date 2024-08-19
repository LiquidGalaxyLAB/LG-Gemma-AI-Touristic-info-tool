import 'dart:io';
import 'dart:math';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/recommendation_container_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/text_field.dart';
import 'package:ai_touristic_info_tool/services/gemini_services.dart';
import 'package:ai_touristic_info_tool/services/voices_services.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/dialogs/show_stream_gemini_dialog.dart';
import 'package:ai_touristic_info_tool/dialogs/visualization_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:record/record.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _isTypePrompt = false;
  // ignore: unused_field
  bool _isRecordPrompt = false;
  bool _isRecording = false;
  String? _audioPath;
  late final AudioRecorder _audioRecorder;
  // ignore: unused_field
  bool _isAudioProcessing = false;
  String? audioPrompt;
  // ignore: unused_field
  bool _isSTTFinished = false;
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    player.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      debugPrint(
          '=========>>>>>>>>>>> RECORDING!!!!!!!!!!!!!!! <<<<<<===========');

      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('ERROR WHILE RECORDING: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();

      setState(() {
        _audioPath = path!;
        _isAudioProcessing = true;
      });
      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
      convertSpeechToText();
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (_isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          _isRecording = true;
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
      }
    } else {
      await _stopRecording();

      setState(() {
        _isRecording = false;
      });
    }
  }

  void convertSpeechToText() async {
    if (_audioPath != null) {
      final audioFile = File(_audioPath!);
      VoicesServicesApi().speechToTextApi(audioFile).then((value) {
        setState(() {
          audioPrompt = value;
          _isAudioProcessing = false;
          _isSTTFinished = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Consumer2<FontsProvider, ColorProvider>(
        builder: (BuildContext context, FontsProvider fontsProv,
            ColorProvider colorProvv, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  // 'AI Touristic Recommendations WorldWide',
                  AppLocalizations.of(context)!.exploreWorld_aiRecommendation,
                  style: TextStyle(
                    fontSize: fontsProv.fonts.textSize + 10,
                    fontFamily: fontType,
                    fontWeight: FontWeight.bold,
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
                      title: AppLocalizations.of(context)!
                          .exploreWorld_londonTitle,
                      query: 'Attractions in London, UK',
                      country: 'United Kingdom',
                      city: 'London',
                      // description:
                      //     'Visit iconic sites such as the Tower of London, Buckingham Palace, and the British Museum.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_londonDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-egypt1.jpg',
                      // title: 'Nile River Cruise in Egypt',
                      title: AppLocalizations.of(context)!
                          .exploreWorld_nileEgyptTitle,
                      query: 'Nile River Cruise in Egypt',
                      country: 'Egypt',
                      // description:
                      //     'Sail along the historic Nile River, visiting ancient temples and monuments.',
                      description: AppLocalizations.of(context)!
                          .exploreWorld_nileEgyptDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-egypt2.jpg',
                      // title:
                      //     'Dive the Pristine Coral Reefs of the Red Sea, Egypt',
                      title: AppLocalizations.of(context)!
                          .exploreWorld_redSeaEgyptTitle,
                      query:
                          'Dive the Pristine Coral Reefs of the Red Sea, Egypt',
                      country: 'Egypt',
                      // description:
                      //     'Experience world-class diving with vibrant marine life and stunning coral reefs.',
                      description: AppLocalizations.of(context)!
                          .exploreWorld_redSeaEgyptDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-scotland.jpg',
                      // title: 'Highland Adventure in the Scottish Highlands',
                      title: AppLocalizations.of(context)!
                          .exploreWorld_scotlandTitle,
                      query: 'Highland Adventure in the Scottish Highlands',
                      country: 'Scotland',
                      // description:
                      //     'Explore rugged landscapes, historic castles, and scenic lochs in Scotland.',
                      description: AppLocalizations.of(context)!
                          .exploreWorld_scotlandDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-spain.jpg',
                      // title: 'Art and Architecture Tour in Spain',
                      title:
                          AppLocalizations.of(context)!.exploreWorld_spainTitle,
                      query: 'Art and Architecture Tour in Spain',
                      country: 'Spain',
                      // description:
                      //     'Discover Spain\'s rich artistic heritage and architectural marvels, including Gaudí’s works.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_spainDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-iceland.jpg',
                      // title: 'Volcano Trekking in Iceland',
                      title: AppLocalizations.of(context)!
                          .exploreWorld_icelandTitle,

                      query: 'Volcano Trekking in Iceland',
                      country: 'Iceland',
                      // description:
                      //     'Trek across lava fields, hot springs, and stunning volcanic landscapes.',
                      description: AppLocalizations.of(context)!
                          .exploreWorld_icelandDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-europe.jpg',
                      // title: 'Cycling Tour in Europe',
                      title: AppLocalizations.of(context)!
                          .exploreWorld_europeTitle,
                      query: 'Cycling Tour in Europe',
                      country: 'Europe',
                      // description:
                      //     'Enjoy a cycling adventure through picturesque landscapes and historic towns in Europe.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_europeDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-uae.jpg',
                      // title: 'Desert Safari in UAE',
                      title:
                          AppLocalizations.of(context)!.exploreWorld_uaeTitle,
                      query: 'Desert Safari in UAE',
                      country: 'UAE',
                      // description:
                      //     'Experience thrilling dune bashing, camel rides, and a taste of Bedouin culture.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_uaeDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-paris.png',
                      // title: 'City Tour in Paris, France',
                      title:
                          AppLocalizations.of(context)!.exploreWorld_parisTitle,
                      query: 'City Tour in Paris, France',
                      country: 'France',
                      // description:
                      //     'Explore iconic landmarks like the Eiffel Tower, Louvre Museum, and Notre-Dame Cathedral.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_parisDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-norway.jpg',
                      // title: 'Aurora Borealis Viewing in Norway',
                      title: AppLocalizations.of(context)!
                          .exploreWorld_norwayTitle,
                      query: 'Aurora Borealis Viewing in Norway',
                      country: 'Norway',
                      // description:
                      //     'Witness the stunning Northern Lights in one of the best viewing spots on Earth.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_norwayDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-japan.jpg',
                      // title: 'Cultural Tour in Kyoto, Japan',
                      title:
                          AppLocalizations.of(context)!.exploreWorld_japanTitle,
                      query: 'Cultural Tour in Kyoto, Japan',
                      country: 'Japan',
                      // description:
                      //     'Discover ancient temples, traditional tea houses, and the serene beauty of Kyoto\'s gardens.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_japanDesc,
                      txtSize: textSize + 6,

                      descriptionSize: textSize + 2,
                    ),
                    RecommendationContainer(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      bottomOpacity: 0.6,
                      imagePath: 'assets/images/rec-india2.jpeg',
                      // title: 'Yoga and Wellness Retreats in India',
                      title:
                          AppLocalizations.of(context)!.exploreWorld_indiaTitle,
                      query: 'Yoga and Wellness Retreats in India',
                      country: 'India',
                      // description:
                      //     'Engage in rejuvenating yoga sessions and meditation practices in serene settings.',
                      description:
                          AppLocalizations.of(context)!.exploreWorld_indiaDesc,
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
                  // 'Most Popular Activities WorldWide',
                  AppLocalizations.of(context)!.exploreWorld_popular,
                  style: TextStyle(
                    fontSize: fontsProv.fonts.textSize + 10,
                    fontFamily: fontType,
                    fontWeight: FontWeight.bold,
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
                        title: AppLocalizations.of(context)!
                            .exploreWorld_landmarks,
                        query: 'Visting Major Landmarks Worldwide',
                        txtSize: textSize + 6,
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
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/sightseeing.png',
                        // title: 'City Sightseeing Tours',
                        title: AppLocalizations.of(context)!
                            .exploreWorld_sightseeing,
                        query: 'City Sightseeing Tours Worldwide',
                        txtSize: textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/museum.png',
                        // title: 'Museums and Historical Sites',
                        title:
                            AppLocalizations.of(context)!.exploreWorld_museums,
                        query: 'Museums and Historical Sites Worldwide',
                        txtSize: textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/wildlife.png',
                        // title: 'Nature and Wildlife Tours',
                        title:
                            AppLocalizations.of(context)!.exploreWorld_nature,
                        query: 'Nature and Wildlife Tours Worldwide',
                        txtSize: textSize + 6,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/adventure.jpg',
                        // title: 'Adventure Sports',
                        title: AppLocalizations.of(context)!
                            .exploreWorld_adventure,
                        query: 'Adventure Sports Worldwide',
                        txtSize: textSize + 6,
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
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      RecommendationContainer(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.25,
                        bottomOpacity: 0.6,
                        imagePath: 'assets/images/football.jpg',
                        // title: 'Football Stadium Tours and Matches',
                        title:
                            AppLocalizations.of(context)!.exploreWorld_football,
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

                    color: fontsProv.fonts.primaryFontColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LgElevatedButton(
                    // elevatedButtonContent: 'Type a Prompt',
                    elevatedButtonContent:
                        AppLocalizations.of(context)!.button_TypePrompt,
                    buttonColor: ButtonColors.locationButton,
                    onpressed: () {
                      setState(() {
                        _isTypePrompt = true;
                        _isRecordPrompt = false;
                      });
                    },
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.2,
                    fontSize: fontsProv.fonts.textSize,
                    fontColor: Colors.white,
                    isLoading: false,
                    isBold: true,
                    isPrefixIcon: false,
                    isSuffixIcon: true,
                    suffixIcon: Icons.keyboard,
                    suffixIconColor: Colors.white,
                    suffixIconSize: fontsProv.fonts.headingSize,
                    curvatureRadius: 10,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  // LgElevatedButton(
                  //   elevatedButtonContent: 'Record a Prompt',
                  //   buttonColor: ButtonColors.musicButton,
                  //   onpressed: () {
                  //     setState(() {
                  //       _isRecordPrompt = true;
                  //       _isTypePrompt = false;
                  //     });
                  //   },
                  //   height: MediaQuery.of(context).size.height * 0.08,
                  //   width: MediaQuery.of(context).size.width * 0.2,
                  //   fontSize: fontsProv.fonts.textSize,
                  //   fontColor: Colors.white,
                  //   isLoading: false,
                  //   isBold: true,
                  //   isPrefixIcon: false,
                  //   isSuffixIcon: true,
                  //   suffixIcon: Icons.mic,
                  //   suffixIconColor: Colors.white,
                  //   suffixIconSize: fontsProv.fonts.headingSize,
                  //   curvatureRadius: 10,
                  // ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              if (_isTypePrompt)
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
                                  PromptsSharedPref.getPlaces(query)
                                      .then((value) async {
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
                                          await APIKeySharedPref
                                              .getDefaultApiKey('Gemini');
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
                                                    AppLocalizations.of(
                                                            context)!
                                                        .settings_apiKeyNotSetDefaultError,
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
                                        String res = await GeminiServices()
                                            .checkAPIValidity(apiKey, context);

                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (res == '') {
                                          Locale locale =
                                              await SettingsSharedPref
                                                  .getLocale();
                                          showStreamingGeminiDialog(context,
                                              query, '', '', apiKey, locale);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                backgroundColor:
                                                    LgAppColors.lgColor2,
                                                content:
                                                    Consumer<FontsProvider>(
                                                  builder:
                                                      (BuildContext context,
                                                          FontsProvider value,
                                                          Widget? child) {
                                                    return Text(
                                                      res,
                                                      style: TextStyle(
                                                        fontSize: value
                                                            .fonts.textSize,
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
                                      ? AppLocalizations.of(context)!
                                          .defaults_loading
                                      : AppLocalizations.of(context)!
                                          .defaults_generate,
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
              // if (_isRecordPrompt)
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Center(
              //       child: Container(
              //         width: MediaQuery.of(context).size.width * 0.9,
              //         height: MediaQuery.of(context).size.height * 0.3,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(
              //             color: colorProvv.colors.buttonColors,
              //             width: 4,
              //           ),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: SingleChildScrollView(
              //             child: Column(
              //               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Row(
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Expanded(
              //                       child: Text(
              //                         _isAudioProcessing
              //                             ? 'We are processing your audio to text. Please wait...'
              //                             : _isSTTFinished
              //                                 ? audioPrompt ??
              //                                     'No Text found. Please try recording again..'
              //                                 : 'Tap the microphone button to start recording.',
              //                         maxLines: 4,
              //                         style: TextStyle(
              //                           fontSize: fontsProv.fonts.textSize,
              //                           fontFamily: fontType,
              //                           ,
              //                           color: fontsProv.fonts.primaryFontColor,
              //                         ),
              //                       ),
              //                     ),
              //                     CustomRecordingButton(
              //                       isRecording: _isRecording,
              //                       onPressed: () => _record(),
              //                     ),
              //                   ],
              //                 ),
              //                 SizedBox(
              //                   height:
              //                       MediaQuery.of(context).size.height * 0.05,
              //                 ),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     LgElevatedButton(
              //                       elevatedButtonContent: 'Generate',
              //                       buttonColor: LgAppColors.lgColor4,
              //                       onpressed: () async {
              //                         ModelErrorProvider errProvider =
              //                             Provider.of<ModelErrorProvider>(
              //                                 context,
              //                                 listen: false);
              //                         errProvider.isError = false;
              //                         if (_isRecordPrompt && _isSTTFinished) {
              //                           String query =
              //                               '${audioPrompt} Worldwide';
              //                           print(query);

              //                           PromptsSharedPref.getPlaces(query)
              //                               .then((value) async {
              //                             print('value: $value');
              //                             print(value.isNotEmpty);
              //                             if (value.isNotEmpty) {
              //                               await buildQueryPlacemark(
              //                                   query, '', '', context);
              //                               showVisualizationDialog(
              //                                   context,
              //                                   value,
              //                                   query,
              //                                   '',
              //                                   '',
              //                                   () {},
              //                                   false);
              //                             } else {
              //                               //Local
              //                               // Connectionprovider connection =
              //                               //     Provider.of<Connectionprovider>(context,
              //                               //         listen: false);
              //                               // if (!connection.isAiConnected) {
              //                               //   dialogBuilder(
              //                               //       context,
              //                               //       'NOT connected to AI Server!!\nPlease Connect!',
              //                               //       true,
              //                               //       'OK',
              //                               //       null,
              //                               //       null);
              //                               // } else {
              //                               //   showStreamingDialog(
              //                               //       context, query, '', '');
              //                               // }
              //                               //Gemini:
              //                               ApiKeyModel? apiKeyModel =
              //                                   await APIKeySharedPref
              //                                       .getDefaultApiKey('Gemini');
              //                               String apiKey;
              //                               if (apiKeyModel == null) {
              //                                 //snackbar:
              //                                 ScaffoldMessenger.of(context)
              //                                     .showSnackBar(
              //                                   SnackBar(
              //                                       backgroundColor:
              //                                           LgAppColors.lgColor2,
              //                                       content:
              //                                           Consumer<FontsProvider>(
              //                                         builder: (BuildContext
              //                                                 context,
              //                                             FontsProvider value,
              //                                             Widget? child) {
              //                                           return Text(
              //                                             // 'Please add a default API Key for Gemini in the settings!',
              //                                             AppLocalizations.of(
              //                                                     context)!
              //                                                 .settings_apiKeyNotSetDefaultError,
              //                                             style: TextStyle(
              //                                               fontSize: value
              //                                                   .fonts.textSize,
              //                                               color: Colors.white,
              //                                               fontFamily:
              //                                                   fontType,
              //                                             ),
              //                                           );
              //                                         },
              //                                       )),
              //                                 );
              //                               } else {
              //                                 apiKey = apiKeyModel.key;
              //                                 setState(() {
              //                                   _isLoading = true;
              //                                 });
              //                                 String res =
              //                                     await LangchainService()
              //                                         .checkAPIValidity(
              //                                             apiKey, context);

              //                                 setState(() {
              //                                   _isLoading = false;
              //                                 });
              //                                 if (res == '') {
              //                                   Locale locale =
              //                                       await SettingsSharedPref
              //                                           .getLocale();
              //                                   showStreamingGeminiDialog(
              //                                       context,
              //                                       query,
              //                                       '',
              //                                       '',
              //                                       apiKey,
              //                                       locale);
              //                                 } else {
              //                                   ScaffoldMessenger.of(context)
              //                                       .showSnackBar(
              //                                     SnackBar(
              //                                         backgroundColor:
              //                                             LgAppColors.lgColor2,
              //                                         content: Consumer<
              //                                             FontsProvider>(
              //                                           builder: (BuildContext
              //                                                   context,
              //                                               FontsProvider value,
              //                                               Widget? child) {
              //                                             return Text(
              //                                               res,
              //                                               style: TextStyle(
              //                                                 fontSize: value
              //                                                     .fonts
              //                                                     .textSize,
              //                                                 color:
              //                                                     Colors.white,
              //                                                 fontFamily:
              //                                                     fontType,
              //                                               ),
              //                                             );
              //                                           },
              //                                         )),
              //                                   );
              //                                 }
              //                               }
              //                             }
              //                             ;
              //                           });
              //                         } else {
              //                           //snack bar:
              //                           ScaffoldMessenger.of(context)
              //                               .showSnackBar(
              //                             SnackBar(
              //                               backgroundColor:
              //                                   LgAppColors.lgColor2,
              //                               content: Consumer<FontsProvider>(
              //                                 builder: (BuildContext context,
              //                                     FontsProvider value,
              //                                     Widget? child) {
              //                                   return Text(
              //                                     'Please record a prompt first!',
              //                                     // AppLocalizations.of(context)!
              //                                     //     .exploreWorld_recordPromptError,
              //                                     style: TextStyle(
              //                                       fontSize:
              //                                           value.fonts.textSize,
              //                                       color: Colors.white,
              //                                       fontFamily: fontType,
              //                                     ),
              //                                   );
              //                                 },
              //                               ),
              //                             ),
              //                           );
              //                         }
              //                       },
              //                       height: MediaQuery.of(context).size.height *
              //                           0.05,
              //                       width:
              //                           MediaQuery.of(context).size.width * 0.2,
              //                       fontSize: fontsProv.fonts.textSize,
              //                       fontColor: Colors.white,
              //                       isLoading: false,
              //                       isBold: true,
              //                       isPrefixIcon: false,
              //                       isSuffixIcon: true,
              //                       suffixIcon: Icons.done_all,
              //                       suffixIconColor: Colors.white,
              //                       suffixIconSize: 30,
              //                       curvatureRadius: 30,
              //                     ),
              //                     SizedBox(
              //                         width: MediaQuery.of(context).size.width *
              //                             0.05),
              //                     LgElevatedButton(
              //                       elevatedButtonContent: 'Clear',
              //                       buttonColor: LgAppColors.lgColor2,
              //                       onpressed: () {
              //                         setState(() {
              //                           _isAudioProcessing = false;
              //                           _isSTTFinished = false;
              //                           _audioPath = null;
              //                           _isRecording = false;
              //                         });
              //                       },
              //                       height: MediaQuery.of(context).size.height *
              //                           0.05,
              //                       width:
              //                           MediaQuery.of(context).size.width * 0.2,
              //                       fontSize: fontsProv.fonts.textSize,
              //                       fontColor: Colors.white,
              //                       isLoading: false,
              //                       isBold: true,
              //                       isPrefixIcon: false,
              //                       isSuffixIcon: true,
              //                       suffixIcon: Icons.clear,
              //                       suffixIconColor: Colors.white,
              //                       suffixIconSize: 30,
              //                       curvatureRadius: 30,
              //                     )
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // if (_isSTTFinished) PlayerWidget(player: player),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
            ],
          );
        },
      ),
    );
  }
}
