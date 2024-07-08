import 'dart:async';

import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/api.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/utils/kml_builders.dart';
import 'package:ai_touristic_info_tool/utils/visualization_dialog.dart';
import 'package:flutter/material.dart';

class RecommendationContainer extends StatelessWidget {
  final String imagePath;
  final String title; //query
  final String? country; //query
  final String? city; //query
  final String query;
  final String? description;
  final double width;
  final double height;
  final double txtSize;
  final double? descriptionSize;
  final double bottomOpacity;
  const RecommendationContainer(
      {super.key,
      required this.imagePath,
      required this.title,
      this.country,
      this.city,
      required this.query,
      this.description,
      required this.width,
      required this.height,
      required this.txtSize,
      this.descriptionSize,
      required this.bottomOpacity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('query: $query');

        PromptsSharedPref.getPlaces(query).then((value) async {
          print('value: $value');
          print(value.isNotEmpty);
          if (value.isNotEmpty) {
            await buildQueryPlacemark(title, city, country, context);
            showVisualizationDialog(context, value, title, city, country);
          } else {
            _showStreamingDialog(context, query);
          }
        });
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: PrimaryAppColors.buttonColors, width: 4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(bottomOpacity),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: FontAppColors.secondaryFont,
                      fontWeight: FontWeight.bold,
                      fontSize: txtSize,
                      fontFamily: fontType,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description!,
                      style: TextStyle(
                        color: FontAppColors.secondaryFont,
                        fontSize: txtSize,
                        fontFamily: fontType,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStreamingDialog(BuildContext context, String query) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: FontAppColors.secondaryFont,
            shadowColor: FontAppColors.secondaryFont,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            // insetPadding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            titlePadding: const EdgeInsets.only(bottom: 20),
            contentPadding: EdgeInsets.zero,
            actionsPadding: const EdgeInsets.only(bottom: 10),
            surfaceTintColor: FontAppColors.secondaryFont,
            title: Center(
              child: Text('Processing ...',
                  style: TextStyle(
                    color: FontAppColors.primaryFont,
                    fontSize: headingSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontType,
                  )),
            ),
            content: ProcessContainerWidget(
              query: query,
            ));
      },
    );
  }
}

class ProcessContainerWidget extends StatefulWidget {
  final String query;
  final String city;
  final String country;
  const ProcessContainerWidget(
      {super.key, required this.query, this.city = '', this.country = ''});

  @override
  State<ProcessContainerWidget> createState() => _ProcessContainerWidgetState();
}

class _ProcessContainerWidgetState extends State<ProcessContainerWidget> {
  late StreamController<dynamic> _messageController;
  late StreamController<dynamic> _chunkController;
  final List<String> _words = [];
  final List<PlacesModel> _pois = [];
  int _currProgress = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _messageController = StreamController();
    _chunkController = StreamController();

    Api().postaStreamEventsGemma(input: widget.query).listen((event) {
      setState(() {
        if (event['type'] == 'chunk') {
          _chunkController.sink.add(event['data']);
        } else if (event['type'] == 'message') {
          _currProgress++;
          _messageController.sink.add(event['data']);
        } else if (event['type'] == 'result') {
          _isFinished = true;
          _pois.addAll(event['data']);
        }
      });
    });
  }

  // Api().postaStreamEventsGemma(input: query).listen((event) {
  //   if (event['type'] == 'chunk') {
  //     _chunkController.sink.add(event['data']);
  //   } else if (event['type'] == 'message') {
  //     _currProgress++;
  //     _messageController.sink.add(event['data']);
  //   } else if (event['type'] == 'result') {
  //     _isFinished = true;
  //     _pois.addAll(event['data']);
  //   }
  // });

  @override
  void dispose() {
    _messageController.close();
    _chunkController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 30, right: 30, bottom: 10),
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.8,
                child: StreamBuilder<dynamic>(
                  stream: _messageController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Please wait... ',
                        style: TextStyle(
                          color: FontAppColors.primaryFont,
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontType,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: FontAppColors.primaryFont,
                          fontSize: textSize,
                          fontFamily: fontType,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                          color: FontAppColors.primaryFont,
                          fontSize: textSize,
                          fontFamily: fontType,
                        ),
                      );
                    } else {
                      return Text(
                        'No data available',
                        style: TextStyle(
                          color: FontAppColors.primaryFont,
                          fontSize: textSize,
                          fontFamily: fontType,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: PrimaryAppColors.gradient1, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: LinearProgressIndicator(
                value: _currProgress / 7,
                backgroundColor: FontAppColors.secondaryFont.withOpacity(0.5),
                valueColor:
                    AlwaysStoppedAnimation<Color>(PrimaryAppColors.accentColor),
              ),
            ),
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: PrimaryAppColors.gradient1, width: 4),
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(111, 184, 184, 187),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: StreamBuilder<dynamic>(
                              stream: _chunkController.stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  //return CircularProgressIndicator();
                                  return Text(
                                    'Waiting for stream. Please wait... ',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontType,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  _words.add(snapshot.data!.toString());
                                  return Text(
                                    _words.join(' '),
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'No data available',
                                    style: TextStyle(
                                      color: FontAppColors.primaryFont,
                                      fontSize: textSize,
                                      fontFamily: fontType,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        textAlign: TextAlign.justify,
                        'Please Note that the model takes on Average 10 minutes to answer.\n\nThank you for your patience!',
                        style: TextStyle(
                          color: LgAppColors.lgColor2,
                          fontSize: textSize + 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontType,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/wait.gif', // Replace with your actual asset path
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                    // You can also adjust other properties like width, height, etc.
                  ),
                  if (_isFinished)
                    LgElevatedButton(
                        elevatedButtonContent: 'Visualize now!',
                        buttonColor: PrimaryAppColors.buttonColors,
                        onpressed: () async {
                          Navigator.pop(context);
                          //need to check on city or country non-existing
                          // await buildQueryPlacemark(
                          //     title, city, country, context);
                          showVisualizationDialog(context, _pois, widget.query,
                              widget.city, widget.country);
                        },
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.2,
                        fontSize: textSize,
                        fontColor: FontAppColors.secondaryFont,
                        isLoading: false,
                        isBold: true,
                        isPrefixIcon: false,
                        isSuffixIcon: false,
                        curvatureRadius: 30),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
