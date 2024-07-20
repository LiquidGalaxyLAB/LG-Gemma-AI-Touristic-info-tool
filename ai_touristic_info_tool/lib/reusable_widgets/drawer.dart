import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/state_management/dynamic_colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    unselectedText = FontAppColors.primaryFont;
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
    return Consumer<ColorProvider>(
      builder: (BuildContext context, ColorProvider value, Widget? child) {
        return Positioned(
          top: 100,
          bottom: 30,
          left: 20,
          width: 100,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavigationItem(
                      imagePath: 'assets/images/home.png',
                      title: 'Home',
                      // containerColor: isDefault || selected == 'home'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: isDefault || selected == 'home'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      color: isDefault || selected == 'home'
                          ? selectedText
                          : unselectedText,
                      onPressed: () {
                        setState(() {
                          selected = 'home';
                          isDefault = false;
                          currViewProvider.currentView = 'home';
                        });
                      }),
                  NavigationItem(
                      imagePath: 'assets/images/connection.png',
                      title: 'Connection Manager',
                      // containerColor: selected == 'connection'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'connection'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      color: selected == 'connection'
                          ? selectedText
                          : unselectedText,
                      onPressed: () {
                        setState(() {
                          selected = 'connection';
                          isDefault = false;
                          currViewProvider.currentView = 'connection';
                        });
                      }),
                  NavigationItem(
                      imagePath: 'assets/images/lgTasks.png',
                      title: 'LG Tasks',
                      // containerColor: selected == 'tasks'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'tasks'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      color:
                          selected == 'tasks' ? selectedText : unselectedText,
                      onPressed: () {
                        setState(() {
                          selected = 'tasks';
                          isDefault = false;
                          currViewProvider.currentView = 'tasks';
                        });
                      }),
                  NavigationItem(
                      imagePath: 'assets/images/fav.png',
                      title: 'Favorites',
                      // containerColor: selected == 'favs'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'favs'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      color: selected == 'favs' ? selectedText : unselectedText,
                      onPressed: () {
                        setState(() {
                          selected = 'favs';
                          isDefault = false;
                          currViewProvider.currentView = 'favs';
                        });
                      }),
                  NavigationItem(
                      imagePath: 'assets/images/settings.png',
                      title: 'Settings',
                      // containerColor: selected == 'settings'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'settings'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      color: selected == 'settings'
                          ? selectedText
                          : unselectedText,
                      onPressed: () {
                        setState(() {
                          selected = 'settings';
                          isDefault = false;
                          currViewProvider.currentView = 'settings';
                        });
                      }),
                  NavigationItem(
                      imagePath: 'assets/images/about.png',
                      title: 'About',
                      // containerColor: selected == 'about'
                      //     ? selectedButton
                      //     : unselectedButton,
                      containerColor: selected == 'about'
                          ? value.colors.buttonColors
                          : value.colors.innerBackground,
                      color:
                          selected == 'about' ? selectedText : unselectedText,
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
