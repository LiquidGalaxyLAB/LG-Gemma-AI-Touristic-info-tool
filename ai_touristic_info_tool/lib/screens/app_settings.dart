import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/api_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/font_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/help_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/language_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/lg_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/settings_option.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/theme_widget.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/top_bar_widget.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSettingsView extends StatefulWidget {
  const AppSettingsView({super.key});

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView> {
  Widget view = Container();
  int selectedIndex = -1;

  void updateView(Widget newView, int index) {
    setState(() {
      view = newView;
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer2<ColorProvider, FontsProvider>(
          builder: (BuildContext context, ColorProvider value,
              FontsProvider fontProv, Widget? child) {
            return TopBarWidget(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 1,
              // grad1: value.colors.gradient1,
              // grad2: value.colors.gradient2,
              // grad3: value.colors.gradient3,
              // grad4: value.colors.gradient4,
              grad1: SettingsSharedPref.getTheme() == 'light'
                  ? value.colors.buttonColors
                  : value.colors.gradient1,
              grad2: SettingsSharedPref.getTheme() == 'light'
                  ? value.colors.buttonColors
                  : value.colors.gradient2,
              grad3: SettingsSharedPref.getTheme() == 'light'
                  ? value.colors.buttonColors
                  : value.colors.gradient3,
              grad4: SettingsSharedPref.getTheme() == 'light'
                  ? value.colors.buttonColors
                  : value.colors.gradient4,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/settings.png",
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: FontAppColors.secondaryFont,
                  ),
                  Center(
                    child: Text(
                      'App Settings',
                      style: TextStyle(
                        fontFamily: fontType,
                        fontSize: fontProv.fonts.headingSize,
                        // color: FontAppColors.secondaryFont,
                        color: SettingsSharedPref.getTheme() == 'dark'
                            ? fontProv.fonts.primaryFontColor
                            : fontProv.fonts.secondaryFontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Consumer2<ColorProvider, FontsProvider>(
          builder: (BuildContext context, ColorProvider value,
              FontsProvider fontProv, Widget? child) {
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 0, left: 20, right: 20),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.68,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        // color: PrimaryAppColors.shadow,
                        color: value.colors.shadow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SettingsOptionButton(
                            buttonText: 'Language',
                            buttonDescription: 'Change the language of the app',
                            icon: Icons.translate,
                            view: LanguageWidget(),
                            index: 0,
                            selectedIndex: selectedIndex,
                            onPressed: updateView,
                          ),
                          SettingsOptionButton(
                            buttonText: 'Appearance',
                            buttonDescription: 'Change the theme of the app',
                            icon: Icons.palette,
                            view: ThemeWidget(),
                            index: 1,
                            selectedIndex: selectedIndex,
                            onPressed: updateView,
                          ),
                          SettingsOptionButton(
                            buttonText: 'Font Size',
                            buttonDescription:
                                'Change the font size of the app',
                            icon: Icons.format_size,
                            view: FontWidget(),
                            index: 2,
                            selectedIndex: selectedIndex,
                            onPressed: updateView,
                          ),
                          SettingsOptionButton(
                            buttonText: 'Liquid Galaxy',
                            buttonDescription: 'Learn about Liquid Galaxy',
                            icon: Icons.view_column_rounded,
                            view: LGWidget(),
                            index: 3,
                            selectedIndex: selectedIndex,
                            onPressed: updateView,
                          ),
                          SettingsOptionButton(
                            buttonText: 'API Keys',
                            buttonDescription: 'Manage the API keys of the app',
                            icon: Icons.vpn_key,
                            view: APIWidget(),
                            index: 4,
                            selectedIndex: selectedIndex,
                            onPressed: updateView,
                          ),
                          SettingsOptionButton(
                            buttonText: 'Help',
                            buttonDescription: 'Learn how to use the app',
                            icon: Icons.help,
                            view: HelpWidget(),
                            index: 5,
                            selectedIndex: selectedIndex,
                            onPressed: updateView,
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 0, left: 0, right: 10),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.68,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        // color: PrimaryAppColors.shadow,
                        color: value.colors.shadow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: selectedIndex == -1
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 100,
                                      color: value.colors.gradient1,
                                    ),
                                    SizedBox(height: 20),
                                    Center(
                                      child: Text(
                                        'Welcome to the App Settings!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // fontSize: textSize + 10,
                                          fontSize:
                                              fontProv.fonts.textSize + 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: fontType,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    Text(
                                      'Select an option from the left to view and modify your app settings. '
                                      'You can change the language, appearance, font size, learn about Liquid Galaxy, manage API keys, and access help resources.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        // fontSize: textSize,
                                        fontSize: fontProv.fonts.textSize,
                                        fontFamily: fontType,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : view),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
