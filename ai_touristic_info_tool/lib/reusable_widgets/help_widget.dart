import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/show_case_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class HelpWidget extends StatefulWidget {
  const HelpWidget({super.key});

  @override
  State<HelpWidget> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontProv,
          ColorProvider colorProv, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Help Page',
                style: TextStyle(
                  fontSize: fontProv.fonts.headingSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontType,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Text(
                  'Tap the button below to view the app tutorial!',
                  style: TextStyle(
                    fontSize: fontProv.fonts.textSize,
                    color: Colors.black,
                    fontFamily: fontType,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              GestureDetector(
                onTap: () {},
                child: Image.asset("assets/images/help.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2),
              ),
              // LGShowCaseWidget(
              //   showCaseKey: GlobalKeys.showcaseKeyStartShowCase,
              //   height: MediaQuery.of(context).size.height * 0.1,
              //   width: MediaQuery.of(context).size.width * 0.2,
              //   targetShape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(40.0)),
              //   showCaseWidget: GestureDetector(
              //     onTap: () {
              //       ShowCaseWidget.of(context).startShowCase([
              //         GlobalKeys.showcaseKeyLanguages,
              //         GlobalKeys.showcaseKeyAppearance,
              //         GlobalKeys.showcaseKeyFontSize,
              //         GlobalKeys.showcaseKeyLiquidGalaxy,
              //         GlobalKeys.showcaseKeyAPIKeys,
              //         GlobalKeys.showcaseKeyHelp,
              //       ]);
              //     },
              //     child: Image.asset("assets/images/help.png",
              //         height: MediaQuery.of(context).size.height * 0.2,
              //         width: MediaQuery.of(context).size.width * 0.2),
              //   ),
              //   title: 'Tutorial',
              //   description: 'Tap the button below to view the app tutorial!',
              // ),
            ],
          ),
        );
      },
    );
  }
}
