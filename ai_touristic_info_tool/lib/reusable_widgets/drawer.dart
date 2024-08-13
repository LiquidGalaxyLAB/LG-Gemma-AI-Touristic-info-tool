import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/helpers/settings_shared_pref.dart';
import 'package:ai_touristic_info_tool/helpers/show_case_keys.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_fonts_provider.dart';
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
  // bool isDefault = true;
  // String selected = 'home';
  // Color selectedButton = PrimaryAppColors.buttonColors;
  // Color selectedText = FontAppColors.secondaryFont;
  // Color unselectedButton = PrimaryAppColors.innerBackground;
  // Color unselectedText = FontAppColors.primaryFont;

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
    //  selectedButton = PrimaryAppColors.buttonColors;
    selectedButton = colorProv.colors.buttonColors;
    selectedText = FontAppColors.secondaryFont;
    //  unselectedButton = PrimaryAppColors.innerBackground;
    unselectedButton = colorProv.colors.innerBackground;
    if (SettingsSharedPref.getTheme() == 'dark') {
      unselectedText = FontAppColors.secondaryFont;
    } else {
      unselectedText = FontAppColors.primaryFont;
    }
    // unselectedText = FontAppColors.primaryFont;
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

    // if (colorProv.theme == 'dark') {
    //   setState(() {
    //     selectedText = FontAppColors.secondaryFont;
    //     unselectedText = FontAppColors.secondaryFont;
    //   });
    // } else {
    //   setState(() {
    //     selectedText = FontAppColors.secondaryFont;
    //     unselectedText = FontAppColors.primaryFont;
    //   });
    // }

    return Consumer<ColorProvider>(
      builder: (BuildContext context, ColorProvider value, Widget? child) {
        return Positioned(
          top: 100,
          bottom: 30,
          left: 20,
          width: 100,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: value.colors.innerBackground),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavigationItem(
                      key: GlobalKeys.showcaseKeyHome,
                      imagePath: 'assets/images/home.png',
                      // title: 'Home',
                      title: AppLocalizations.of(context)!.appDrawer_home,
                      // containerColor: isDefault || selected == 'home'
                      //     ? selectedButton
                      //     : unselectedButton,
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
                  NavigationItem(
                      key: GlobalKeys.showcaseKeyConnectionManager,
                      imagePath: 'assets/images/connection.png',
                      // title: 'Connection Manager',
                      title: AppLocalizations.of(context)!.appDrawer_connection,
                      // containerColor: selected == 'connection'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'connection'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      // color: selected == 'connection'
                      //     ? selectedText
                      //     : unselectedText,
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
                  NavigationItem(
                      key: GlobalKeys.showcaseKeyLGTasks,
                      imagePath: 'assets/images/lgTasks.png',
                      // title: 'LG Tasks',
                      title: AppLocalizations.of(context)!.appDrawer_tasks,
                      // containerColor: selected == 'tasks'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'tasks'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      // color:
                      //     selected == 'tasks' ? selectedText : unselectedText,
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
                  NavigationItem(
                      key: GlobalKeys.showcaseKeyFavs,
                      imagePath: 'assets/images/fav.png',
                      // title: 'Favorites',
                      title: AppLocalizations.of(context)!.appDrawer_favs,
                      // containerColor: selected == 'favs'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'favs'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      // color: selected == 'favs' ? selectedText : unselectedText,
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
                  NavigationItem(
                      key: GlobalKeys.showcaseKeySettings,
                      imagePath: 'assets/images/settings.png',
                      // title: 'Settings',
                      title: AppLocalizations.of(context)!.appDrawer_settings,
                      // containerColor: selected == 'settings'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'settings'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      // color: selected == 'settings'
                      //     ? selectedText
                      //     : unselectedText,
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
                  NavigationItem(
                      key: GlobalKeys.showcaseKeyAbout,
                      imagePath: 'assets/images/about.png',
                      // title: 'About',
                      title: 'About',
                      // containerColor: selected == 'about'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'about'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      // color:
                      //     selected == 'about' ? selectedText : unselectedText,
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
                ]),
          ),
        );
      },
    );
  }
}
