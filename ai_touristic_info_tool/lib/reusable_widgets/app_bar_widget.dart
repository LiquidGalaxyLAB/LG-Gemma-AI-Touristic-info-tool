import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/connection_indicator.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image.asset(
          //   'assets/images/appLogo.png',
          //   width: 80,
          //   height: 80,
          // ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.03,
          // ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/appLogo.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Consumer<FontsProvider>(builder: (BuildContext context,
                      FontsProvider value, Widget? child) {
                    return RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'LG Touristic info tool ',
                            style: TextStyle(
                              fontFamily: fontType,
                              // fontSize: titleSize,
                              fontSize: value.fonts.titleSize,
                              fontWeight: FontWeight.bold,
                              // color: FontAppColors.secondaryFont
                              color: SettingsSharedPref.getTheme() == 'default'
                                  ? value.fonts.secondaryFontColor
                                  : value.fonts.primaryFontColor,
                            ),
                          ),
                          TextSpan(
                            text: 'made with',
                            style: TextStyle(
                                fontFamily: fontType,
                                // fontSize: titleSize - 15,
                                fontSize: value.fonts.titleSize - 15,
                                fontWeight: FontWeight.bold,
                                // color: FontAppColors.secondaryFont,
                                // color: value.fonts.secondaryFontColor,
                                color:
                                    SettingsSharedPref.getTheme() == 'default'
                                        ? value.fonts.secondaryFontColor
                                        : value.fonts.primaryFontColor),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Image.asset(
                    'assets/images/gemma.png',
                    width: 100,
                    height: 60,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.01,
          // ),
          // Image.asset(
          //   'assets/images/gemma2.webp',
          //   width: 120,
          //   height: 80,
          // ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.1,
          // ),
          // Expanded(
          //   child: Container(),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
        ],
      ),
    );
  }
}
