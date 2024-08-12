import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_elevated_button.dart';
import 'package:ai_touristic_info_tool/state_management/current_view_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LGWidget extends StatefulWidget {
  const LGWidget({super.key});

  @override
  State<LGWidget> createState() => _LGWidgetState();
}

class _LGWidgetState extends State<LGWidget> {
  @override
  Widget build(BuildContext context) {
    CurrentViewProvider currViewProvider =
        Provider.of<CurrentViewProvider>(context, listen: true);

    return Consumer2<FontsProvider, ColorProvider>(
      builder: (BuildContext context, FontsProvider fontProv,
          ColorProvider colorProv, Widget? child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                // 'About Liquid Galaxy',
                AppLocalizations.of(context)!.settingsLG_title,
                style: TextStyle(
                  fontSize: fontProv.fonts.headingSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontType,
                ),
              ),
              Image.asset(
                "assets/images/lg-trans.png",
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  // 'Liquid Galaxy is a multi-screen, immersive system that offers panoramic views by syncing multiple displays. Originally a Google project, it allows users to explore locations in a seamless, 360-degree experience',
                  AppLocalizations.of(context)!.settingsLG_desc,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: fontProv.fonts.textSize,
                    color: Colors.black,
                    fontFamily: fontType,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LgElevatedButton(
                    // elevatedButtonContent: 'Learn about LG',
                    elevatedButtonContent: AppLocalizations.of(context)!.settingsLG_learnButton,
                    buttonColor: colorProv.colors.buttonColors,
                    onpressed: () {
                      launchUrlString('https://www.liquidgalaxy.eu/');
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.18,
                    fontSize: fontProv.fonts.textSize,
                    fontColor: Colors.white,
                    isLoading: false,
                    isBold: false,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 10,
                  ),
                  LgElevatedButton(
                    // elevatedButtonContent: 'Set up an LG Rig',
                    elevatedButtonContent: AppLocalizations.of(context)!.settingsLG_setupRigButton,
                    buttonColor: colorProv.colors.buttonColors,
                    onpressed: () {
                      launchUrlString(
                          'https://youtu.be/jz-QZi__10c?si=vmzgAclLC6Almkaj');
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.18,
                    fontSize: fontProv.fonts.textSize,
                    fontColor: Colors.white,
                    isLoading: false,
                    isBold: false,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 10,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LgElevatedButton(
                    // elevatedButtonContent: 'Connet to LG',
                    elevatedButtonContent: AppLocalizations.of(context)!.settingsLG_connectButton,
                    buttonColor: colorProv.colors.buttonColors,
                    onpressed: () {
                      currViewProvider.currentView = 'connection';
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.18,
                    fontSize: fontProv.fonts.textSize,
                    fontColor: Colors.white,
                    isLoading: false,
                    isBold: false,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 10,
                  ),
                  LgElevatedButton(
                    // elevatedButtonContent: 'Control the LG',
                    elevatedButtonContent: AppLocalizations.of(context)!.settingsLG_controlLG,
                    buttonColor: colorProv.colors.buttonColors,
                    onpressed: () {
                      currViewProvider.currentView = 'tasks';
                    },
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.18,
                    fontSize: fontProv.fonts.textSize,
                    fontColor: Colors.white,
                    isLoading: false,
                    isBold: false,
                    isPrefixIcon: false,
                    isSuffixIcon: false,
                    curvatureRadius: 10,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        );
      },
    );
  }
}
