import 'package:ai_touristic_info_tool/reusable_widgets/connection_indicator.dart';
import 'package:ai_touristic_info_tool/utils/show_ai_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../state_management/connection_provider.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15,
      left: 50,
      right: 50,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/appLogo.png',
            width: 80,
            height: 80,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'LG Touristic info tool ',
                  style: TextStyle(
                      fontFamily: fontType,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: FontAppColors.secondaryFont),
                ),
                TextSpan(
                  text: 'made with',
                  style: TextStyle(
                      fontFamily: fontType,
                      fontSize: titleSize - 15,
                      fontWeight: FontWeight.bold,
                      color: FontAppColors.secondaryFont),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
          Image.asset(
            'assets/images/gemma2.webp',
            width: 120,
            height: 80,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Consumer<Connectionprovider>(builder: (context, connection, _) {
            return const ConnectionIndicator();
          }),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            decoration: BoxDecoration(
              color: FontAppColors.secondaryFont,
              borderRadius: BorderRadius.circular(100),
            ),
            child: GestureDetector(
              onTap: () {
                showAIAlert(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.warning_amber_outlined,
                  color: LgAppColors.lgColor3,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
