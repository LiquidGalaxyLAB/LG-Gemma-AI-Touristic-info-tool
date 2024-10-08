import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../state_management/current_view_provider.dart';
import 'navigation_item_drawer.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late bool isDefault;
  late String selected;
  late Color selectedButton;
  late Color selectedText;
  late Color unselectedButton;
  late Color unselectedText;

  @override
  void initState() {
    super.initState();
    ColorProvider colorProv =
        Provider.of<ColorProvider>(context, listen: false);
    print(colorProv.colors.buttonColors);
    isDefault = true;
    selected = 'home';
    selectedButton = colorProv.colors.buttonColors;
    selectedText = FontAppColors.secondaryFont;
    unselectedButton = colorProv.colors.innerBackground;
    if (SettingsSharedPref.getTheme() == 'dark') {
      unselectedText = FontAppColors.secondaryFont;
    } else {
      unselectedText = FontAppColors.primaryFont;
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentViewProvider currViewProvider =
        Provider.of<CurrentViewProvider>(context, listen: true);
    ColorProvider colorProv =
        Provider.of<ColorProvider>(context, listen: false);

    if (currViewProvider.currentView == 'settings') {
      setState(() {
        selected = 'settings';
        isDefault = false;
      });
    }
    if (currViewProvider.currentView == 'connection') {
      setState(() {
        selected = 'connection';
        isDefault = false;
      });
    }
    if (currViewProvider.currentView == 'tasks') {
      setState(() {
        selected = 'tasks';
        isDefault = false;
      });
    }
    if (currViewProvider.currentView == 'home') {
      setState(() {
        selected = 'home';
        isDefault = false;
      });
    }
    if (currViewProvider.currentView == 'favs') {
      setState(() {
        selected = 'favs';
        isDefault = false;
      });
    }
    if (currViewProvider.currentView == 'about') {
      setState(() {
        selected = 'about';
        isDefault = false;
      });
    }

    return Consumer<ColorProvider>(
      builder: (BuildContext context, ColorProvider value, Widget? child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.13,
          bottom: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.width * 0.01,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.09,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: value.colors.innerBackground),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: NavigationItem(
                        key: GlobalKeys.showcaseKeyHome,
                        imagePath: 'assets/images/home.png',
                        topLeftCurve: 20,
                        topRightCurve: 20,
                        bottomLeftCurve: 0,
                        bottomRightCurve: 0,
                        icondata: Icons.home,
                        title: AppLocalizations.of(context)!.appDrawer_home,
                        containerColor: isDefault || selected == 'home'
                            ? value.colors.buttonColors
                            : value.colors.innerBackground,
                        color: isDefault || selected == 'home'
                            ? colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.secondaryFont
                            : colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.primaryFont,
                        onPressed: () {
                          setState(() {
                            selected = 'home';
                            isDefault = false;
                            currViewProvider.currentView = 'home';
                          });
                        }),
                  ),
                  Expanded(
                    child: NavigationItem(
                        key: GlobalKeys.showcaseKeyConnectionManager,
                        imagePath: 'assets/images/connection.png',
                        topLeftCurve: 0,
                        topRightCurve: 0,
                        bottomLeftCurve: 0,
                        bottomRightCurve: 0,
                        icondata: Icons.wifi,
                        title:
                            AppLocalizations.of(context)!.appDrawer_connection,
                        containerColor: selected == 'connection'
                            ? value.colors.buttonColors
                            : value.colors.innerBackground,
                        color: selected == 'connection'
                            ? colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.secondaryFont
                            : colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.primaryFont,
                        onPressed: () {
                          setState(() {
                            selected = 'connection';
                            isDefault = false;
                            currViewProvider.currentView = 'connection';
                          });
                        }),
                  ),
                  Expanded(
                    child: NavigationItem(
                        key: GlobalKeys.showcaseKeyLGTasks,
                        topLeftCurve: 0,
                        topRightCurve: 0,
                        bottomLeftCurve: 0,
                        bottomRightCurve: 0,
                        imagePath: 'assets/images/lgTasks.png',
                        icondata: Icons.task,
                        title: AppLocalizations.of(context)!.appDrawer_tasks,
                        containerColor: selected == 'tasks'
                            ? value.colors.buttonColors
                            : value.colors.innerBackground,
                        color: selected == 'tasks'
                            ? colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.secondaryFont
                            : colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.primaryFont,
                        onPressed: () {
                          setState(() {
                            selected = 'tasks';
                            isDefault = false;
                            currViewProvider.currentView = 'tasks';
                          });
                        }),
                  ),
                  Expanded(
                    child: NavigationItem(
                        key: GlobalKeys.showcaseKeyFavs,
                        topLeftCurve: 0,
                        topRightCurve: 0,
                        bottomLeftCurve: 0,
                        bottomRightCurve: 0,
                        imagePath: 'assets/images/fav.png',
                        icondata: Icons.favorite,
                        title: AppLocalizations.of(context)!.appDrawer_favs,
                        containerColor: selected == 'favs'
                            ? value.colors.buttonColors
                            : value.colors.innerBackground,
                        color: selected == 'favs'
                            ? colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.secondaryFont
                            : colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.primaryFont,
                        onPressed: () {
                          setState(() {
                            selected = 'favs';
                            isDefault = false;
                            currViewProvider.currentView = 'favs';
                          });
                        }),
                  ),
                  Expanded(
                    child: NavigationItem(
                        key: GlobalKeys.showcaseKeySettings,
                        topLeftCurve: 0,
                        topRightCurve: 0,
                        bottomLeftCurve: 0,
                        bottomRightCurve: 0,
                        imagePath: 'assets/images/settings.png',
                        icondata: Icons.settings,
                        title: AppLocalizations.of(context)!.appDrawer_settings,
                        containerColor: selected == 'settings'
                            ? value.colors.buttonColors
                            : value.colors.innerBackground,
                        color: selected == 'settings'
                            ? colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.secondaryFont
                            : colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.primaryFont,
                        onPressed: () {
                          setState(() {
                            selected = 'settings';
                            isDefault = false;
                            currViewProvider.currentView = 'settings';
                          });
                        }),
                  ),
                  Expanded(
                    child: NavigationItem(
                        key: GlobalKeys.showcaseKeyAbout,
                        topLeftCurve: 0,
                        topRightCurve: 0,
                        bottomLeftCurve: 20,
                        bottomRightCurve: 20,
                        imagePath: 'assets/images/about.png',
                        icondata: Icons.info,
                        title: 'About',
                        containerColor: selected == 'about'
                            ? value.colors.buttonColors
                            : value.colors.innerBackground,
                        color: selected == 'about'
                            ? colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.secondaryFont
                            : colorProv.theme == 'dark'
                                ? FontAppColors.secondaryFont
                                : FontAppColors.primaryFont,
                        onPressed: () {
                          setState(() {
                            selected = 'about';
                            isDefault = false;
                            currViewProvider.currentView = 'about';
                          });
                        }),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
