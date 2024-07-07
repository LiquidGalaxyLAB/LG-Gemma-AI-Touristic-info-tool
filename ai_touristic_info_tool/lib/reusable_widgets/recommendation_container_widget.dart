import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/api.dart';
import 'package:ai_touristic_info_tool/helpers/prompts_shared_pref.dart';
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
            //call gemma api
            _showStreamingDialog(context, query);
            // await Api().postGemma(
            //     endpoint: 'rag/stream_events', input: 'Landmarks in Edinburgh Scotland');
            // .then((value) async {
            // print('value: $value');
            // await buildQueryPlacemark(title, city, country, context);
            // showVisualizationDialog(context, value, title, city, country);
            //});
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StreamDialog(query: query);
      },
    );
  }
}

class StreamDialog extends StatefulWidget {
  final String query;

  const StreamDialog({Key? key, required this.query}) : super(key: key);

  @override
  _StreamDialogState createState() => _StreamDialogState();
}

class _StreamDialogState extends State<StreamDialog> {
  // String _output = '';
  Map<String, dynamic> _output = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startStreaming();
  }

  void _startStreaming() async {
    await Api()
        .postGemma(
      endpoint: 'rag/stream_events',
      input: widget.query,
    )
        .then((value) {
      setState(() {
        _output = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Streaming Response'),
      content: SingleChildScrollView(
        child:
            _isLoading ? CircularProgressIndicator() : Text('done: $_output'),
      ),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
