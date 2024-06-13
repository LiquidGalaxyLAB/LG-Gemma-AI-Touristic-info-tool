import 'package:ai_touristic_info_tool/constants.dart';
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
  // Color homeColor = FontAppColors.primaryFont;
  // Color connectionColor = FontAppColors.primaryFont;
  // Color tasksColor = FontAppColors.primaryFont;
  // Color settingsColor = FontAppColors.primaryFont;
  bool isDefault = true;
  String selected = 'home';
  Color selectedButton = PrimaryAppColors.buttonColors;
  Color selectedText = FontAppColors.secondaryFont;
  Color unselectedButton = PrimaryAppColors.innerBackground;
  Color unselectedText = FontAppColors.primaryFont;

  @override
  Widget build(BuildContext context) {
    CurrentViewProvider currViewProvider =
        Provider.of<CurrentViewProvider>(context, listen: true);

    if (currViewProvider.currentView == 'settings') {
      setState(() {
        selected = 'settings';
        isDefault = false;
      });
    }
    return Positioned(
      top: 100,
      bottom: 30,
      left: 20,
      width: 100,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          NavigationItem(
              imagePath: 'assets/images/home.png',
              title: 'Home',
              containerColor: isDefault || selected == 'home'
                  ? selectedButton
                  : unselectedButton,
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
              containerColor:
                  selected == 'connection' ? selectedButton : unselectedButton,
              color: selected == 'connection' ? selectedText : unselectedText,
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
              containerColor:
                  selected == 'tasks' ? selectedButton : unselectedButton,
              color: selected == 'tasks' ? selectedText : unselectedText,
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
              containerColor:
                  selected == 'favs' ? selectedButton : unselectedButton,
              color: selected == 'favs' ? selectedText : unselectedText,
              onPressed: () {
                setState(() {
                  selected = 'favs';
                  isDefault = false;
                  currViewProvider.currentView = 'favorites';
                });
              }),
          NavigationItem(
              imagePath: 'assets/images/settings.png',
              title: 'Settings',
              containerColor:
                  selected == 'settings' ? selectedButton : unselectedButton,
              color: selected == 'settings' ? selectedText : unselectedText,
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
              containerColor:
                  selected == 'about' ? selectedButton : unselectedButton,
              color: selected == 'about' ? selectedText : unselectedText,
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
  }
}
